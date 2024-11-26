#include <QGuiApplication>
#include <QProcess>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QSslConfiguration>

#include "AppInfo.h"
#include "Version.h"
#include "helper/Log.h"
#include "helper/InitializrHelper.h"
#include "helper/SettingsHelper.h"
#include "helper/TranslateHelper.h"
//#include "HcSvgImage.h"
//#include "HcFileOp.h"

int main(int argc, char *argv[])
{
//    HcSvgImage::registQML();
//    HcFileOp::registQML();
    const char *uri = "test";
    Log::setup(argv, uri);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    SettingsHelper::getInstance()->init(argv);
    TranslateHelper::getInstance()->init(&engine);
    engine.rootContext()->setContextProperty("AppInfo", AppInfo::getInstance());
    engine.rootContext()->setContextProperty("SettingsHelper", SettingsHelper::getInstance());
    engine.rootContext()->setContextProperty("InitializrHelper", InitializrHelper::getInstance());
    engine.rootContext()->setContextProperty("TranslateHelper", TranslateHelper::getInstance());


    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("test", "Main");

    return app.exec();
}
