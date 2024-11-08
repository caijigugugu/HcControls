import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Templates as T
import Qt5Compat.GraphicalEffects

import HcControls

Rectangle {
    property string name: "Stage" + (indexOfPcr + 1).toString()
    property int indexOfPcr: 0
    property int cycles: 1
    property int type: HcPcrHelper.StageType.Pcr
    property bool updateType: false

    function getName(type) {
        var name = ""

        switch (type) {
            case HcPcrHelper.StageType.PrePcr:
                name = "Pre-PCR"
                break
            case HcPcrHelper.StageType.Hold:
                name = "Hold"
                break
            case HcPcrHelper.StageType.Pcr:
                name = "PCR"
                break
            case HcPcrHelper.StageType.PostPcr:
                name = "Post-PCR"
                break
            case HcPcrHelper.StageType.Infinite:
                name = "Infinite"
                break
            default:
                console.log("invalid type, type =", type)
        }

        return name
    }

    function getWidth() {
        var width = 300
        var stepWidth = 300
        var cnt = 1

        if (HcPcrHelper.pcr) {
            stepWidth = HcPcrHelper.pcr.stepWidth
            var stage = HcPcrHelper.pcr.pcrStageModel.get(control.indexOfPcr)

            if (stage) {
                cnt = stage.pcrStepModel.count
                width = stepWidth * cnt + (cnt - 1) * listView.spacing
            }

            return width
        }
    }

    id:control
    implicitWidth: getWidth()
    implicitHeight: HcPcrHelper.pcr.stepHeight + 130

    component IconButton: Rectangle {
        property string src: ""
        signal clicked()

        implicitWidth: 20
        implicitHeight: width
        color: "transparent"

        HcSvgImage {
            anchors.fill: parent
            source: parent.src
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.clicked()
            }
        }
    }

    component IconButtons: Row {
        spacing: 10
        visible: HcPcrHelper.pcr.editable

        IconButton {
            src: "../../Icon/btn_delete.svg"
            visible: control.indexOfPcr === 0 ? false : true
            onClicked: {
                HcPcrHelper.pcr.removeStage(control.indexOfPcr)
            }
        }
        IconButton {
            src: "../../Icon/btn_add.svg"
            visible: control.type > HcPcrHelper.StageType.PrePcr && control.type < HcPcrHelper.StageType.PostPcr
            onClicked: {
                var obj = HcPcrHelper.createPcrStageObj({
                        indexOfPcr: control.indexOfPcr + 1,
                        cycles: 1,
                    })

                HcPcrHelper.pcr.insertStage(control.indexOfPcr + 1, obj)
            }
        }
    }

    Rectangle {
        id: topRect
        width: parent.width
        height: 60/*100*/
        anchors.top: parent.top
        border.width: 1
        border.color: "black"
        color: "#5E5E5E"

        RowLayout {
            anchors.fill: parent

            IconButton {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                Layout.leftMargin: 10
                src: "../../Icon/btn_add.svg"
                visible: HcPcrHelper.pcr.editable &&
                         control.type > HcPcrHelper.StageType.PrePcr && control.type < HcPcrHelper.StageType.PostPcr
                onClicked: {
                    var obj = HcPcrHelper.createPcrStageObj({
                            indexOfPcr: control.indexOfPcr,
                            cycles: 1,
                        })

                    HcPcrHelper.pcr.insertStage(control.indexOfPcr, obj)
                }
            }

            ComboBox {
                id: combobox
                Layout.preferredWidth: 100
                Layout.preferredHeight: 30
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                displayText: /*""*/getName(control.type)
                textRole: "key"
                model: [/*{key: "Pre-PCR", value: 0}, */{key: "Hold", value: 1}, {key: "PCR", value: 2},
                        /*{key: "Post-PCR", value: 3},*/ {key: "Infinite", value: 4}]
                indicator: Item{}
                flat: true

                contentItem: TextInput {
                    width: contentWidth
                    height: contentHeight
                    leftPadding: 5
                    text: combobox.displayText
                    font.pixelSize: 16
                    color: "#DFDFDF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.centerIn: parent

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            updateType = true
                            comboboxPopup.open()
                        }
                    }
                }
                delegate: ItemDelegate {
                    width: combobox.width
                    highlighted: combobox.highlightedIndex === index

                    contentItem: Text {
                        text: modelData.key
                        color: "#DFDFDF"
                        font.pixelSize: 14
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: combobox.highlightedIndex === index ? /*"#0DBECC"*/"#364444" : "#5E5E5E"
                    }

                    required property int index
                    required property var modelData
                }
                popup: T.Popup {
                    id: comboboxPopup
                    x: 0
                    y: combobox.height
                    width: combobox.width
                    height: combocontrollistView.contentHeight

                    contentItem: ListView {
                        id: combocontrollistView
                        clip: true
                        cacheBuffer: 10
                        implicitHeight: contentHeight
                        model: combobox.delegateModel
                        currentIndex: combobox.highlightedIndex
                        highlightMoveDuration: 0
                        spacing: 0

                        T.ScrollIndicator.vertical: ScrollIndicator { }
                    }
                    background: Rectangle {
                        color: "#5E5E5E"
                    }
                }

                onCurrentValueChanged: {
                    if (updateType) {
                        control.type = combobox.currentValue.value
                        HcPcrHelper.pcr.updateStageType(control.indexOfPcr, control.type)
                        updateType = false
                    }
                }
            }
            IconButtons {
                Layout.preferredWidth: control.indexOfPcr === 0 ? 20 : 50
                Layout.preferredHeight: 20
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                Layout.rightMargin: 10
            }
        }
    }

    Rectangle {
        width: parent.width
        height: 70
        anchors.top: parent.top
        anchors.topMargin: 60
        border.width: 1
        border.color: "black"
        color: "#5E5E5E"/*"blue"*/

        Row {
            anchors.centerIn: parent
            spacing: 20

            Label {
                text: "Cycles"
                font.pixelSize: 16
                color: "#DFDFDF"/*"white"*/
                anchors.verticalCenter: parent.verticalCenter
            }
            Rectangle {
                width: 60
                height: 40
                radius: 4
                color: "#D9D9D9"
                anchors.verticalCenter: parent.verticalCenter

                TextInput {
                    id: textInput
                    width: contentWidth
                    height: 40
                    text: control.cycles
                    font.pixelSize: 14
                    color: "#484848"
                    anchors.centerIn: parent
                    padding: 5
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    enabled: HcPcrHelper.pcr.editable

                    onEditingFinished: {
                        control.cycles = parseInt(textInput.text)
                        HcPcrHelper.pcr.updateStageCycles(control.indexOfPcr, control.cycles)
                    }
                }
            }
        }
    }

    ListView {
        id: listView
        width: count * parent.width
        height: parent.height - 130
        anchors.top: parent.top
        anchors.topMargin: 130
        model: HcPcrHelper.pcr.pcrStageModel.get(control.indexOfPcr).pcrStepModel
        orientation: ListView.Horizontal
        interactive: false
        cacheBuffer: 20

        delegate: HcPcrStep {
            width: HcPcrHelper.pcr.stepWidth
            height: listView.height
            stageIndexOfPcr: model.stageIndexOfPcr
            indexOfPcr: model.indexOfPcr
            indexOfStage: model.indexOfStage
            startTemp: model.startTemp
            endTemp: model.endTemp
            hours: model.hours
            minutes: model.minutes
            seconds: model.seconds
            ratio: model.ratio
            enableGradient: model.enableGradient
            gradientTemp: model.gradientTemp
            gradientStartTemp: model.gradientStartTemp
            gradientStartCycle: model.gradientStartCycle
            gradientCycles: model.gradientCycles
            photographable: control.type === HcPcrHelper.StageType.PostPcr ? true : model.photographable
        }
    }

    Component.onCompleted: {
        if (HcPcrHelper.pcr.pcrStageModel.get(control.indexOfPcr).pcrStepModel.count === 0) {
            var preStep = HcPcrHelper.pcr.findPreStep(control.indexOfPcr, 0)
            var step = HcPcrHelper.createPcrStepObj({
                        startTemp: preStep ? preStep.endTemp : HcPcrHelper.pcr.roomTemp,
                        endTemp: HcPcrHelper.pcr.roomTemp,
                        indexOfPcr: preStep ? preStep.indexOfPcr + 1 : 0,
                        indexOfStage: 0,
                        stageIndexOfPcr: control.indexOfPcr
                    })

            HcPcrHelper.pcr.appendStep(control.indexOfPcr, step)
        }
    }
}
