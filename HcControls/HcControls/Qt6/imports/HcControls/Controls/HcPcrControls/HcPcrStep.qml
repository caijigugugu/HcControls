import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import HcControls

Rectangle {
    property string name: "Step" + (indexOfStage + 1).toString()
    property int minimumWidth: 250
    property int maximumWidth: 600
    property int minimumHeight: 250
    property int maximumHeight: 600
    property int indexOfPcr: 0              //该步骤在所有步骤中的索引
    property int indexOfStage: 0            //该步骤在该阶段中的索引
    property int stageIndexOfPcr: 0         //该步骤所在阶段的索引
    property var pcr: null
    property int stageType: pcr.pcrStageModel.get(control.stageIndexOfPcr).type
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

    id:control
    implicitWidth: pcr ? pcr.stepWidth : 250
    implicitHeight: pcr ? pcr.stepHeight : 670
    border.color: HcTheme.dark ?  Constants.tempStageDeepBorderColor : Constants.tempStageBorderColor
    color: HcTheme.dark ?  Constants.tempMainDeepBackground : Constants.tempMainBackground
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
        pcr.updateStepEndTemp(control.stageIndexOfPcr, control.indexOfStage, control.endTemp)
    }

    function calHeight(temp, item) {
        var ratio = temp / pcr.maxTemp

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

    //上面四分之一区显示step名&功能按键，如添加、删除、拍照等
    component IconButton: Rectangle {
        property string src: ""
        signal clicked()

        width: 25
        height: width
        radius: width/2
        color: HcTheme.dark ?  Constants.tempBtnDeepBackground : Constants.tempBtnBackground

        Item {
            width: 13
            height: 13
            anchors.centerIn: parent

            HcSvgImage {
                anchors.fill: parent
                source: parent.parent.src
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.clicked()
            }
        }
    }

    //右侧四个按钮
    component IconButtons: Column {
        spacing: 8
        visible: pcr.editable
        Row {
            spacing: 8
            anchors.right: parent.right
            //删除步骤按钮
            IconButton {
                id: delBtn
                src: "../../Icon/btn_delete.svg"
                visible: control.indexOfStage === 0 ? false : true
                onClicked: {
                    pcr.removeStep(control.stageIndexOfPcr, control.indexOfStage)
                }
            }
            //设置按钮
            IconButton {
                id: settingBtn
                src: "../../Icon/btn_set.svg"
//                visible: stageType === HcPcrHelper.StageType.Pcr
                visible: true  // 下位机未实现，先隐藏
                onClicked: {
                    gradientPopup.open()
                }
            }

            //拍照按钮
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
        property color notEditColor: "transparent"
        property color normalColor: "#FFFFFF"

        signal editingFinished()

        function getText() {
            return textInput.text
        }

        color: pcr.editable ? normalColor : notEditColor
        width: textInput.width + 10
        height: 25

        TextInput {
            id: textInput
            width: contentWidth
            height: 25
            text: parent.content
            font.pixelSize: 12
            color: "#484848"
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: pcr.editable
            onEditingFinished: { parent.editingFinished() }
        }
        HcText {
            id: tmpText
            width: contentWidth
            height: 25
            text: parent.content
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 12
            visible: !pcr.editable
        }
    }

    //设置弹窗中的选项
    component LabelTextEditLine: Row {
        property string label: ""
        property string content: ""

        Label {
            width: parent.width/4
            height: parent.height
            text: parent.label
            color: "#484848"
            font.pixelSize: 13
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
                font.pixelSize: 12
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

    //设置弹窗
    HcContentPopup {
        id: gradientPopup
        width: 400
        height: 300
        title: qsTr("更多设置")
        headerFontSize: 16
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
                visible: false
            }

            LabelTextEditLine {
                id: cyclesInput
                width: 400
                height: 30
                label: qsTr("Cycles: ")
                anchors.horizontalCenter: parent.horizontalCenter
                visible: false
            }

            LabelTextEditLine {
                id: startTempInput
                width: 400
                height: 30
                label: qsTr("Start Temperature: ")
                anchors.horizontalCenter: parent.horizontalCenter
                visible: false
            }

            LabelTextEditLine {
                id: gradientTempInput
                width: 400
                height: 30
                label: qsTr("Gradient Temperature: ")
                anchors.horizontalCenter: parent.horizontalCenter
                visible: false
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
                visible: false
                onClicked: {
                    enableGradientCheckBox.checkState = enableGradientCheckBox.checkState === Qt.Checked ? Qt.Checked : Qt.Unchecked
                }
            }
            LabelTextEditLine {
                id: ramp
                width: 250
                height: 30
                label: qsTr("变温速率: ")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            LabelTextEditLine {
                id: temperatureChange
                width: 250
                height: 30
                label: qsTr("梯度升降温: ")
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Item {width: 1; height: 50}

            Row {
                spacing: 100
                anchors.horizontalCenter: parent.horizontalCenter
                //Cancel按钮
                HcButton {
                    width: 60
                    height: 30
                    text: qsTr("Cancel")
                    font.pixelSize: 16
                    fontColor: "#484848"
                    buttonColor: confirmBtn.buttonColor

                    onClicked: {
                        gradientPopup.close()
                    }
                }
                //ok按钮
                HcButton {
                    id: confirmBtn
                    width: 60
                    height: 30
                    text: qsTr("OK")
                    font.pixelSize: 16
                    fontColor: "#484848"
                    buttonColor: Gradient {
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
            }
        }
    }
    /************************开始绘制页面*************************/


    //添加上一个步骤按钮
    IconButton {
        id: leftAddBtn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        src: "../../Icon/btn_add.svg"
        visible: pcr.editable &&
                 stageType > HcPcrHelper.StageType.PrePcr &&
                 stageType < HcPcrHelper.StageType.PostPcr

        onClicked: {
            var obj = HcPcrHelper.createPcrStepObj({
                    startTemp: pcr.roomTemp,
                    endTemp: pcr.roomTemp,
                    indexOfStage: control.indexOfStage,
                    indexOfPcr: control.indexOfPcr,
                    stageIndexOfPcr: control.stageIndexOfPcr,
                    pcr: control.pcr
                })

            pcr.insertStep(control.stageIndexOfPcr, control.indexOfStage, obj)
        }
    }

    //增加步骤按钮
    IconButton {
        id: addBtn
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        src: "../../Icon/btn_add.svg"
        visible: pcr.editable && stageType > HcPcrHelper.StageType.PrePcr && stageType < HcPcrHelper.StageType.PostPcr
        onClicked: {
            var obj = HcPcrHelper.createPcrStepObj({
                                                       startTemp: pcr.roomTemp,
                                                       endTemp: pcr.roomTemp,
                                                       indexOfStage: control.indexOfStage + 1,
                                                       indexOfPcr: control.indexOfPcr + 1,
                                                       stageIndexOfPcr: control.stageIndexOfPcr,
                                                       pcr: control.pcr
                                                   })

            pcr.insertStep(control.stageIndexOfPcr, control.indexOfStage + 1, obj)
        }
    }

    // 名称
    HcText {
        id: label
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        text: control.name
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 13
    }

    // 功能按键
    IconButtons {
        id: btns
        height: 45
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
    }

    //曲线曲线框
    Rectangle {
        id: canvasRect
        width: parent.width
        height: parent.height - Math.max(label.height, btns.height) - 40    //这里是为了给温度编辑框留出空间
        color: "transparent"
        //anchors.bottom: parent.bottom
        anchors.bottom: bottomRect.top
        Canvas {
            id: canvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")

                ctx.clearRect(0, 0, parent.width, parent.height)
                ctx.strokeStyle = Constants.tempLineColor
                ctx.fillStyle = Constants.tempfillColor
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
            x: parent.width * 1/2 - 20
            y: Math.min(parent.height - getTempLineHeight() - 30, parent.height - 70)

            TextEditLine {
                id: tempText
                width: children[0].contentWidth + 15
                height: 22
                content: control.endTemp
                onEditingFinished: {
                    updateEndTemp()
                }
            }

            Rectangle {
                color: pcr.editable ? "#E4E4E4" : "transparent"
                width: tempUnitText.width + 8
                height: 22

                HcText {
                    id: tempUnitText
                    width: contentWidth
                    height: 22
                    text: "℃"
                    font.pixelSize: 12
                    anchors.centerIn: parent
                    padding: 5
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    visible: !pcr.editable
                }
                Text {
                    id: tempUnitText1
                    width: contentWidth
                    height: 22
                    text: "℃"
                    font.pixelSize: 12
                    anchors.centerIn: parent
                    padding: 5
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: "#484848"
                    visible: pcr.editable
                }
            }
        }

        // 温度保持时间
        Row {
            x: parent.width * 1/2  - 20
            y: Math.min(parent.height - getTempLineHeight() + 10, parent.height - 40)
            visible: stageType !== HcPcrHelper.StageType.Infinite

            TextEditLine {
                id: hoursText
                content: control.hours.toString().padStart(2, "0")
                onEditingFinished: {
                    control.hours = parseInt(hoursText.getText())
                    pcr.updateStepHours(control.stageIndexOfPcr, control.indexOfStage, control.hours)
                }
            }
            HcText {
                text: ":"
                font.pixelSize: 13
                padding: 5
            }
            TextEditLine {
                id: minutesText
                content: control.minutes.toString().padStart(2, "0")
                onEditingFinished: {
                    control.minutes = parseInt(minutesText.getText())
                    pcr.updateStepMinutes(control.stageIndexOfPcr, control.indexOfStage, control.minutes)
                }
            }
            HcText {
                text: ":"
                font.pixelSize: 13
                padding: 5
            }
            TextEditLine {
                id: secondsText
                content: control.seconds.toString().padStart(2, "0")
                onEditingFinished: {
                    control.seconds = parseInt(secondsText.getText())
                    pcr.updateStepSeconds(control.stageIndexOfPcr, control.indexOfStage, control.seconds)
                }
            }
        }

        // 变温速率
        HcText{
            id: tempRatioLabel
            x: parent.width/8
            y: Math.min(parent.height - getTempLineHeight()/2, parent.height - 40)
            text: getTempRatio().toFixed(2) + "℃/s"
            font.pixelSize: 13
            visible: control.startTemp != control.endTemp
        }
    }
    Rectangle {
        id: bottomRect
        width: parent.width
        height: 15
        anchors.bottom: parent.bottom
        color: Constants.tempfillColor
    }

    // 绘制边界
    Canvas {
        anchors.fill: parent
        visible: false
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
        target: HcPcr
        function onMaxTempChanged(maxTemp) {
           canvas.requestPaint()
           control.update()
        }
    }

    Connections {
        target: HcPcr
        function onStageTypeChanged(index, type) {
            if (control.stageIndexOfPcr === index) {
                stageType = type
            }
        }
    }

    Connections {
        target: HcPcr
        function onRunStepChanged(stageIndex, stepIndex) {
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
