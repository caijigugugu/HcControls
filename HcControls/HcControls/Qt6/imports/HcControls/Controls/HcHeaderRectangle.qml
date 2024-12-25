import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import HcControls

Item {
    property string titleName: qsTr("系统名称XXXXXX")
    implicitWidth: parent.width
    implicitHeight: 70
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            dateLabel.text = Qt.formatDate(new Date(), "yyyy/M/d")
            timeLabel.text = Qt.formatTime(new Date(), "HH:mm:ss")
        }
    }

    Rectangle {
        id: topRec
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: parent.height

        Image {
            id: image1
            source: "../Icon/background.png"
            fillMode: Image.PreserveAspectCrop
            horizontalAlignment: Image.AlignLeft // 水平左对齐
            verticalAlignment: Image.AlignTop // 垂直顶部对齐
            smooth: true
            antialiasing: true
            anchors.fill: parent

        }
        LinearGradient {
            anchors.fill:parent
            start: Qt.point(0, height)
            end: Qt.point(width, 0)
            gradient: HcTheme.dark ? Constants.headerRecDeepGradient : Constants.headerRecGradient
        }
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            //瀚辰logo
            Image {
                id: logo
                Layout.preferredWidth: implicitWidth
                Layout.preferredHeight: implicitHeight
                source: "../Icon/logo1.png"
                Layout.alignment: Qt.AlignVCenter
                //图片内容没有居中，手动设置topMargin居中
                Layout.topMargin: 11
            }

            Item {
                width: 20
            }

            //分割线
            Rectangle {
                height: parent.height / 3
                implicitWidth: 1
                color: "white"
                opacity: 1
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                width: 20
            }

            //软件名称
            Label {
                id: softName
                Layout.preferredWidth: implicitWidth
                Layout.preferredHeight: implicitHeight
                y:0
                text: titleName
                color: "white"
                font.bold: true
                font.pixelSize: 28
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            // 日期组件
            ColumnLayout {
                spacing: 0

                Label {
                    id: dateLabel
                    text: Qt.formatDate(new Date(), "yyyy/M/d")
                    color: "white"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    id: timeLabel
                    text: Qt.formatTime(new Date(), "HH:mm:ss")
                    color: "white"
                    font.pixelSize: 20
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

}
