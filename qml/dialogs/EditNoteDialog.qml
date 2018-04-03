import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"


Dialog {

    property var note
    property bool needRemovePicture: false
    property var picturesToRemove: []
    property string placeholder: qsTr("Enter the note description")
    property bool placeholderVisible: note.description.length === 0

    canAccept: titleTextField.text.length > 0 || (!placeholderVisible && descriptionTextEdit.text.length > 0)

    ListModel { id: gridModel }

    SilicaFlickable {

        anchors.fill: parent
        contentHeight: column.height

        VerticalScrollDecorator {}

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingLarge

            DialogHeader {
                id: header
                width: parent.width
                title: note.title.length === 0 && note.description.length === 0
                       ? qsTr("Add a note") : qsTr("Edit the note")
            }

            ValueButton {
                width: parent.width
                label: qsTr("Reminder").concat(": ")
                value: note.reminderTimestamp > 0
                       ? Qt.formatDateTime(new Date(note.reminderTimestamp), "dd MMM yyyy hh:mm")
                       : qsTr("Select")
                onClicked: {
                    var now = new Date();
                    var dateTime = note.reminderTimestamp > 0
                            ? new Date(note.reminderTimestamp)
                            : new Date(now.getFullYear(), now.getMonth(), now.getDate(),
                                       now.getHours(), now.getMinutes() + 1, 0, 0);
                    var dialog = pageStack.push("../dialogs/EditReminderDialog.qml",
                                                {dateTime: dateTime});
                    dialog.accepted.connect(function() {
                        note.reminderTimestamp = dialog.dateTime.getTime();
                        value = note.reminderTimestamp > 0
                                ? Qt.formatDateTime(new Date(note.reminderTimestamp), "dd MMM yyyy hh:mm")
                                : qsTr("Select");
                    });
                }
            }

            TextField {
                id: titleTextField
                width: parent.width
                text: note.title
                labelVisible: true
                label: qsTr("Title:")
                placeholderText: qsTr("Enter the note title")
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: descriptionTextEdit.focus = true
            }

            TextEdit {
                x: Theme.paddingLarge
                id: descriptionTextEdit
                width: parent.width - Theme.paddingLarge
                text: placeholderVisible ? placeholder : note.description
                font.pixelSize: Theme.fontSizeMedium
                color: placeholderVisible ? Theme.secondaryColor : Theme.primaryColor
                wrapMode: TextEdit.Wrap
                inputMethodHints: Qt.ImhNoPredictiveText;
                onCursorPositionChanged: {
                    if (placeholderVisible) cursorPosition = 0;
                }
                onFocusChanged: {
                    if (focus) {
                        color = placeholderVisible ? Theme.secondaryHighlightColor : Theme.highlightColor;
                    } else {
                        color = placeholderVisible ? Theme.secondaryColor : Theme.primaryColor
                    }
                }
                onTextChanged: {
                    var rawText = descriptionTextEdit.getText(0, text.length);
                    if (focus && rawText !== placeholder && placeholderVisible) {
                        text = text.replace(placeholder, "");
                        color = Theme.highlightColor;
                        cursorPosition += 1;
                        placeholderVisible = false;
                    } else if (rawText.length === 0 && !placeholderVisible) {
                        text = placeholder;
                        color = Theme.secondaryHighlightColor;
                        placeholderVisible = true;
                    }
                }
            }

            Row {
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                spacing: Theme.paddingMedium
                Button {

                    width: parent.width / 2 - Theme.paddingMedium
                    text: qsTr("Add a picture")
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("../dialogs/AddPictureDialog.qml"));
                        dialog.accepted.connect(function() {
                            note.picturePaths += (note.picturePaths.length > 0 ? "," : "")
                                    + dialog.picturePath;
                            gridModel.append({path: dialog.picturePath});
                        });
                    }
                }
                Button {
                    width: parent.width / 2
                    text: qsTr("Add a photo")
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("../pages/CameraPage.qml"));
                        dialog.accepted.connect(function() {
                            note.picturePaths += (note.picturePaths.length > 0 ? "," : "")
                                    + dialog.photoPath;
                            gridModel.append({path: dialog.photoPath});
                        });
                    }
                }
            }
            AudioPlayer {
                id: audioPlayer
                x: Theme.paddingMedium
                width: parent.width - 2 * Theme.paddingMedium
                audioFilePath: note.audioFilePath
            }

            SilicaGridView {
                id: gridView
                x: Theme.paddingLarge
                width: parent.width - 2 * Theme.paddingLarge
                height: cellHeight * (gridModel.count + 1) / 2
                cellWidth: width / 2
                cellHeight: width / 2
                model: gridModel

                delegate: Item {
                    x: Theme.paddingLarge
                    y: Theme.paddingLarge
                    width: gridView.cellWidth - Theme.paddingMedium
                    height: gridView.cellHeight - Theme.paddingMedium

                    Column {
                        anchors.fill: parent
                        Image {
                            height: parent.height - deleteButton.height
                            anchors {
                                left: parent.left
                                right: parent.right
                            }
                            fillMode: Image.PreserveAspectCrop
                            source: path
                        }
                        Button {
                            id: deleteButton
                            width: parent.width
                            text: qsTr("Delete")
                            onClicked: {
                                needRemovePicture = true;
                                picturesToRemove.push(path);
                                note.picturePaths.replace("," + path, '');
                                gridView.model.remove(index);
                            }
                        }
                    }
                }
                Component.onCompleted: {
                    note.picturePaths.split(',').filter(function(path) {
                        return path.length > 0;
                    }).forEach(function(path) {
                        gridModel.append({path: path});
                    });
                }
            }
        }
    }

    onAccepted: {
        note.title = titleTextField.text;
        note.description = placeholderVisible ? "" : descriptionTextEdit.text;
        note.audioFilePath = audioPlayer.audioFileExists ? audioPlayer.audioFilePath : "";
    }
}
