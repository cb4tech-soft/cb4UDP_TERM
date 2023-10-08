@echo off

setlocal EnableDelayedExpansion
%= blank line =%

echo #ifndef BUILD_INFO_H
echo #define BUILD_INFO_H
echo #include ^<QString^>
echo #include ^<QDateTime^>
echo const QString compilationDateTime = QDateTime::fromString(QStringLiteral(__DATE__) + QStringLiteral(" ") + QStringLiteral(__TIME__), "MMM  d yyyy hh:mm:ss").toString("MMddyy_hhmmss");
echo #endif

