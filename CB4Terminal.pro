QT += quick serialport qml core widgets
QT += quickcontrols2
android: {
QT += androidextras
  #  QMAKE_LINK += -nostdlib++
   # QMAKE_LFLAGS += -stdlib=libstdc++
}
CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        qmlapp.cpp \
        serialmanager.cpp \
        viewpage/viewpage.cpp

HEADERS += \
        qmlapp.h \
        serialmanager.h \
        viewpage/viewpage.h

RESOURCES += \
        qrc.qrc

RC_ICONS = qml/icon/logo1.ico

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =


# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

