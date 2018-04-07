import QtQuick 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0

Dialog {

    property string picturePath

    Camera {
        id: camera
        imageCapture {
            onImageSaved: {
                picturePath = path;
                fileHelper.rotatePhoto(path);
                pageStack.backNavigation = true;
                pageStack.forwardNavigation = true;
                accept();
            }
        }
    }
    VideoOutput {
        anchors.fill: parent
        source: camera
        focus: visible
        fillMode: VideoOutput.PreserveAspectFit
        orientation: Orientation.All
        MouseArea {
            anchors.fill: parent
            onClicked: {
                camera.imageCapture.captureToLocation(fileHelper.generatePictureFullPath("jpg"));
            }
        }
    }
    Component.onCompleted: {
        pageStack.backNavigation = false;
        pageStack.forwardNavigation = false;
    }
}

