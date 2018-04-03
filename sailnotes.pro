TARGET = harbour-sailnotes

CONFIG += sailfishapp
PKGCONFIG += nemonotifications-qt5

QT += dbus multimedia

SOURCES += src/sailnotes.cpp \
    src/file_helper.cpp \
    src/audiorecorder.cpp

HEADERS += \
    src/file_helper.h \
    src/audiorecorder.h

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    harbour-sailnotes.desktop \
    rpm/harbour-sailnotes.changes.in \
    rpm/harbour-sailnotes.yaml \
    dbus/org.fruct.yar.sailnotes.service \
    translations/*.ts

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

CONFIG += sailfishapp_i18n

dbus.files = dbus/org.fruct.yar.sailnotes.service
dbus.path = /usr/share/dbus-1/services/

INSTALLS += dbus

TRANSLATIONS += translations/harbour-sailnotes.ts \
                translations/harbour-sailnotes-ru.ts

DISTFILES += \
    qml/pages/CameraPage.qml \
    qml/pages/EditTextNoteDialog.qml \
    qml/pages/MainPage.qml \
    qml/pages/EditImagePhotoNoteDialog.qml \
    qml/pages/AddPhotoNoteDialog.qml \
    qml/pages/AddPictureNoteDialog.qml \
    qml/dialogs/AddPictureDialog.qml \
    qml/dialogs/EditNoteDialog.qml \
    qml/pages/NoteDetailsPage.qml \
    qml/dialogs/EditReminderDialog.qml \
    qml/components/AudioPlayer.qml \
    qml/persistence/NotesDao.qml \
    qml/persistence/NoteListModel.qml \
    qml/components/NotificationManager.qml \
    qml/harbour-sailnotes.qml
