#ifndef HEATMAPDATA_H
#define HEATMAPDATA_H

#include <QObject>
#include <QQmlEngine>

class HeatMapData : public QObject
{
    Q_OBJECT

public:
    static void registerQml();
    static HeatMapData *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);


public slots:
    Q_INVOKABLE int get(int index);
    Q_INVOKABLE void populate(QString data);

signals:

private slots:


private:
    explicit HeatMapData(QObject *parent = nullptr);
    static HeatMapData* m_pThis;
    QList<int> heatMapDist;

};

#endif // HEATMAPDATA_H
