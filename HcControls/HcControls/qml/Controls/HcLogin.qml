import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import HcControls

Rectangle {
    //区分正常结构和左右结构
    property bool isNormalMode: false
    //系统名称
    property string systemName: qsTr("系统名称XXXXXX")
    //版本号
    property string versionNumber: qsTr("版本号1.0")
    //右边用户登录矩形框窗口弧度
    property int loginRadius: 5
    //左边信息矩形框窗口弧度
    property int logoRadius: 10
    //Hcsci Logo
    property string hcsciLogo: TranslateHelper.current === "zh_CN" ? "../Icon/logo1.png" : "../Icon/en-logo-login.png"

    //甲方logo
    property string logoImage: ""

    //背景图片
    property string backgroundImage: ""

    id: _login
    implicitWidth: parent.width
    implicitHeight: parent.height
    //背景色
    gradient: HcTheme.dark ?  Constants.dialogHeadDeepGradient : Constants.dialogHeadGradient

    function login() {
        if (_user.content.length === 0 || _password.content.length === 0) {
            return
        }

        var param = {
            "user": _user.content,
            "password": _password.content,
        }
        console.log("user:",JSON.stringify(param))
    }
    //界面背景
    Image {
        id: _image
        source: backgroundImage
        fillMode: Image.Pad
        anchors.fill: parent
    }
    //左上角logo,正常结构为瀚辰logo，否则左右结构为甲方Logo
    Image {
        id: _topLeftLogo
        source: _login.isNormalMode ? hcsciLogo : logoImage
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
    }

    Row {
        anchors.centerIn: parent
        //anchors.verticalCenterOffset: 50

        // 左右结构——左边信息矩形框
        Rectangle {
            id: _logoRec
            width: 540
            height: 440
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0
                    color: "#00959f"
                }
                GradientStop {
                    position: 1
                    color: "#00a3ae"
                }
            }
            visible: !_login.isNormalMode
            anchors.verticalCenter: parent.verticalCenter
            radius: logoRadius

            Label {
                id: _systemName
                width: parent.width - 60
                text: systemName
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 40
                color: "#ffffff"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 30
                font.bold: true
                wrapMode: Text.WordWrap
                clip: true
            }

            Label {
                id: _version
                width: parent.width - 60
                text: versionNumber
                anchors.right: _systemName.right
                anchors.top:_systemName.bottom
                anchors.topMargin: 22
                color: "#ffffff"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 30
                font.bold: true
                wrapMode: Text.WordWrap
                clip: true
            }


            Image {
                id: _logoImage
                source: hcsciLogo
                fillMode: Image.Pad
                anchors.left: parent.left
                anchors.leftMargin: 22
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 36
            }

        }

        // 左右结构——右边用户登录矩形框
        HcRoundedRectangle {
            id: _loginRect
            width: 500
            height: _login.isNormalMode ? 440 :306
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0
                    color: Qt.rgba(255/255, 255/255, 255/255, 0.4)
                }
                GradientStop {
                    position: 1
                    color: "#60ecff"
                }
            }
            radius: _login.isNormalMode ? [loginRadius,loginRadius,loginRadius,loginRadius] : [0,loginRadius,loginRadius,0]
            anchors.verticalCenter: parent.verticalCenter
            component LoginInput: Rectangle {
                property string tips: ""
                property string path: ""
                property string content: _text.text
                property int echo: TextInput.Normal
                property string regexp: ".*"
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter

                HcTextBox {
                    id: _text
                    width: parent.width
                    height: parent.height
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 50
                    placeholderText: tips
                    font.pixelSize: 14
                    color: "#333333"
                    echoMode: parent.echo
                    validator: RegularExpressionValidator { regularExpression: RegExp(regexp) }
                }

                ColorImage {
                    source: path
                    fillMode: Image.Pad
                    anchors.left: parent.left
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            HcText {
                id: _projectName
                text: systemName
                color: "#ffffff"
                font.pixelSize: 50
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 40
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: _login.isNormalMode
            }

            LoginInput {
                id: _user
                width: 400
                height: 50
                anchors.top: _login.isNormalMode ? _projectName.bottom : parent.top
                anchors.topMargin: 50
                tips: qsTr("请输入用户名")
                path: "../Icon/用户.svg"
                regexp: "^[A-Za-z0-9\u4e00-\u9fa5]{1,16}$"
            }

            LoginInput {
                id:_password
                width: 400
                height: 50
                anchors.top: _user.bottom
                anchors.topMargin: 20
                tips: qsTr("请输入密码")
                path: "../Icon/密码.svg"
                echo: TextInput.Password
                regexp: "^[\\\\\[\\]\\-,.;'/~!@#$%^&*()_+{}|:\"<>?`=A-Za-z0-9\u4e00-\u9fa5]{1,16}$"

                Keys.onEnterPressed: {
                    login()
                }

                Keys.onReturnPressed: {
                    login()
                }
            }

            HcButton {
                id: _btn

                width:  400
                height: 50
                text: qsTr("登录")
                font.pixelSize: 24
                highlighted: true
                // anchors.left: parent.left
                // anchors.leftMargin: 55
                anchors.top: _password.bottom
                anchors.topMargin: 45
                anchors.horizontalCenter: parent.horizontalCenter
                fontColor: Constants.fontWhiteColor
                buttonColor: _gradient
                Gradient {
                    id: _gradient

                    GradientStop {
                        position: 0
                        color: "#61ced5"
                    }

                    GradientStop {
                        position: 1
                        color: "#61ced5"
                    }

                    orientation: Gradient.Vertical
                }

                onClicked: {
                    login()
                }

                Component.onCompleted: {
                }
            }

            HcText {
                width: contentWidth
                height: contentHeight
                text: qsTr("忘记密码?")
                font.pixelSize: 18
                anchors.left: _btn.left
                anchors.top: _btn.bottom
                anchors.topMargin: 20
                visible: false

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                    }
                }
            }

            HcText {
                width: contentWidth
                height: contentHeight
                text: qsTr("切换语言")
                font.pixelSize: 18
                anchors.right: _btn.right
                anchors.top: _btn.bottom
                anchors.topMargin: 20
                visible: false

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                    }
                }
            }
        }
    }

}
