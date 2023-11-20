#include "udpmanager.h"
#include <QColor>
#include <QQmlEngine>
#include <QUdpSocket>
#include <QDebug>
#include <QFileDialog>
#include <QStandardPaths>
#include <QNetworkDatagram>


UdpManager::UdpManager(QObject *parent) : QObject(parent)
{
    setIsConnected(0);
    socket = nullptr;
    timer = new QTimer(this);
    timer->setSingleShot(true);
    connect(timer, &QTimer::timeout, this, &UdpManager::dataAvailable);
}

void UdpManager::registerQml()
{
    qmlRegisterType<UdpManager>("UdpManager", 1, 0, "UdpManager");
}

QStringList UdpManager::getComList()
{
    /*
    QList<QSerialPortInfo> portList = QSerialPortInfo::availablePorts();
    foreach (const QSerialPortInfo &info, portList)
    {
        result.append(info.portName());
    }
*/

    QStringList result;
    return result;
}

void UdpManager::test()
{
    emit dataAvailable();
}

void UdpManager::connectToPort()
{
    if (socket)
    {
        if (socket->isOpen()) socket->close();
        delete socket;
        socket = nullptr;
        setIsConnected(0);
    }

    socket = new QUdpSocket(this);
    if (m_listenIp.isEmpty())
    {
        qDebug() << "bind to any address";
        socket->bind(QHostAddress::Any, m_listenPort);
    }
    else
    {
        qDebug() << "bind to address : " << m_listenIp ;
        socket->bind(QHostAddress(m_listenIp), m_listenPort);
    }
    /*
    m_portName = portName;
    qDebug()<< "connect to " << portName;
    connect(port, &QSerialPort::errorOccurred, this, &SerialManager::errorHandler);
    port->setBaudRate(m_baudrate);
    port->open(QIODevice::ReadWrite);
    if (port->isOpen())
    {
    }
*/
    setIsConnected(1);
    socket->open(QIODevice::ReadWrite);
    connect(socket,SIGNAL(readyRead()), this, SLOT(checkData()));
}

void UdpManager::disconnectFromPort()
{
    if (socket && socket->isOpen())
    {
        socket->close();
        delete socket;
        socket = nullptr;
        setIsConnected(0);
    }

}

bool UdpManager::isLineAvailable()
{
    if (socket && socket->canReadLine())
        return true;
    return false;

}

void UdpManager::checkData()
{
//    qDebug() << "CheckData !";
    if (socket && socket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = socket->receiveDatagram(UDP_BUFFERSIZE);
        //processTheDatagram(datagram);
        inData.append(datagram.data());
        qDebug() << inData;
    }
    if(socket && inData.length()) {
        emit dataAvailable();
    }
    else {
       timer->start(100);
    }
}

void UdpManager::errorHandler(QUdpSocket::SocketError error)
{
    switch (error)
    {
    case QUdpSocket::SocketError::AddressInUseError:
        setIsConnected(0);
        qDebug() << " => Device Not Found";
    break;
    default:
//        setIsConnected(0);
        qDebug() << " => error State : " << error;
    break;
    }
}

QString UdpManager::readLine()
{
    if (Q_LIKELY(socket != nullptr))
    {
        int index = inData.indexOf('\n');
        QString dataString = QString::fromUtf8(inData.first(index));
        inData = inData.last(index);
        if(socket->bytesAvailable())
        {
            timer->start(100);
        }
        else
            timer->stop();
        return dataString;
    }
    else
        return "port close";
}

QString UdpManager::readAll()
{
    qDebug() << Q_FUNC_INFO;
    if (Q_LIKELY(socket != nullptr))
    {
        QString dataString = QString::fromUtf8(inData);
        inData.clear();
        qDebug() << Q_FUNC_INFO << dataString;
        if(socket->bytesAvailable())
        {
            timer->start(100);
        }
        else
            timer->stop();
        return dataString;
    }
    else
        return "port close";
}

void UdpManager::sendData(QList<int> dataOut)
{
    QByteArray arrayToSend;
    if (socket && socket->isOpen())
    {
        while (dataOut.length())
        {
            arrayToSend.append(dataOut.takeFirst());
        }
        socket->writeDatagram(arrayToSend, QHostAddress(m_targetIp), m_targetPort);
    }
}

void UdpManager::sendString(QString dataOut)
{
    if (socket && socket->isOpen())
    {
        socket->writeDatagram(dataOut.toLocal8Bit(), QHostAddress(m_targetIp), m_targetPort);
    }
}



 int UdpManager::isConnected() const
 {
     return m_isConnected;
 }

 void UdpManager::setIsConnected(int newIsConnected)
 {
     if (m_isConnected == newIsConnected)
         return;
     m_isConnected = newIsConnected;
     emit isConnectedChanged();
 }

 QString UdpManager::listenIp() const
 {
     return m_listenIp;
 }

 void UdpManager::setListenIp(const QString &newListenIp)
 {
     if (m_listenIp == newListenIp)
         return;
     m_listenIp = newListenIp;
     emit listenIpChanged();
 }

 int UdpManager::listenPort() const
 {
     return m_listenPort;
 }

 void UdpManager::setListenPort(int newListenPort)
 {
     if (m_listenPort == newListenPort)
         return;
     m_listenPort = newListenPort;
     emit listenPortChanged();
 }

 QString UdpManager::targetIp() const
 {
     return m_targetIp;
 }

 void UdpManager::setTargetIp(const QString &newTargetIp)
 {
     if (m_targetIp == newTargetIp)
         return;
     m_targetIp = newTargetIp;
     emit targetIpChanged();
 }

 int UdpManager::targetPort() const
 {
     return m_targetPort;
 }

 void UdpManager::setTargetPort(int newTargetPort)
 {
     if (m_targetPort == newTargetPort)
         return;
     m_targetPort = newTargetPort;
     emit targetPortChanged();
 }
