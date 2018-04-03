#include <QtQuick>
#include <sailfishapp.h>

#include "file_helper.h"
#include "audiorecorder.h"

int main(int argc, char *argv[]) {
    qmlRegisterType<AudioRecorder>("harbour.sailnotes", 1, 0, "AudioRecorder");
    qmlRegisterType<FileHelper>("harbour.sailnotes", 1, 0, "FileHelper");
    return SailfishApp::main(argc, argv);
}
