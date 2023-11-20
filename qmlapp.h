#ifndef __QMLAPP_H
#define __QMLAPP_H


#include <QObject>
#include <QtQuick/QQuickView>
  #include <QQmlApplicationEngine>
#include <QSystemTrayIcon>

class QmlApp : public QQmlApplicationEngine
{
    Q_OBJECT

public:
    explicit  QmlApp(QWindow *parent = nullptr);
    bool event(QEvent *event) override;
    ~QmlApp() override;

signals:

public slots:

private slots:

private:

    QAction *minimizeAction;
    QAction *maximizeAction;
    QAction *restoreAction;
    QAction *quitAction;

    QSystemTrayIcon * sysTrayIcon;
    QMenu *trayIconMenu;

    QTimer *timer;

};

#endif // __QMLAPP_H
