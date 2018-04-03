import QtQuick 2.0
import Sailfish.Silica 1.0
import org.nemomobile.configuration 1.0
import harbour.sailnotes.fileHelper 1.0
import harbour.sailnotes.notificationManager 1.0

import harbour.sailnotes 1.0
import "pages"
import "persistence"

ApplicationWindow
{
    id: appWindow
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

    FileHelper { id: fileHelper }
    NotificationManager { id: notificationManager }

    AudioRecorder { id: audioRecorder }
    NotesDao { id: dao }
    NoteListModel { id: noteListModel }

    ConfigurationValue {
        id: timeFormatConfig
        key: "/sailfish/i18n/lc_timeformat24h"
    }

    function openAddNoteDialog() {
        var note = createNote("", "", "", "", "", 0);
        var dialog = pageStack.push(Qt.resolvedUrl("dialogs/EditNoteDialog.qml"), {note: note});
        dialog.accepted.connect(function() {
            var noteId = dao.createNote(dialog.note, function(noteId) {
                dialog.note.id = noteId;
                noteListModel.addNote(dialog.note);
                if (dialog.note.reminderTimestamp > 0) {
                    notificationManager.publishNotification(noteId, dialog.note.title,
                                                            dialog.note.description,
                                                            new Date(dialog.note.reminderTimestamp));
                }
            });
        });
        dialog.rejected.connect(function() {
            removePictureFiles(dialog.note.picturePaths);
        });
    }

    function createNote(title, description, picturePaths, audioFilePath, reminderTimestamp) {
        return {
            title: title, description: description, picturePaths: picturePaths,
            audioFilePath: audioFilePath, reminderTimestamp: reminderTimestamp
        };
    }

    function removePictureFiles(picturePathsAsString) {
        picturePathsAsString.split(",").filter(function(path) {
            return path.length > 0;
        }).forEach(function(path) {
            fileHelper.removeFile(path);
        });
    }
}
