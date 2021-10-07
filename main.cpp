#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "qmlapp.h"
#include <QDebug>
#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qDebug() << "Starting app";
    QGuiApplication app(argc, argv);
    qDebug() << "ask permission";
#ifdef Q_OS_ANDROID

    QtAndroid::PermissionResult rr = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
    if(rr == QtAndroid::PermissionResult::Denied) {
        QtAndroid::requestPermissionsSync( QStringList() << "android.permission.WRITE_EXTERNAL_STORAGE" );
        rr = QtAndroid::checkPermission("android.permission.WRITE_EXTERNAL_STORAGE");
        if(rr == QtAndroid::PermissionResult::Denied) {
            qDebug() << "external permission denied";

             return -1;
        }
    }


            QtAndroid::PermissionResult r = QtAndroid::checkPermission("com.google.android.things.permission.USE_PERIPHERAL_IO");
            if(r == QtAndroid::PermissionResult::Denied) {
                QtAndroid::requestPermissionsSync( QStringList() << "com.google.android.things.permission.USE_PERIPHERAL_IO" );
                r = QtAndroid::checkPermission("com.google.android.things.permission.USE_PERIPHERAL_IO");
                if(r == QtAndroid::PermissionResult::Denied) {
                    qDebug() << "uart permission denied";
                     return -1;
                }
            }

#endif
    qDebug() << "Starting view";

    QmlApp a;

    return app.exec();
}
