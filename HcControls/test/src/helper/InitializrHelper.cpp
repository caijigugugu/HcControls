#include "InitializrHelper.h"

#include <QDir>
#include <QGuiApplication>

[[maybe_unused]] InitializrHelper::InitializrHelper(QObject *parent) : QObject(parent) {
}

InitializrHelper::~InitializrHelper() = default;


bool InitializrHelper::copyDir(const QDir &fromDir, const QDir &toDir, bool coverIfFileExists) {
    const QDir &_formDir = fromDir;
    QDir _toDir = toDir;
    if (!_toDir.exists()) {
        if (!_toDir.mkdir(toDir.absolutePath()))
            return false;
    }
    QFileInfoList fileInfoList = _formDir.entryInfoList();
    foreach (QFileInfo fileInfo, fileInfoList) {
        if (fileInfo.fileName() == "." || fileInfo.fileName() == "..")
            continue;
        if (fileInfo.isDir()) {
            if (!copyDir(fileInfo.filePath(), _toDir.filePath(fileInfo.fileName()), true))
                return false;
        } else {
            if (coverIfFileExists && _toDir.exists(fileInfo.fileName())) {
                _toDir.remove(fileInfo.fileName());
            }
            if (!QFile::copy(fileInfo.filePath(), _toDir.filePath(fileInfo.fileName()))) {
                return false;
            }
        }
    }
    return true;
}

template <typename... Args>
void InitializrHelper::templateToFile(const QString &source, const QString &dest, Args &&...args) {
    QFile file(source);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        QTextStream in(&file);
        QString content = in.readAll().arg(std::forward<Args>(args)...);
        file.close();
        QDir outputDir = QFileInfo(dest).absoluteDir();
        if (!outputDir.exists()) {
            outputDir.mkpath(outputDir.absolutePath());
        }
        QFile outputFile(dest);
        if (outputFile.open(QIODevice::WriteOnly | QIODevice::Text)) {
            QTextStream out(&outputFile);
            out << content;
            outputFile.close();
        } else {
            qDebug() << "Failed to open output file.";
        }
    } else {
        qDebug() << "Failed to open resource file.";
    }
}

void InitializrHelper::copyFile(const QString &source, const QString &dest) {
    QFile::copy(source, dest);
    QFile::setPermissions(dest, QFile::WriteOwner | QFile::WriteUser | QFile::WriteGroup |
                                    QFile::WriteOther);
}

[[maybe_unused]] void InitializrHelper::generate(const QString &name, const QString &path) {
    if (name.isEmpty()) {
        error(tr("The name cannot be empty"));
        return;
    }
    if (path.isEmpty()) {
        error(tr("The creation path cannot be empty"));
        return;
    }
    //路径检查和创建
    QDir projectRootDir(path);
    if (!projectRootDir.exists()) {
        error(tr("The path does not exist"));
        return;
    }
    QString projectPath = projectRootDir.filePath(name);
    QDir projectDir(projectPath);
    if (projectDir.exists()) {
        error(tr("%1 folder already exists").arg(name));
        return;
    }
    projectDir.mkpath(projectPath);
    //复制目录内容
    QDir hcDir(projectDir.filePath("HcControls"));
    copyDir(QDir(QGuiApplication::applicationDirPath() + "/source"), hcDir);
    //生成模板文件
    templateToFile(":/test/res/template/CMakeLists.txt.in",
                   projectDir.filePath("CMakeLists.txt"), name);
    templateToFile(":/test/res/template/src/CMakeLists.txt.in",
                   projectDir.filePath("src/CMakeLists.txt"), name);
    templateToFile(":/test/res/template/src/main.cpp.in", projectDir.filePath("src/main.cpp"),
                   name);
    templateToFile(":/test/res/template/src/main.qml.in", projectDir.filePath("src/main.qml"),
                   name);
    templateToFile(":/test/res/template/src/en_US.ts.in",
                   projectDir.filePath("src/" + name + "_en_US.ts"), name);
    templateToFile(":/test/res/template/src/zh_CN.ts.in",
                   projectDir.filePath("src/" + name + "_zh_CN.ts"), name);
    //直接复制文件
    copyFile(":/test/res/template/src/App.qml.in", projectDir.filePath("src/App.qml"));
    copyFile(":/test/res/template/src/qml.qrc.in", projectDir.filePath("src/qml.qrc"));
    copyFile(":/test/res/template/src/logo.ico.in", projectDir.filePath("src/logo.ico"));
    copyFile(":/test/res/template/src/README.md.in", projectDir.filePath("src/README.md"));
    return this->success(projectPath + "/CMakeLists.txt");
}
