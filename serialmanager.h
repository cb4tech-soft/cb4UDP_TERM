#ifndef SERIALMANAGER_H
#define SERIALMANAGER_H

#include <QObject>
#include <QSerialPort>
#include <QQmlEngine>
#include <QMetaType>



class SerialInfo : public QObject
{
Q_OBJECT

public:
    explicit SerialInfo(QObject* parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE QStringList getPortList();


signals:


private:

};

extern SerialInfo serialInfo;

class SerialManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int baudrate READ baudrate WRITE setBaudrate NOTIFY baudrateChanged);
    Q_PROPERTY(int isConnected READ isConnected WRITE setIsConnected NOTIFY isConnectedChanged)
    Q_ENUMS(QSerialPort::BaudRate)

public:
    explicit SerialManager(QObject *parent = nullptr);
    static void registerQml();

    Q_INVOKABLE void test();
    Q_INVOKABLE QStringList getComList();
    Q_INVOKABLE void connectToPort(QString portName);
    Q_INVOKABLE void disconnectFromPort();
    Q_INVOKABLE QString readAll();
    Q_INVOKABLE bool isLineAvailable();
    Q_INVOKABLE QString readLine();
    Q_INVOKABLE void sendData(QList<int> dataOut);
    Q_INVOKABLE void sendString(QString dataOut);


    static SerialInfo *getStaticInfoInstance();


    int baudrate() const;
    void setBaudrate(int newBaudrate);



    int isConnected() const;
    void setIsConnected(int newIsConnected);

signals:
    void dataAvailable();
    void lineAvailable();

    void baudrateChanged();

    void isConnectedChanged();

private slots:
    void checkData();
    void errorHandler(QSerialPort::SerialPortError error);

private:
    QSerialPort *port = nullptr;
    SerialInfo *info;

    int m_baudrate = 19200;
    int m_isConnected;
};



#endif // SERIALMANAGER_H
