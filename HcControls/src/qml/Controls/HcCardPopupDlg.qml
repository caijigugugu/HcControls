import QtQuick
import QtQuick.Controls

HcObject {
    property var root
    property int popupWidth: 300 //弹窗宽度
    property int screenWidth: 1000 //弹窗可拖拽区域宽度
    property int screenHeight: 900
    property int layoutY: 75
    property bool showIcon: true //是否展示关闭图标
    property bool isRepeat: false //相同内容是否刷新展示时间
    property int screenX: -1  // 显示区域坐标，默认 -1 表示未配置
    property int screenY: -1
    property int popupX: -1 //弹窗相对于区域坐标，默认右上角
    property int popupY: -1
    property string promptIconSource: "../Icon/prompt.svg" //提示图标
    property string closeIconSource: "../Icon/close.svg" //关闭图标
    //图标可配置颜色，默认原始颜色
    property string promptIconColor: ""
    property string closeIconColor: ""
    //提示文本
    property string titleColor: Constants.fontColor
    property int titleSize: 20
    //详细信息文本
    property int detailSize: 18
    property string detailColor: Constants.fontColor
    //提示图标大小
    property int promptIconWidth: 20
    property int promptIconHeight: 20
    //关闭图标大小
    property int closeIconWidth: 15
    property int closeIconHeight: 15
    property int radius: 4 //圆角
    property string backgroundColor: Constants.bodyBackground //背景颜色
    property string borderColor: Constants.backBorder //描边颜色
    property int borderWidth: 0 //描边宽度
    id: cardDlg

    function showInfo(prompt = "",detailText = "",timeOut = 10000){
        return _item.createDlg(prompt,detailText,timeOut)
    }

    HcObject {
        id: _item
        property var screenLayout: null

        function createDlg(prompt,detailText,timeOut) {
            if(screenLayout){
                //获取容器中最后一个对象，如果标题和内容都相同，且开启刷新，则刷新展示时间
                var last = screenLayout.getLastloader()
                if(isRepeat && last.title === prompt && detailText === last.detail && timeOut > 0){
                    last.duration = timeOut
                    if (timeOut > 0) last.restart()
                    return last
                }
            }
            initScreenLayout()
            return contentComponent.createObject(screenLayout,{title:prompt,duration:timeOut,detail:detailText})
        }
        function initScreenLayout(){
            if(screenLayout == null){
                screenLayout = screenlayoutComponent.createObject(root)
                screenLayout.y = cardDlg.layoutY
                screenLayout.z = 100000
            }
        }
        //可拖拽区域
        Component{
            id:screenlayoutComponent
            Column{
                parent: Overlay.overlay
                z:999
                spacing: 20
                width: screenWidth
                height:screenHeight
                x: cardDlg.screenX !== -1 ? cardDlg.screenX : parent.width - width// 默认右上角 x 坐标
                y: cardDlg.screenY !== -1 ? cardDlg.screenY : 0 // 右上角 y 坐标
                move: Transition {
                    NumberAnimation {
                        properties: "y"
                        easing.type: Easing.OutCubic
                        duration: 333
                    }
                }
                onChildrenChanged: if(children.length === 0)  destroy()
                function getLastloader(){
                    if(children.length > 0){
                        return children[children.length - 1]
                    }
                    return null
                }
            }
        }

        Component{
            id:contentComponent
            Item{
                id:content
                property int duration: 1000
                property string title: qsTr("提示")
                property string detail: ""
                width:  popupWidth
                height: loader.height
                x: cardDlg.popupX !== -1 ? cardDlg.popupX : parent.width - width// 右上角 x 坐标
                y: cardDlg.popupY !== -1 ? cardDlg.popupY : 0 // 右上角 y 坐标
                function close(){
                    content.destroy()
                }
                function restart(){
                    delayTimer.restart()
                }
                Timer {
                    id:delayTimer
                    interval: duration
                    running: duration > 0
                    repeat: duration > 0
                    onTriggered: content.close()
                }

                MouseArea {
                    id: _mouseArea
                    property point clickPoint: "0, 0"

                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    onPressed: clickPoint = Qt.point(mouseX, mouseY)
                    onPositionChanged: {

                        var offset = Qt.point(mouseX - clickPoint.x, mouseY - clickPoint.y)
                        var x = content.x + offset.x
                        var y = content.y + offset.y

                        if (x < 0) {
                            content.x = 0
                        } else if (x >content.parent.width - content.width) {
                            content.x = content.parent.width - content.width
                        } else {
                            content.x = x
                        }

                        if (y < 0) {
                            content.y = 0
                        } else if (y > content.parent.height - content.height) {
                            content.y = content.parent.height - content.height
                        } else {
                            content.y = y
                        }
                    }
                }
                Loader{
                    id:loader
                    x:(parent.width - width) / 2
                    property var _super: content
                    scale: item ? 1 : 0
                    asynchronous: true
                    Behavior on scale {
                        enabled: true
                        NumberAnimation {
                            easing.type: Easing.OutCubic
                            duration: 167
                        }
                    }
                    sourceComponent: _item.fluent_temp
                    Component.onDestruction: sourceComponent = undefined
                }
            }
        }
        property Component fluent_temp:  Rectangle{
            id: popup
            width:  popupWidth
            height: _col.height
            color: Constants.bodyBackground
            radius: cardDlg.radius
            Column {
                id: _col
                width: parent.width
                height: _header.height + _content.height
                anchors.top: parent.top
                Rectangle {
                    id: _header
                    width: parent.width
                    height: _title.height + 10
                    radius: cardDlg.radius
                    color: cardDlg.backgroundColor
                    Canvas {
                        id: borderCanvas
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);
                            if (cardDlg.borderWidth > 0) {
                                ctx.strokeStyle = cardDlg.borderColor;
                                ctx.lineWidth = cardDlg.borderWidth;

                                ctx.beginPath();
                                ctx.moveTo(_header.radius, 0);
                                ctx.lineTo(width - _header.radius, 0);
                                ctx.arcTo(width, 0, width, _header.radius, _header.radius);
                                ctx.lineTo(width, height);
                                ctx.moveTo(0, height);
                                ctx.lineTo(0, _header.radius);
                                ctx.arcTo(0, 0, _header.radius, 0, _header.radius);
                                ctx.stroke();
                            }
                        }
                        Component.onCompleted: borderCanvas.requestPaint()
                    }

                    ColorImage {
                        id: _promptIcon
                        source: cardDlg.promptIconSource
                        width: cardDlg.promptIconWidth
                        height: cardDlg.promptIconHeight
                        color: cardDlg.promptIconColor
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                    }

                    Label {
                        id: _title
                        width: parent.width - _promptIcon.width - 55
                        height: implicitHeight
                        anchors.left: _promptIcon.right
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        color: cardDlg.titleColor
                        font.pixelSize: cardDlg.titleSize
                        text: _super.title
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        padding: 6
                    }

                    ColorImage {
                        id: _closeIcon
                        source: cardDlg.closeIconSource
                        color: cardDlg.closeIconColor
                        width: cardDlg.closeIconWidth
                        height: cardDlg.closeIconHeight
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        fillMode: Image.PreserveAspectFit
                        visible: showIcon
                        MouseArea {
                            id: _closeArea
                            anchors.fill: parent
                            onClicked: {
                                _super.close()
                            }
                        }
                    }
                }
                Rectangle {
                    id: _content
                    width: parent.width
                    height: _detail.height
                    anchors.left: parent.left
                    radius: cardDlg.radius
                    color: cardDlg.backgroundColor
                    Canvas {
                        id: _borderCanvas
                        anchors.fill: parent
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);
                            if (cardDlg.borderWidth > 0) {
                                ctx.strokeStyle = cardDlg.borderColor;
                                ctx.lineWidth = cardDlg.borderWidth;

                                ctx.beginPath();
                                ctx.moveTo(0, 0);
                                ctx.lineTo(0, height - _content.radius);
                                ctx.arcTo(0, height, _content.radius, height, _content.radius);
                                ctx.lineTo(width - _content.radius, height);
                                ctx.arcTo(width, height, width, height - _content.radius, _content.radius);
                                ctx.lineTo(width, 0);
                                ctx.stroke();
                            }
                        }
                        Component.onCompleted: _borderCanvas.requestPaint()
                    }

                    Label {
                        id: _detail
                        width: parent.width - 60
                        height: implicitHeight
                        anchors.centerIn: parent
                        color: cardDlg.detailColor
                        font.pixelSize: cardDlg.detailSize
                        text: _super.detail
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.Wrap
                        padding: 6
                    }
                }

            }

        }

    }
}



