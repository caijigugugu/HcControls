import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import HcControls

Rectangle {
    property string name: "Step" + (indexOfStage + 1).toString()
    property int minimumWidth: 300
    property int maximumWidth: 600
    property int minimumHeight: 300
    property int maximumHeight: 600
    property int indexOfPcr: 0
    property int indexOfStage: 0
    property int stageIndexOfPcr: 0
    property int stageType: HcPcrHelper.pcr.pcrStageModel.get(control.stageIndexOfPcr).type
    property int startTemp: 0
    property int endTemp: 0
    property int hours: 0
    property int minutes: 0
    property int seconds: 30
    property double ratio: 3.5
    property bool enableGradient: false
    property double gradientTemp: 0.0
    property double gradientStartTemp: 0.0
    property int gradientStartCycle: 0
    property int gradientCycles: 0
    property bool photographable: false
    property bool running: false

    function setWidth(width) {
        if (width < control.minimumWidth) {
            control.width = control.minimumWidth
        } else if (width > control.maximumWidth) {
            control.width = control.maximumWidth
        } else {
            control.width = width
        }
    }

    function setHeight(height) {
        if (height < control.minimumHeight) {
            control.height = control.minimumHeight
        } else if (height > control.maximumHeight) {
            control.height = control.maximumHeight
        } else {
            control.height = height
        }
    }

    function updateEndTemp() {
        control.endTemp = parseFloat(tempText.getText())
        HcPcrHelper.pcr.updateStepEndTemp(control.stageIndexOfPcr, control.indexOfStage, control.endTemp)
    }

    function calHeight(temp, item) {
        var ratio = temp / HcPcrHelper.pcr.maxTemp

        return item.height * ratio
    }

    function getTempLineHeight() {
        return calHeight(control.endTemp, canvasRect)
    }

    function getTempRatio() {
        return control.ratio
//        return Math.abs(control.endTemp - control.startTemp) / (control.hours * 3600 + control.minutes * 60 + control.seconds)
    }

    function updateTempRatio() {
        tempRatioLabel.y = canvasRect.height - getTempLineHeight()/2
        tempRatioLabel.text = getTempRatio().toFixed(2) + "℃/s"

        if (tempRatioLabel.y + 40 > canvasRect.height) {
            tempRatioLabel.y = canvasRect.height - 40
        }
    }

    id:control
    implicitWidth: HcPcrHelper.pcr? HcPcrHelper.pcr.stepWidth : 300
    implicitHeight: HcPcrHelper.pcr? HcPcrHelper.pcr.stepHeight : 720
//    border.color: "black"
//    border.width: 1
    color: "#2D3131"

    // 上面四分之一区显示step名&功能按键，如添加、删除、拍照等
    component IconButton: Rectangle {
        property string src: ""
        signal clicked()

        width: 30
        height: width
        radius: width/2
        color: "#505454"

        Item {
            width: 16
            height: 16
            anchors.centerIn: parent

            HcSvgImage {
                anchors.fill: parent
                source: parent.parent.src
            }
        }
//        Image {
//            source: parent.src
//            width: parent.width * 3/4
//            height: parent.height * 3/4
//            fillMode: Image.Pad
//            anchors.centerIn: parent
//        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.clicked()
            }
        }
    }

    component IconButtons: Column {
        spacing: 10
        visible: HcPcrHelper.pcr.editable

        Row {
            spacing: 10
            anchors.right: parent.right

            IconButton {
                id: delBtn
                src: "../../Icon/btn_delete.svg"
                visible: control.indexOfStage === 0 ? false : true
                onClicked: {
                    HcPcrHelper.pcr.removeStep(control.stageIndexOfPcr, control.indexOfStage)
                }
            }
            IconButton {
                id: addBtn
                src: "../../Icon/btn_add.svg"
                visible: stageType > HcPcrHelper.StageType.PrePcr && stageType < HcPcrHelper.StageType.PostPcr
                onClicked: {
                    var obj = HcPcrHelper.createPcrStepObj({
                            startTemp: HcPcrHelper.pcr.roomTemp,
                            endTemp: HcPcrHelper.pcr.roomTemp,
                            indexOfStage: control.indexOfStage + 1,
                            indexOfPcr: control.indexOfPcr + 1,
                            stageIndexOfPcr: control.stageIndexOfPcr
                        })

                    HcPcrHelper.pcr.insertStep(control.stageIndexOfPcr, control.indexOfStage + 1, obj)
                }
            }
        }
        Row {
            spacing: 10

            IconButton {
                id: settingBtn
                src: "../../Icon/btn_set.svg"
//                visible: stageType === HcPcrHelper.StageType.Pcr
                visible: false  // 下位机未实现，先隐藏
                onClicked: {
                    gradientPopup.open()
                }
            }
            IconButton {
                id: photoBtn
                src: control.photographable ? "../../Icon/btn_photo_select.svg" : "../../Icon/btn_photo.svg"
                visible: stageType === HcPcrHelper.StageType.PrePcr ||
                         stageType === HcPcrHelper.StageType.Hold ||
                         stageType === HcPcrHelper.StageType.Pcr
                onClicked: {
                    control.photographable = !control.photographable
                }
            }
        }
    }

    component TextEditLine: Rectangle {
        property string content: ""
        property color greyColor: "#D9D9D9"
        property color normalColor: "#DFDFDF"

        signal editingFinished()

        function getText() {
            return textInput.text
        }

        color: HcPcrHelper.pcr.editable ? normalColor : greyColor
        width: textInput.width + 10
        height: 30

        TextInput {
            id: textInput
            width: contentWidth
            height: 30
            text: parent.content
            font.pixelSize: 14
            color: "#484848"
            anchors.centerIn: parent
//            padding: 5
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            enabled: HcPcrHelper.pcr.editable

            onEditingFinished: { parent.editingFinished() }
        }
    }

    component LabelTextEditLine: Row {
        property string label: ""
        property string content: ""

        Label {
            width: parent.width/4
            height: parent.height
            text: parent.label
            color: "#484848"
            font.pixelSize: 16
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
        }
        Rectangle {
            width: parent.width * 3/4
            height: parent.height
            color: "transparent"
            border.width: 1
            border.color: "black"

            TextInput {
                width: parent.width
                height: parent.height
                text: ""
                font.pixelSize: 14
                color: "#484848"
                anchors.centerIn: parent
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                leftPadding: 5

                onEditingFinished: {
                    parent.parent.content = text
                }
            }
        }
    }

    HcPopup {
        id: gradientPopup
        width: 600
        height: 400
        title: qsTr("Gradient Setting")
        headerFontSize: 16
        modal: true
        parent: Overlay.overlay

        Column {
            spacing: 10
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 30

            LabelTextEditLine {
                id: startCycleInput
                width: 400
                height: 30
                label: qsTr("Start Cycle: ")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            LabelTextEditLine {
                id: cyclesInput
                width: 400
                height: 30
                label: qsTr("Cycles: ")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            LabelTextEditLine {
                id: startTempInput
                width: 400
                height: 30
                label: qsTr("Start Temperature: ")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            LabelTextEditLine {
                id: gradientTempInput
                width: 400
                height: 30
                label: qsTr("Gradient Temperature: ")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            CheckBox {
                id: enableGradientCheckBox
                width: 200
                height: 40
                checkState: Qt.Unchecked
                text: qsTr("enable gradient cycle")
                font.pixelSize: 16
                palette.text: "#5E5E5E"
                palette.windowText: "#484848"
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    enableGradientCheckBox.checkState = enableGradientCheckBox.checkState === Qt.Unchecked ? Qt.Checked : Qt.Unchecked
                }
            }
            Item {width: 1; height: 10}
            Row {
                spacing: 100
                anchors.horizontalCenter: parent.horizontalCenter

                HcButton {
                    id: confirmBtn
                    width: 60
                    height: 30
                    text: qsTr("OK")
                    font.pixelSize: 16
                    fontColor: "#484848"
                    bgGradient: Gradient {
                        GradientStop {
                            position: 0
                            color: "#DFDEDE"
                        }

                        GradientStop {
                            position: 1
                            color: "#9EA1A1"
                        }
                        orientation: Gradient.Vertical
                    }

                    onClicked: {
                        control.enableGradient = enableGradientCheckBox.checked
                        control.gradientStartCycle = parseInt(startCycleInput.content)
                        control.gradientCycles = parseInt(cyclesInput.content)
                        control.gradientStartTemp = parseFloat(startTempInput.content)
                        control.gradientTemp = parseFloat(gradientTempInput.content)
                        gradientPopup.close()
                    }
                }
                HcButton {
                    width: 60
                    height: 30
                    text: qsTr("Cancel")
                    font.pixelSize: 16
                    fontColor: "#484848"
                    bgGradient: confirmBtn.bgGradient

                    onClicked: {
                        gradientPopup.close()
                    }
                }
            }
        }
    }

    IconButton {
        id: leftAddBtn
//        height: 80
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 10
        src: "../../Icon/btn_add.svg"
        visible: HcPcrHelper.pcr.editable &&
                 stageType > HcPcrHelper.StageType.PrePcr &&
                 stageType < HcPcrHelper.StageType.PostPcr

        onClicked: {
            var obj = HcPcrHelper.createPcrStepObj({
                    startTemp: HcPcrHelper.pcr.roomTemp,
                    endTemp: HcPcrHelper.pcr.roomTemp,
                    indexOfStage: control.indexOfStage,
                    indexOfPcr: control.indexOfPcr,
                    stageIndexOfPcr: control.stageIndexOfPcr
                })

            HcPcrHelper.pcr.insertStep(control.stageIndexOfPcr, control.indexOfStage, obj)
        }
    }
    // 名称
    Label {
        id: label
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 10 + leftAddBtn.width + (btns.x - (leftAddBtn.x + leftAddBtn.width) - control.width) / 2
        anchors.verticalCenter: leftAddBtn.verticalCenter
//        anchors.left: parent.left
//        anchors.leftMargin: 20
        text: control.name
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: "#DFDFDF"/*"white"*/
        font.pixelSize: 16
    }
    // 功能按键
    IconButtons {
        id: btns
        height: 80
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 10
    }
    Rectangle {
        id: canvasRect
        width: parent.width
        height: parent.height - Math.max(label.height, btns.height) - 80
        color: "transparent"
        anchors.bottom: parent.bottom

        Canvas {
            id: canvas
            anchors.fill: parent
            onPaint: {
    //            console.log("repaint event has received, index = ", control.indexOfStage, ", control.startTemp = ", control.startTemp, ", control.endTemp = ", control.endTemp)

                var ctx = getContext("2d")

                ctx.clearRect(0, 0, parent.width, parent.height)
                ctx.strokeStyle = running ? "#EE9F05" : "#0DBECC"
                ctx.fillStyle = running ? "#59523C" : "#28484A"
//                ctx.globalAlpha = 0.5
                ctx.lineWidth = 2

                // 绘制温度线
                if (control.startTemp != control.endTemp) {
                    ctx.setLineDash([5,2])
                    ctx.beginPath()
                    ctx.moveTo(0, parent.height - calHeight(control.startTemp, canvasRect))
                    ctx.lineTo(parent.width * 3/8, Math.max(parent.height - getTempLineHeight(), 1))
                    ctx.stroke()
                    // 切换回实线
                    ctx.setLineDash([])
                    ctx.beginPath()
                    ctx.moveTo(parent.width * 3/8, Math.max(parent.height - getTempLineHeight(), 1))
                    ctx.lineTo(parent.width, Math.max(parent.height - getTempLineHeight(), 1))
                    ctx.stroke()

                    // 填充绘制区域颜色
                    ctx.beginPath()
                    ctx.moveTo(0, parent.height - calHeight(control.startTemp, canvasRect))
                    ctx.lineTo(parent.width * 3/8, Math.max(parent.height - getTempLineHeight(), 1))
                    ctx.lineTo(parent.width, Math.max(parent.height - getTempLineHeight(), 1))
                    ctx.lineTo(parent.width, parent.height)
                    ctx.lineTo(0, parent.height)
                    ctx.fill()
                } else {
                    ctx.beginPath()
                    ctx.moveTo(0, Math.max(parent.height - getTempLineHeight(), 1))
                    ctx.lineTo(parent.width, Math.max(parent.height - getTempLineHeight(), 1))
                    ctx.stroke()
                    ctx.lineTo(parent.width, parent.height)
                    ctx.lineTo(0, parent.height)
                    ctx.fill()
                }
            }
        }
        // 温度编辑框
        Row {
            x: parent.width * 1/2
            y: Math.min(parent.height - getTempLineHeight() - 40, parent.height - 80)

            TextEditLine {
                id: tempText
                width: /*textInput.width*/children[0].contentWidth + 20 // 测试是否可行
                height: 30
                content: control.endTemp
                onEditingFinished: {
                    updateEndTemp()
                }
            }
            Rectangle {
                color: "#C1C1C1"
                width: tempUnitText.width + 10
                height: 30

                Text {
                    id: tempUnitText
                    width: contentWidth
                    height: 30
                    text: "℃"
                    font.pixelSize: 16
                    color: "#484848"
                    anchors.centerIn: parent
                    padding: 5
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        // 温度保持时间
        Row {
            x: parent.width * 1/2
            y: Math.min(parent.height - getTempLineHeight() + 10, parent.height - 40)
            visible: stageType !== HcPcrHelper.StageType.Infinite

            TextEditLine {
                id: hoursText
                content: control.hours.toString().padStart(2, "0")
                onEditingFinished: {
                    control.hours = parseInt(hoursText.getText())
                    HcPcrHelper.pcr.updateStepHours(control.stageIndexOfPcr, control.indexOfStage, control.hours)
                }
            }
            Label {
                text: ":"
                font.pixelSize: 16
                color: "white"/*"#D9D9D9"*/
                padding: 5
            }
            TextEditLine {
                id: minutesText
                content: control.minutes.toString().padStart(2, "0")
                onEditingFinished: {
                    control.minutes = parseInt(minutesText.getText())
                    HcPcrHelper.pcr.updateStepMinutes(control.stageIndexOfPcr, control.indexOfStage, control.minutes)
                }
            }
            Label {
                text: ":"
                font.pixelSize: 16
                color: "white"/*"#D9D9D9"*/
                padding: 5
            }
            TextEditLine {
                id: secondsText
                content: control.seconds.toString().padStart(2, "0")
                onEditingFinished: {
                    control.seconds = parseInt(secondsText.getText())
                    HcPcrHelper.pcr.updateStepSeconds(control.stageIndexOfPcr, control.indexOfStage, control.seconds)
                }
            }
        }
        // 变温速率
        Label {
            id: tempRatioLabel
            x: parent.width/8
            y: Math.min(parent.height - getTempLineHeight()/2, parent.height - 40)
            text: getTempRatio().toFixed(2) + "℃/s"
            color: "white"/*"#484848"*/
            font.pixelSize: 16
            visible: control.startTemp != control.endTemp
        }
    }

    // 绘制边界
    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")

            ctx.strokeStyle = "black"/*"#000000"*/
            ctx.lineWidth = 1

            ctx.beginPath()
            ctx.moveTo(0, 0)
            ctx.lineTo(parent.width, 0)
            ctx.lineTo(parent.width, parent.height)
            ctx.lineTo(0, parent.height)
            ctx.lineTo(0, 0)
            ctx.stroke()
        }
    }

    onStartTempChanged: {
//        console.log("start temprature has changed, index = ", control.indexOfStage, ", startTemp = ", control.startTemp)
        updateTempRatio()
        canvas.requestPaint()
    }

    onEndTempChanged: {
        updateTempRatio()
        canvas.requestPaint()
    }

    onHoursChanged: {
        updateTempRatio()
    }

    onMinutesChanged: {
        updateTempRatio()
    }

    onSecondsChanged: {
        updateTempRatio()
    }

    Connections {
        target: HcPcrHelper
        onMaxTempChanged: (maxTemp) => {
//           console.log("stage index =", control.stageIndexOfPcr, ", step index =", control.indexOfStage,
//                       ", max temprature changed, temperatue =", maxTemp, ", repaint window imminently.")
           canvas.requestPaint()
           control.update()
        }
    }

    Connections {
        target: HcPcrHelper
        onStageTypeChanged: (index, type) => {
            if (control.stageIndexOfPcr === index) {
                stageType = type
            }
        }
    }

    Connections {
        target: HcPcrHelper
        onRunStepChanged: (stageIndex, stepIndex) => {
            var lastState = control.running

            if (stageIndex === control.stageIndexOfPcr && stepIndex === control.indexOfStage) {
                control.running = true
            } else {
                control.running = false
            }

            if (lastState != control.running) {
                console.log("run state changed, repaint canvas imminently.")
                canvas.requestPaint()
            }
        }
    }

    Component.onCompleted: {
    }
}
