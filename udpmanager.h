#ifndef UDPMANAGER_H
#define UDPMANAGER_H

#include <QObject>
#include <QUdpSocket>
#include <QQmlEngine>
#include <QMetaType>
#include <QTimer>

#define UDP_BUFFERSIZE 255
class UdpManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int isConnected READ isConnected WRITE setIsConnected NOTIFY isConnectedChanged);
    Q_PROPERTY(QString listenIp READ listenIp WRITE setListenIp NOTIFY listenIpChanged FINAL)
    Q_PROPERTY(int listenPort READ listenPort WRITE setListenPort NOTIFY listenPortChanged FINAL)
    Q_PROPERTY(QString targetIp READ targetIp WRITE setTargetIp NOTIFY targetIpChanged FINAL)
    Q_PROPERTY(int targetPort READ targetPort WRITE setTargetPort NOTIFY targetPortChanged FINAL)

public:
    explicit UdpManager(QObject *parent = nullptr);
    static void registerQml();

    Q_INVOKABLE void test();
    Q_INVOKABLE QStringList getComList();
    Q_INVOKABLE void connectToPort();
    Q_INVOKABLE void disconnectFromPort();
    Q_INVOKABLE QString readAll();
    Q_INVOKABLE bool isLineAvailable();
    Q_INVOKABLE QString readLine();
    Q_INVOKABLE void sendData(QList<int> dataOut);
    Q_INVOKABLE void sendString(QString dataOut);



    int isConnected() const;
    void setIsConnected(int newIsConnected);

    QString listenIp() const;
    void setListenIp(const QString &newListenIp);

    int listenPort() const;
    void setListenPort(int newListenPort);

    QString targetIp() const;
    void setTargetIp(const QString &newTargetIp);

    int targetPort() const;
    void setTargetPort(int newTargetPort);

signals:
    void dataAvailable();
    void lineAvailable();



    void isConnectedChanged();

    void listenIpChanged();

    void listenPortChanged();

    void targetIpChanged();

    void targetPortChanged();

private slots:
    void checkData();
    void errorHandler(QUdpSocket::SocketError error);

private:
    QUdpSocket *socket = nullptr;
    QTimer *timer;
    QString m_portName;
    QByteArray inData;

    int m_isConnected;
    QString m_listenIp;
    int m_listenPort;
    QString m_targetIp;
    int m_targetPort;
};



#endif // UDPMANAGER_H
