import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import HcControls

Rectangle{
    property string title: ""
    property string darkText : qsTr("Dark11")
    property string lightText : qsTr("Light")
    property string minimizeText : qsTr("Minimize")
    property string restoreText : qsTr("Restore")
    property string maximizeText : qsTr("Maximize")
    property string closeText : qsTr("Close")
    property string stayTopText : qsTr("Sticky on Top")
    property string stayTopCancelText : qsTr("Sticky on Top cancelled")
    property color textColor: HcTheme.fontPrimaryColor

    property bool showDark: false
    property bool showClose: true
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showStayTop: true
    property bool titleVisible: true
    property url icon
    property int iconSize: 20
    property bool isMac: HcTools.isMacos()
    property color borerlessColor : HcTheme.primaryColor
    property alias buttonStayTop: btn_stay_top
    property alias buttonMinimize: btn_minimize
    property alias buttonMaximize: btn_maximize
    property alias buttonClose: btn_close
    property alias buttonDark: btn_dark
    property alias layoutMacosButtons: layout_macos_buttons
    property alias layoutStandardbuttons: layout_standard_buttons
    property var maxClickListener : function(){
        if(HcTools.isMacos()){
            if (d.win.visibility === Window.FullScreen || d.win.visibility === Window.Maximized)
                d.win.showNormal()
            else
                d.win.showFullScreen()
        }else{
            if (d.win.visibility === Window.Maximized || d.win.visibility === Window.FullScreen)
                d.win.showNormal()
            else
                d.win.showMaximized()
            d.hoverMaxBtn = false
        }
    }
    property var minClickListener: function(){
        if(d.win.transientParent != null){
            d.win.transientParent.showMinimized()
        }else{
            d.win.showMinimized()
        }
    }
    property var closeClickListener : function(){
        d.win.close()
    }
    property var stayTopClickListener: function(){
        if(d.win instanceof HcWindow){
            d.win.stayTop = !d.win.stayTop
        }
    }
    property var darkClickListener: function(){
        if(HcTheme.dark){
            HcTheme.darkMode = HcThemeType.Light
        }else{
            HcTheme.darkMode = HcThemeType.Dark
        }
    }
    id:control
    color: Qt.rgba(0,0,0,0)
    height: visible ? 30 : 0
    opacity: visible
    z: 65535
    Item{
        id:d
        property var hitTestList: []
        property bool hoverMaxBtn: false
        property var win: Window.window
        property bool stayTop: {
            if(d.win instanceof HcWindow){
                return d.win.stayTop
            }
            return false
        }
        property bool isRestore: win && (Window.Maximized === win.visibility || Window.FullScreen === win.visibility)
        property bool resizable: win && !(win.height === win.maximumHeight && win.height === win.minimumHeight && win.width === win.maximumWidth && win.width === win.minimumWidth)
        function containsPointToItem(point,item){
            var pos = item.mapToGlobal(0,0)
            var rect = Qt.rect(pos.x,pos.y,item.width,item.height)
            if(point.x>rect.x && point.x<(rect.x+rect.width) && point.y>rect.y && point.y<(rect.y+rect.height)){
                return true
            }
            return false
        }
    }
    Row{
        anchors{
            verticalCenter: parent.verticalCenter
            left: isMac ? undefined : parent.left
            leftMargin: isMac ? undefined : 10
            horizontalCenter: isMac ? parent.horizontalCenter : undefined
        }
        spacing: 10
        Image{
            width: control.iconSize
            height: control.iconSize
            visible: status === Image.Ready ? true : false
            source: control.icon
            anchors.verticalCenter: parent.verticalCenter
        }
        HcText {
            text: title
            visible: control.titleVisible
            color:control.textColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    Component{
        id:com_macos_buttons
        RowLayout{
            HcImageButton{
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Icon/btn_close_normal.png"
                hoveredImage: "../Icon/btn_close_hovered.png"
                pushedImage: "../Icon/btn_close_pushed.png"
                visible: showClose
                onClicked: closeClickListener()
            }
            HcImageButton{
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Icon/btn_min_normal.png"
                hoveredImage: "../Icon/btn_min_hovered.png"
                pushedImage: "../Icon/btn_min_pushed.png"
                onClicked: minClickListener()
                visible: showMinimize
            }
            HcImageButton{
                Layout.preferredHeight: 12
                Layout.preferredWidth: 12
                normalImage: "../Icon/btn_max_normal.png"
                hoveredImage: "../Icon/btn_max_hovered.png"
                pushedImage: "../Icon/btn_max_pushed.png"
                onClicked: maxClickListener()
                visible: d.resizable && showMaximize
            }
        }
    }
    RowLayout{
        id:layout_standard_buttons
        height: parent.height
        anchors.right: parent.right
        spacing: 0
        HcIconButton{
            id:btn_dark
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            rightPadding: 2
            iconSource: HcTheme.dark ? HcIcons.Brightness : HcIcons.QuietHours
            Layout.alignment: Qt.AlignVCenter
            iconSize: 15
            visible: showDark
            text: HcTheme.dark ? control.lightText : control.darkText
            _radius: 0
            borderWidth: 0
            iconColor:control.textColor
            onClicked:()=> darkClickListener(btn_dark)
        }
        HcIconButton{
            id:btn_stay_top
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            iconSource : HcIcons.Pinned
            Layout.alignment: Qt.AlignVCenter
            iconSize: 14
            visible: {
                if(!(d.win instanceof HcWindow)){
                    return false
                }
                return showStayTop
            }
            text:d.stayTop ? control.stayTopCancelText : control.stayTopText
            _radius: 0
            borderWidth: 0
            iconColor: d.stayTop ? HcTheme.primaryColor : control.textColor
            onClicked: stayTopClickListener()
        }
        HcIconButton{
            id:btn_minimize
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            iconSource : HcIcons.ChromeMinimize
            Layout.alignment: Qt.AlignVCenter
            iconSize: 11
            text:minimizeText
            _radius: 0
            borderWidth: 0
            visible: !isMac && showMinimize
            iconColor: control.textColor
            buttonColor:Gradient {
                GradientStop {
                    color: "transparent"
                }
            }
            onClicked: minClickListener()
        }
        HcIconButton{
            id:btn_maximize
            property bool hover: btn_maximize.hovered
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            iconSource : d.isRestore  ? HcIcons.ChromeRestore : HcIcons.ChromeMaximize
            buttonColor:Gradient {
                GradientStop {
                    color: "transparent"
                }
            }
            Layout.alignment: Qt.AlignVCenter
            visible: d.resizable && !isMac && showMaximize
            _radius: 0
            borderWidth: 0
            iconColor: control.textColor
            text:d.isRestore?restoreText:maximizeText
            iconSize: 11
            font.pixelSize: 11
            onClicked: maxClickListener()
        }
        HcIconButton{
            id:btn_close
            Layout.preferredWidth: 40
            Layout.preferredHeight: 30
            padding: 0
            verticalPadding: 0
            horizontalPadding: 0
            iconSource : HcIcons.ChromeClose
            Layout.alignment: Qt.AlignVCenter
            text:closeText
            visible: !isMac && showClose
            _radius: 0
            borderWidth: 0
            iconSize: 10
            iconColor: hovered ? Qt.rgba(1,1,1,1) : control.textColor
            buttonColor:Gradient {
                GradientStop {
                    color: "transparent"
                }
            }
            onClicked: closeClickListener()
        }
    }
    HcLoader{
        id:layout_macos_buttons
        anchors{
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 10
        }
        sourceComponent: isMac ? com_macos_buttons : undefined
    }
}
