import QtQuick

Item {
    id: itemRoot
    width: parent.width
    height: parent.height
    property real centerX : (width / 2);
    property real centerY : (height / 2);
    property real rotationAngle
    property string handColor
    property string handType
    property real widthPer
    property real heightPer
    property real tempRotationAngle
    function handDraging() {
        const oldHours = clockBody.hours * 60 * 60
        const oldMinutes = clockBody.minutes * 60
        if(handType === "hour") {
            const newHours = Math.floor(itemRoot.tempRotationAngle / 30)
            clockBody.secondsOfDay = (clockBody.hours > 12 ? (newHours + 12) * 60 * 60 : newHours * 60 * 60) + oldMinutes + clockBody.seconds
        }
        if(handType === "minute") {
            const newMinutes = Math.floor(itemRoot.tempRotationAngle / 6)
            clockBody.secondsOfDay = oldHours + (newMinutes * 60) + clockBody.seconds
        }
        if(handType === "second") {
            const newSeconds = Math.floor(itemRoot.tempRotationAngle / 6)
            clockBody.secondsOfDay = oldHours + oldMinutes + newSeconds
        }
    }
    function handStoppedDragging() {
        root.run = true
    }
    Rectangle {
        id: clockHandRoot

        anchors.centerIn: parent
        width: parent.width<parent.height?parent.width:parent.height
        height: width
        radius: width*0.5
        color: "transparent"
        Rectangle {
            id: hand
            color: handColor
            anchors.horizontalCenter: parent.horizontalCenter
            y: clockBody.height/2 - hand.height
            x: clockBody.width/2 - hand.width
            width: clockBody.width * widthPer
            height: clockBody.height * heightPer
            radius: width * 0.5
            transform: Rotation {
                origin.x:hand.width/2 ;
                origin.y:hand.height;
                angle: rotationAngle
            }
            MouseArea{
                anchors.fill: parent;
                onPositionChanged:  (mouseX, mouseY) => {
                                        root.run = false
                                        var point =  mapToItem (itemRoot, mouseX, mouseY);
                                        var diffX = (point.x - itemRoot.centerX);
                                        var diffY = -1 * (point.y - itemRoot.centerY);
                                        var rad = Math.atan (diffY / diffX);
                                        var deg = (rad * 180 / Math.PI);
                                        if (diffX > 0 && diffY > 0) {
                                            itemRoot.tempRotationAngle = 90 - Math.abs (deg);
                                        }
                                        else if (diffX > 0 && diffY < 0) {
                                            itemRoot.tempRotationAngle = 90 + Math.abs (deg);
                                        }
                                        else if (diffX < 0 && diffY > 0) {
                                            itemRoot.tempRotationAngle = 270 + Math.abs (deg);
                                        }
                                        else if (diffX < 0 && diffY < 0) {
                                            itemRoot.tempRotationAngle = 270 - Math.abs (deg);
                                        }
                                        handDraging()
                                    }
                onClicked: handDraging()
                onReleased: handStoppedDragging()
            }
        }
    }
}
