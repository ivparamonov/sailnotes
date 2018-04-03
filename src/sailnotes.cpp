#include <QtQuick>
#include <QGuiApplication>
#include <QQmlEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QTranslator>
#include <sailfishapp.h>
#include "file_helper.h"
#include "notification_manager.h"

#include "audiorecorder.h"

int main(int argc, char *argv[]) {
    QGuiApplication* app =  SailfishApp::application(argc, argv);
    QQuickView* view = SailfishApp::createView();
    qmlRegisterType<AudioRecorder>( "harbour.sailnotes", 1, 0, "AudioRecorder");
    qmlRegisterType<FileHelper>("harbour.sailnotes.fileHelper", 1, 0, "FileHelper");
    qmlRegisterType<NotificationManager>("harbour.sailnotes.notificationManager", 1, 0,
                                         "NotificationManager");
    QTranslator translator;
    translator.load("sailnotes-" + QLocale().name(),
                    SailfishApp::pathTo(QString("localization")).toLocalFile());
    app->installTranslator(&translator);
    view->setSource(SailfishApp::pathTo("qml/sailnotes.qml"));
    view->showFullScreen();
    QObject::connect(view->engine(), &QQmlEngine::quit, app, &QGuiApplication::quit);
    return app->exec();
}
