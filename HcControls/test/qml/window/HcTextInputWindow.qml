import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls
Item {
    id:_hcWindow
    Flickable {
        id: scrollView
        anchors.fill: parent
        ScrollBar.vertical:scroll_bar
        height: parent.height
        contentHeight: container.height
         ColumnLayout {
            id:container
            width: parent.width
            spacing: 50
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 68
                padding: 10
                HcToggleSwitch {
                    id: _toggleButton
                    text: qsTr("禁用")
                    onCheckedChanged: {
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 68
                padding: 10
                Row{
                    spacing: 10
                    HcTextInput {
                        id: _text
                        label: qsTr("输入框：")
                        maxLen: 100
                        hasLabel: true
                        _spacing:0
                        enabled: !_toggleButton.checked
                        //content: "111111"
                        //regexp: "^[\\\\\[\\]\\-,.;'/~!@#$%^&*()_+{}|:\"<>?`=A-Za-z0-9\u4e00-\u9fa5]{0,100}$"
                    }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                HcTextBox{
                    placeholderText: qsTr("一级输入框")
                    cleanEnabled: true
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }
                    disabled: _toggleButton.checked
                    validator: RegularExpressionValidator { regularExpression: RegExp("^[A-Za-z0-9@_]+$") }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                Row{
                    spacing: 30
                    HcTextBox{
                        level: 2
                        placeholderText: qsTr("二级输入框")
                        cleanEnabled: true
                        anchors{
                            verticalCenter: parent.verticalCenter
                        }
                        disabled: _toggleButton.checked
                    }
                    HcTextBox{
                        level: 3
                        placeholderText: qsTr("三级输入框")
                        cleanEnabled: true
                        anchors{
                            verticalCenter: parent.verticalCenter
                        }
                        disabled: _toggleButton.checked
                    }
                }
            }

            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                HcPasswordBox {
                    placeholderText: qsTr("Please enter your password")
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }
                    disabled: _toggleButton.checked
                }
            }

            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                HcMultilineTextBox{
                    id: multiine_textbox
                    placeholderText: qsTr("Multi-line Input Box")
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }
                    disabled: _toggleButton.checked
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                padding: 10
                HcAutoSuggestBox{
                    placeholderText: qsTr("AutoSuggestBox")
                    items: generateRandomNames(100)
                    anchors{
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }
                    disabled: _toggleButton.checked
                }
            }
         }
         // ScrollBar.vertical: ScrollBar {
         //     policy:ScrollBar.AlwaysOn
         // }
    }
    ScrollBar {
        id: scroll_bar
        anchors{
            top: scrollView.top
            right: parent.right
            bottom: scrollView.bottom
        }
        policy: scrollView.contentHeight
                                > scrollView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
        z:999
    }
    function generateRandomNames(numNames) {
        const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        const names = [];
        function generateRandomName() {
            const nameLength = Math.floor(Math.random() * 5) + 4;
            let name = '';
            for (let i = 0; i < nameLength; i++) {
                const letterIndex = Math.floor(Math.random() * 26);
                name += alphabet.charAt(letterIndex);
            }
            return name;
        }
        for (let i = 0; i < numNames; i++) {
            const name = generateRandomName();
            names.push({title:name});
        }
        return names;
    }

}
