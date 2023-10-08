#ifndef BUILD_INFO_H
#define BUILD_INFO_H
#include <QString>
#include <QDateTime>
const QString compilationDateTime = QDateTime::fromString(QStringLiteral(__DATE__) + QStringLiteral(" ") + QStringLiteral(__TIME__), "MMM  d yyyy hh:mm:ss").toString("MMddyy_hhmmss");
#endif
