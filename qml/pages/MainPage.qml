import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    SilicaListView {

        PullDownMenu {
            MenuItem {
                text: qsTr("Add a new note")
                onClicked: appWindow.openAddNoteDialog();
            }
        }

        id: noteListView
        model: noteListModel
        anchors.fill: parent

        VerticalScrollDecorator {}

        header: PageHeader {
            title: qsTr("Notes")
        }

        delegate: ListItem {

            id: listItem
            contentHeight: picturePaths.split(",")[0] === "" ?
                               (description.length < 205 ? Theme.itemSizeSmall : Theme.itemSizeLarge) : Theme.itemSizeLarge
            Item {
                id: noteItem
                height: listItem.contentHeight
                width: parent.width

                Label {
                    id: titleLabel
                    width: parent.width
                    anchors {
                        left: parent.left; right: image.left; top: parent.top
                        leftMargin: Theme.paddingLarge
                    }
                    text: title
                    wrapMode: Text.Wrap
                    maximumLineCount: 1
                }
                Label {
                    id: descriptionLabel
                    anchors {
                        right: image.left; left: parent.left; top: titleLabel.bottom
                        leftMargin: Theme.paddingLarge; rightMargin: Theme.paddingLarge
                    }
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: description
                    wrapMode: Text.Wrap
                    maximumLineCount: noteItem.height === Theme.itemSizeSmall ? 1 : 2
                }

                Image {
                    id: image
                    width: picturePaths.split(",")[0] === "" ?  0 : parent.width / 4
                    anchors {
                        right: parent.right; top: parent.top; bottom: parent.bottom
                        leftMargin: Theme.paddingLarge
                    }
                    fillMode: Image.PreserveAspectFit
                    source: picturePaths.split(",")[0]
                }
            }

            onClicked: {
                pageStack.push(Qt.resolvedUrl("NoteDetailsPage.qml"),
                               {title: title, description: description, picturePaths: picturePaths,
                                   reminderTimestamp: reminderTimestamp, audioFilePath: audioFilePath});
            }

            menu: ContextMenu {
                MenuItem {
                    text: qsTr("Edit")
                    onClicked: {
                        var note = appWindow.createNote(title, description, picturePaths,
                                                        audioFilePath, reminderTimestamp);
                        note.id = id;
                        var dialog = pageStack.push(Qt.resolvedUrl("../dialogs/EditNoteDialog.qml"),
                                                    {note: note});

                        dialog.accepted.connect(function() {
                            dao.updateNote(dialog.note);
                            noteListModel.updateNote(model.index, dialog.note);
                        });
                    }
                }
                MenuItem {
                    text: qsTr("Delete")
                    onClicked: {
                        appWindow.removePictureFiles(picturePaths);
                        audioRecorder.removeAudioFile(audioFilePath);
                        dao.deleteNote(id);
                        noteListModel.remove(model.index);
                        notificationManager.removeNotification(id);
                    }
                }
            }
        }
    }

    Component.onCompleted: refreshNoteList()

    onStatusChanged: {
        if (status === PageStatus.Active) {
            pageStack.backNavigation = false;
            pageStack.forwardNavigation = false;
        } else if (status === PageStatus.Inactive) {
            pageStack.backNavigation = true;
            pageStack.forwardNavigation = true;
        }
    }

    function refreshNoteList() {
        noteListModel.clear();
        dao.retrieveAllNotes(function(notes) {
            for (var i = 0; i < notes.length; i++) {
                noteListModel.addNote(notes.item(i));
            }
        });
    }
}
