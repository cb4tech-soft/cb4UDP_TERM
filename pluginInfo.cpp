/*
#include "sscp_qt.h"
#include "sscp/sscp.h"
#include <QQmlApplicationEngine>

#include <QQmlEngine>

SSCP_QT* SSCP_QT::m_pThis = nullptr;


SSCP_QT::SSCP_QT(QObject *parent) : QObject{parent}
{

}

void SSCP_QT::registerQml()
{
    qDebug()<<"register instance";
    qmlRegisterSingletonType<SSCP_QT>("SSCP_QT", 1, 0, "SSCP_QT", &SSCP_QT::qmlInstance);

}


SSCP_QT *SSCP_QT::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new SSCP_QT;
    }
    return m_pThis;
}

QObject *SSCP_QT::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return SSCP_QT::instance();
}


QString SSCP_QT::name() const
{
    return m_name;
}

void SSCP_QT::setName(const QString &newName)
{
    if (m_name == newName)
        return;
    m_name = newName;
    emit nameChanged();
}

*/

#include "pluginInfo.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QDir>
#include <QFileSystemWatcher>
#include <QFile>
#include <QTimer>
PluginInfo* PluginInfo::m_pThis = nullptr;

PluginInfo::PluginInfo(QObject *parent) : QObject(parent)
{
    qDebug()<<"PluginInfo constructor";
    QDir d(pluginFolder);
    if (!d.exists())
    {
        d.mkpath(pluginFolder);
    }
    watcher.addPath(pluginFolder);
    connect(&watcher, &QFileSystemWatcher::directoryChanged, this, &PluginInfo::updatePluginList);
#if (BUILD_PLUGIN_TESTUNIT == 1)
    testUnitPlugin_fileWatcher();
#endif
}

#if (BUILD_PLUGIN_TESTUNIT == 1)

void PluginInfo::testUnitPlugin_fileWatcher()
{
    qWarning() << "\ttestUnitPlugin_fileWatcher";
    qWarning() << "Creation d'un fichier test.qml";
    QFile file(pluginFolder + "test.qml");
    QFileInfo fileInfo(file);
    file.open(QIODevice::WriteOnly);
    file.write("Hello world");
    file.close();
    qWarning() << "Creation d'un fichier test.txt";
    QFile file2(pluginFolder + "test.txt");
    file2.open(QIODevice::WriteOnly);
    file2.write("Hello world");
    file2.close();

    QTimer::singleShot(1000, [=]{
        qWarning() << "Suppression du fichier test.qml";
        QFile file(pluginFolder + "test.qml");
        file.remove();

    });

    QTimer::singleShot(1500, [=]{
        qWarning() << "Suppression du fichier test.txt";
        QFile file(pluginFolder + "test.txt");
        file.remove();
    });
}

#endif


void PluginInfo::updatePluginList()
{
    QDir d(pluginFolder);
    QStringList files = d.entryList(QStringList()<<"*.qml" ,QDir::Files);
    setPluginFiles(files);
    qDebug()<<"plugin files updated: "<<files;
}


void PluginInfo::registerQml()
{
    qmlRegisterSingletonType<PluginInfo>("PluginInfo", 1, 0, "PluginInfo", &PluginInfo::qmlInstance);
}

PluginInfo *PluginInfo::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new PluginInfo;
    }
    return m_pThis;
}

QObject *PluginInfo::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return PluginInfo::instance();
}

QStringList PluginInfo::pluginFiles() const
{
    return m_pluginFiles;
}

void PluginInfo::setPluginFiles(const QStringList &newPluginFiles)
{
    if (m_pluginFiles == newPluginFiles)
        return;
    m_pluginFiles = newPluginFiles;
    emit pluginFilesChanged();
}
