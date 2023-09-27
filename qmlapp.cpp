
#include <QDebug>

#include <QtQml/QQmlContext>
#include <QQuickStyle>
#include <QQmlApplicationEngine>

#include "qmlapp.h"

#include "viewpage/viewpage.h"
#include "serialmanager.h"
#include "pluginInfo.h"
#include <QSystemTrayIcon>
#include <QMenu>
#include "qml/myscreeninfo.h"
#include "qml/heatmapdata.h"
#ifdef Q_OS_WIN



#endif


QmlApp::QmlApp(QWindow *parent) : QQmlApplicationEngine(parent)
{
    //initSysTrayIcon(sysTrayIcon);
    timer = new QTimer();
    timer->setInterval(5000);
    timer->start();

    //sysTrayIcon->showMessage("Helllo world", "Helllo world dak",  QSystemTrayIcon::Information, 10000);
    QQuickStyle::setStyle("Material");
    //setResizeMode(QQuickView::SizeRootObjectToView);
    SerialManager::registerQml();
    MyScreenInfo::registerQml();
    HeatMapData::registerQml();
    PluginInfo::registerQml();
    //m_page = new ViewPage(this, "qrc:/qml/main.qml", "uiLink");
    //m_page->enableUiLink();
    //setWidth(900);
    //setHeight(600);
//    viewChanger(m_page);
    load(QUrl("qrc:/qml/main.qml"));
    //show();
}


void    QmlApp::viewChanger(ViewPage *page)
{
    if (m_page && page != m_page)
        m_page->deleteLater();
    m_page = page;
    page->show();
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
