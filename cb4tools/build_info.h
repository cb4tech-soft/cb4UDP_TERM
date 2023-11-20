#ifndef BUILD_INFO_H
#define BUILD_INFO_H
#include <QString>
#include <QDateTime>
#define COMPILATION_DATE_TIME QDateTime::fromString(QStringLiteral(__DATE__) + QStringLiteral(" ") + QStringLiteral(__TIME__), "MMM  d yyyy hh:mm:ss").toString("MMddyy_hhmmss")
#endif
