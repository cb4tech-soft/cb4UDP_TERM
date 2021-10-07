#ifndef __QMLAPP_H
#define __QMLAPP_H


#include <QObject>
#include <QtQuick/QQuickView>

#include "viewpage/viewpage.h"

class QmlApp : public QQuickView
{
    Q_OBJECT

public:
    explicit  QmlApp(QWindow *parent = nullptr);
    bool event(QEvent *event) override;
    ~QmlApp() override;

signals:

public slots:

private slots:
    void    viewChanger(ViewPage *page);

private:
    ViewPage *m_page = nullptr;
};

#endif // __QMLAPP_H
