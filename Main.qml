import QtQuick
import QtQuick.Window

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Clock")

    function updateTime(secondsOfDay) {
        clockBody.secondsOfDay = secondsOfDay
    }

    function handDraging() {
        root.run = false
    }
    function handStoppedDragging() {
        root.run = true
    }
    function updateAmPm() {
        clockBody.secondsOfDay = clockBody.hours > 12 ? clockBody.secondsOfDay - (12*3600) : clockBody.secondsOfDay + (12*3600)
    }

    Item {
        id: root
        property bool run: true;

        width: parent.width
        height: parent.height
        visible: true

        Timer{
            repeat: true
            interval: 1000
            running: root.run
            onTriggered: updateTime(clockBody.secondsOfDay + 1);
        }

        Rectangle {
            id: clockBody
            property color clockBorderColor: "gray"
            property real secondsOfDay: (new Date().getHours()*60*60)+(new Date().getMinutes()*60)+new Date().getSeconds()
            property real hours: Math.floor(secondsOfDay / (60*60))
            property real minutes: Math.floor((secondsOfDay % (60*60)) / 60)
            property real seconds: Math.floor((secondsOfDay % (60*60))%60)
            property string aAndpM: hours > 12 ? "PM" : "AM"
            anchors.centerIn: parent
            width: parent.width < parent.height ? parent.width : parent.height
            height: width
            radius: width*0.5
            border {
                color: clockBorderColor
                width: width*0.03
            }
            color: "transparent"
            Rectangle {
                id: amAndPmSwitch
                color: "transparent"
                x: 0
                y: 0
                width: parent.width * 0.10
                height: parent.height * 0.10
                border {
                    color: "black"
                    width: width*0.03
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        clockBody.secondsOfDay = clockBody.hours > 12 ? clockBody.secondsOfDay - (12*3600) : clockBody.secondsOfDay + (12*3600)
                    }
                }

                Text {
                    color: "black"
                    text: `${clockBody.aAndpM === "AM" ? "PM" : "AM"}`
                    anchors {
                        centerIn: parent
                    }
                    font.pointSize: (parent.width * 0.25)
                }
            }

            Repeater {
                id: numbersRepeater
                anchors.fill: parent
                property real originX: numbersRepeater.width/2
                property real originY: numbersRepeater.height/2
                property real radiusCircle: numbersRepeater.width/2 * 0.87
                property bool allTimeNumbers: true;

                property var listName: [0]

                Component.onCompleted: {
                    for(var i = 3 ; i < 15 ; ++i)
                    {
                        numbersRepeater.listName[i-3] = i%12;
                    }
                    numbersRepeater.listName[9] =12;
                    numbersRepeater.model=12;
                }

                Text {
                    color: "black"
                    x:numbersRepeater.originX + numbersRepeater.radiusCircle * Math.cos(index * 2*Math.PI/numbersRepeater.listName.length) - width/2
                    y:numbersRepeater.originY + numbersRepeater.radiusCircle * Math.sin(index * 2*Math.PI/numbersRepeater.listName.length) - height/2
                    font.pointSize: numbersRepeater.width >= 100 ? numbersRepeater.width/10:8;
                    text: numbersRepeater.listName[index];
                }
            }
            ClockHand {
                rotationAngle: ((clockBody.hours > 12 ? clockBody.hours - 12 : clockBody.hours) + (clockBody.minutes/100)) * 360 / 12
                handColor: "black"
                handType: "hour"
                widthPer: 0.05
                heightPer: 0.3
            }
            ClockHand {
                rotationAngle: clockBody.minutes * 360 / 60
                handColor: "blue"
                handType: "minute"
                widthPer: 0.04
                heightPer: 0.4
            }
            ClockHand {
                rotationAngle: clockBody.seconds * 360 / 60
                handColor: "red"
                handType: "second"
                widthPer: 0.02
                heightPer: 0.4
            }
            Text {
                color: "black"
                text: `${clockBody.hours > 12 ? ('0' + (clockBody.hours - 12)).slice(-2) : ('0' + clockBody.hours).slice(-2)}:${('0' + clockBody.minutes).slice(-2)}:${('0' + clockBody.seconds).slice(-2)} ${clockBody.aAndpM}`
                anchors {
                    centerIn: parent
                }
                bottomPadding: parent.height * 0.15
                font.pointSize: (parent.width * 0.07)
            }
        }


    }
}
