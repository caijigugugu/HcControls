import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import HcControls

ProgressBar{
    property int duration: 888
    //笔划宽度
    property real strokeWidth: 6
    //进度数字是否可见
    property bool progressVisible: false
    property color color: HcTheme.primaryColor
    property color backgroundColor : HcTheme.dark ? Qt.rgba(99/255,99/255,99/255,1) : Qt.rgba(214/255,214/255,214/255,1)
    id:control
    indeterminate : true
    QtObject{
        id:d
        property real _radius: strokeWidth/2
    }
    onIndeterminateChanged:{
        if(!indeterminate){
            animator_x.duration = 0
            rect_progress.x = 0
            animator_x.duration = control.duration
        }
    }
    //背景项
    background: Rectangle {
        implicitWidth: 150
        implicitHeight: control.strokeWidth
        color: control.backgroundColor
        radius: d._radius
    }
    //内容项
    contentItem: HcClip {
        clip: true
        radius: [d._radius,d._radius,d._radius,d._radius]
        Rectangle {
            id:rect_progress
            width: {
                if(control.indeterminate){
                    return 0.5 * parent.width
                }
                return control.visualPosition * parent.width
            }
            height: parent.height
            radius: d._radius
            color: control.color
            PropertyAnimation on x {
                id:animator_x
                running: control.indeterminate && control.visible
                from: -rect_progress.width
                to:control.width+rect_progress.width
                loops: Animation.Infinite
                duration: control.duration
            }
        }
    }
    HcText{
        text:(control.visualPosition * 100).toFixed(0) + "%"
        visible: {
            if(control.indeterminate){
                return false
            }
            return control.progressVisible
        }
        anchors{
            left: parent.left
            leftMargin: control.width+5
            verticalCenter: parent.verticalCenter
        }
    }
}
