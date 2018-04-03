TARGET = harbour-sailnotes

CONFIG += sailfishapp
PKGCONFIG += nemonotifications-qt5

QT += dbus multimedia

SOURCES += src/sailnotes.cpp \
    src/file_helper.cpp \
    src/audiorecorder.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-sailnotes.changes.in \
    rpm/harbour-sailnotes.yaml \
    translations/*.ts

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

CONFIG += sailfishapp_i18n

localization.files = localization
localization.path = /usr/share/harbour-sailnotes/localization

dbus.files = dbus/org.fruct.yar.sailnotes.service
dbus.path = /usr/share/dbus-1/services/

INSTALLS += localization dbus

TRANSLATIONS += translations/harbour-sailnotes-ru.ts

HEADERS += \
    src/file_helper.h \
    src/audiorecorder.h

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
    harbour-sailnotes.desktop \
    qml/components/AudioPlayer.qml \
    qml/persistence/NotesDao.qml \
    qml/persistence/NoteListModel.qml \
    qml/components/NotificationManager.qml \
    dbus/org.fruct.yar.sailnotes.service \
    qml/harbour-sailnotes.qml
