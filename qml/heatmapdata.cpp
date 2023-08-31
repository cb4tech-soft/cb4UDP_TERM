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

#include "heatmapdata.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>

HeatMapData* HeatMapData::m_pThis = nullptr;

HeatMapData::HeatMapData(QObject *parent) : QObject(parent)
{

}

void HeatMapData::registerQml()
{
    qmlRegisterSingletonType<HeatMapData>("HeatMapData", 1, 0, "HeatMapData", &HeatMapData::qmlInstance);
}

HeatMapData *HeatMapData::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new HeatMapData;
    }
    return m_pThis;
}

QObject *HeatMapData::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return HeatMapData::instance();
}

int HeatMapData::get(int index)
{
    if (heatMapDist.length() > index)
        return heatMapDist.at(index);
    return 0;
}

void HeatMapData::populate(QString data)
{
    if (data.startsWith("*h"))
    {
        QStringList heatPoint = data.split(':');
        if (heatPoint.length() == 2)
        {
            int index = -1;
            int value = 0;
            if (heatPoint.value(0).length() > 2)
            {
                QString indexString = heatPoint.value(0).sliced(2);
                index = indexString.toInt();
            }
            else
            {
                return;
            }
            if (heatPoint.value(1).length() >= 1)
            {
                value = heatPoint.value(1).toInt();
            }
            if (heatMapDist.length() <= index)
            {
                heatMapDist.resize(index +1);
            }
            heatMapDist.replace(index, value);
        }
    }
}
