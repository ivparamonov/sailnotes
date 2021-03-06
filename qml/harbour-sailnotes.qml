import QtQuick 2.0
import Sailfish.Silica 1.0

import harbour.sailnotes 1.0

import "pages"
import "persistence"
import "components"

ApplicationWindow {
    id: appWindow
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

    FileHelper { id: fileHelper }

    AudioRecorder { id: audioRecorder }
    NoteListModel { id: noteListModel }
    NotificationManager { id: notificationManager }
    NotesDao { id: dao }

    function openAddNoteDialog() {
        var note = createNote("", "", "", "", "", 0);
        var dialog = pageStack.push(Qt.resolvedUrl("dialogs/EditNoteDialog.qml"), {note: note});
        dialog.accepted.connect(function() {
            var noteId = dao.createNote(dialog.note, function(noteId) {
                dialog.note.id = noteId;
                noteListModel.addNote(dialog.note);
                if (dialog.note.reminderTimestamp > 0) {
                    notificationManager.scheduleNotification(noteId, dialog.note.title,
                                            dialog.note.description, dialog.note.reminderTimestamp);
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
