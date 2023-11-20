#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "qmlapp.h"
#include <QDebug>
#ifdef Q_OS_ANDROID
//#include <QtAndroid>
#endif
#include "serialmanager.h"
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qDebug() << "Starting app";
    QGuiApplication app(argc, argv);
    qDebug() << "ask permission";

    qputenv("QSG_RHI_BACKEND", "opengl");
    qDebug() << "Starting view";
    app.setOrganizationName("CB4Tech");
    app.setOrganizationDomain("cb4tech.com");
    app.setApplicationName("CB4UDP");

    QmlApp a;
#ifdef TESTING
#endif

    return app.exec();
}
