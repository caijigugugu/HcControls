#include <QGuiApplication>
#include <QQmlApplicationEngine>

//#include "HcSvgImage.h"
//#include "HcFileOp.h"

int main(int argc, char *argv[])
{
//    HcSvgImage::registQML();
//    HcFileOp::registQML();

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("test", "Main");

    return app.exec();
}
