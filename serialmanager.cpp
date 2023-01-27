#include "serialmanager.h"
#include <QColor>
#include <QQmlEngine>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QDebug>

SerialInfo serialInfo;

SerialManager::SerialManager(QObject *parent) : QObject(parent)
{
    setIsConnected(0);
    port = nullptr;

}

void SerialManager::registerQml()
{
    qmlRegisterType<SerialManager>("SerialManager", 1, 0, "SerialManager");

    qmlRegisterSingletonInstance( "SerialInfo", 1, 0, "SerialInfo", getStaticInfoInstance());
}

QStringList SerialManager::getComList()
{
    QList<QSerialPortInfo> portList = QSerialPortInfo::availablePorts();
    QStringList result;
    foreach (const QSerialPortInfo &info, portList)
    {

        result.append(info.portName());

    }
    return result;
}

void SerialManager::test()
{
    emit dataAvailable();
}


void SerialManager::connectToPort(QString portName)
{
    if (port)
    {
        if (port->isOpen()) port->close();
        delete port;
        port = nullptr;
        setIsConnected(0);
    }

    port = new QSerialPort(portName);
    qDebug()<< "connect to " << portName;
    connect(port, &QSerialPort::errorOccurred, this, &SerialManager::errorHandler);
    port->setBaudRate(m_baudrate);
    port->open(QIODevice::ReadWrite);
    if (port->isOpen())
    {

        setIsConnected(1);
    }

    connect(port,SIGNAL(readyRead()), this, SLOT(checkData()));

}

void SerialManager::disconnectFromPort()
{
    if (port && port->isOpen())
    {
        port->close();
        delete port;
        port = nullptr;
        setIsConnected(0);
    }

}



QString SerialManager::readAll()
{
    return port->readAll();
}

bool SerialManager::isLineAvailable()
{
    if (port && port->canReadLine())
        return true;
    return false;

}

void SerialManager::checkData()
{
    if (port->canReadLine())
        emit lineAvailable();
    emit dataAvailable();

}

void SerialManager::errorHandler(QSerialPort::SerialPortError error)
{
    switch (error)
    {
    case QSerialPort::SerialPortError::DeviceNotFoundError:
        setIsConnected(0);
        qDebug() << " => Device Not Found";
    break;
    case QSerialPort::SerialPortError::OpenError:
        setIsConnected(0);
        qDebug() << " => Open Error";
    break;
    case QSerialPort::SerialPortError::NotOpenError:
        setIsConnected(0);
        qDebug() << " => Device Not Open";
    break;
    case QSerialPort::SerialPortError::WriteError:
        setIsConnected(0);
        qDebug() << " => Device Write Error";
    break;
    case QSerialPort::SerialPortError::ReadError:
        setIsConnected(0);
        qDebug() << " => Device Read Error";
    break;
    case QSerialPort::SerialPortError::TimeoutError:
        setIsConnected(0);
        qDebug() << " => Device Timeout";
    break;
    case QSerialPort::SerialPortError::ParityError:
        setIsConnected(0);
        qDebug() << " => Parity Error";
    break;
    default:
        setIsConnected(0);
        qDebug() << " => Error occured";
    break;
    }
}

QString SerialManager::readLine()
{
    return port->readLine();
}

void SerialManager::sendData(QList<int> dataOut)
{
    QByteArray arrayToSend;
    if (port && port->isOpen())
    {
        while (dataOut.length())
        {
            arrayToSend.append(dataOut.takeFirst());
        }
        port->write(arrayToSend);
    }
}

void SerialManager::sendString(QString dataOut)
{
    if (port && port->isOpen())
    {
        port->write(dataOut.toLocal8Bit());
    }
}

SerialInfo *SerialManager::getStaticInfoInstance()
{
    return &serialInfo;
}


int SerialManager::baudrate() const
{
    return m_baudrate;
}

void SerialManager::setBaudrate(int newBaudrate)
{
    if (m_baudrate == newBaudrate)
        return;
    m_baudrate = newBaudrate;
    if (port && port->isOpen())
    {
        qDebug() << "Change baudrate for " << port->portName();
        port->setBaudRate(newBaudrate);
    }
    emit baudrateChanged();
}

int SerialManager::dataBits() const
{
    return m_dataBits;
}

void SerialManager::setDataBits(int newDataBits)
{
    if (m_dataBits == newDataBits)
        return;
    m_dataBits = newDataBits;
    if (port && port->isOpen())
    {
        qDebug() << "Change data bits for " << port->portName();
       switch(newDataBits) {
            case 5:
                port->setDataBits(QSerialPort::Data5);
                break;
            case 6:
                port->setDataBits(QSerialPort::Data6);
                break;
            case 7:
                port->setDataBits(QSerialPort::Data7);
                break;
            case 8:
                port->setDataBits(QSerialPort::Data8);
                break;
       };
    }
    emit dataBitsChanged();
}

int SerialManager::flowControl() const
{
    return m_flowControl;
}

void SerialManager::setFlowControl(int newFlowControl)
{
    if (m_flowControl == newFlowControl)
        return;
    m_flowControl = newFlowControl;
    if (port && port->isOpen())
    {
        qDebug() << "Change flow control for " << port->portName();
        switch(newFlowControl) {
            case 0:
                port->setFlowControl(QSerialPort::NoFlowControl);
                break;
            case 1:
                port->setFlowControl(QSerialPort::HardwareControl);
                break;
            case 2:
                port->setFlowControl(QSerialPort::SoftwareControl);
                break;
        };
    }
    emit flowControlChanged();
}

int SerialManager::parity() const
{
    return m_parity;
}

void SerialManager::setParity(int newParity)
{
    if (m_parity == newParity)
        return;
    m_parity = newParity;
    if (port && port->isOpen())
    {
        qDebug() << "Change parity for " << port->portName();
        switch(newParity) {
            case 0:
                port->setParity(QSerialPort::NoParity);
                break;
            case 1:
                port->setParity(QSerialPort::EvenParity);
                break;
            case 2:
                port->setParity(QSerialPort::OddParity);
                break;
            case 3:
                port->setParity(QSerialPort::SpaceParity);
                break;
            case 4:
                port->setParity(QSerialPort::MarkParity);
                break;

        };
    }
    emit parityChanged();
}

int SerialManager::stopBits() const
{
    return m_stopBits;
}

void SerialManager::setStopBits(int newStopBits)
{
    if (m_stopBits == newStopBits)
        return;
    m_stopBits = newStopBits;
    if (port && port->isOpen())
    {
        qDebug() << "Change parity for " << port->portName();
        switch(newStopBits) {
            case 0:
                port->setStopBits(QSerialPort::OneStop);
                break;
            case 1:
                port->setStopBits(QSerialPort::OneAndHalfStop);
                break;
            case 2:
                port->setStopBits(QSerialPort::TwoStop);
                break;
        };
    }
    emit stopBitsChanged();
}

 QStringList SerialInfo::getPortList()
{
    QList<QSerialPortInfo> portList = QSerialPortInfo::availablePorts();
    QStringList result;
    foreach (const QSerialPortInfo &info, portList)
    {

        result.append(info.portName());

    }
    return result;
 }

 int SerialManager::isConnected() const
 {
     return m_isConnected;
 }

 void SerialManager::setIsConnected(int newIsConnected)
 {
     if (m_isConnected == newIsConnected)
         return;
     m_isConnected = newIsConnected;
     emit isConnectedChanged();
 }
