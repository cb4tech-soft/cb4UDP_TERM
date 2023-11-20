
#include <QDebug>

#include <QtQml/QQmlContext>
#include <QQuickStyle>
#include <QQmlApplicationEngine>

#include "qmlapp.h"

#include "serialmanager.h"
#include "pluginInfo.h"
#include <QSystemTrayIcon>
#include <QMenu>
#include "qml/myscreeninfo.h"
#include "qml/heatmapdata.h"
#include "cb4tools/build_info.h"
#include "cb4tools/debug_info.h"
#include "udpmanager.h"
#ifdef Q_OS_WIN



#endif


QmlApp::QmlApp(QWindow *parent) : QQmlApplicationEngine(parent)
{
    timer = new QTimer();
    timer->setInterval(5000);
    timer->start();

    QQuickStyle::setStyle("Material");

    UdpManager::registerQml();
    MyScreenInfo::registerQml();
    HeatMapData::registerQml();
    PluginInfo::registerQml();

    load(QUrl("qrc:/qml/main.qml"));
    QDBG_YELLOW() << COMPILATION_DATE_TIME << DBG_CLR_RESET;
}


/*
 * Gestion Close Event
 */
bool QmlApp::event(QEvent *event)
{
    if (event->type() == QEvent::Close)
    {
        // return true to cancel close event
    }
    return QQmlApplicationEngine::event(event);
}

QmlApp::~QmlApp()
{

}
