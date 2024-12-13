import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import HcControls

HcScrollablePage{
    HcFrame{
        Layout.fillWidth: true
        Layout.preferredHeight: 340
        padding: 10
        ColumnLayout{
            anchors.verticalCenter: parent.verticalCenter
            HcText{
                text: qsTr("Horizontal FlipView")
            }
            HcFlipView{
                Item{
                    Rectangle{
                        anchors.fill: parent
                        color: "#cd5e3c"
                    }
                }
                Item{
                    HcRoundedRectangle{
                        anchors.fill: parent
                        color: "#6c848d"
                        radius: [10,0,10,0]
                    }
                }
                Item{
                    Rectangle{
                        anchors.fill: parent
                        color: "#68be8d"
                    }
                }
            }
        }
    }

    HcFrame{
        Layout.fillWidth: true
        height: 340
        padding: 10
        Layout.topMargin: 20
        ColumnLayout{
            anchors.verticalCenter: parent.verticalCenter
            HcText{
                text: qsTr("Carousel map")
            }
            HcCarousel{
                delegate: Component{
                    Rectangle{
                        anchors.fill: parent
                        color: model.color
                    }
                }
                Layout.alignment: Qt.AlignVCenter
                Component.onCompleted: {
                    model = [{color: "#f8b500"},{color: "#867ba9"},{color: "#c97586"}]
                }
            }
        }
    }
}
