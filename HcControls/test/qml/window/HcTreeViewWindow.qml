import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import HcControls

HcPage {

    function treeData(){
        const names = ["test1", "test2", "test3", "test4"]
        function getRandomName(){
            var randomIndex = Math.floor(Math.random() * names.length)
            return names[randomIndex]
        }
        const addresses = ["成都","北京","三亚","巴西"]
        function getRandomAddresses(){
            var randomIndex = Math.floor(Math.random() * addresses.length)
            return addresses[randomIndex]
        }
        const avatars = ["#f091a0", "#9b8ea9","#007175","#b1d5c8","#e94829","#5a79ba"]
        function getRandomAvatar(){
            var randomIndex = Math.floor(Math.random() * avatars.length);
            return avatars[randomIndex];
        }
        const dig = (path = '0', level = 5) => {
            const list = [];
            for (let i = 0; i < 4; i += 1) {
                const key = `${path}-${i}`;
                const treeNode = {
                    title: key,
                    _key: key,
                    name: getRandomName(),
                    avatar:tree_view.customItem(com_avatar,{avatar:getRandomAvatar()}),
                    address: getRandomAddresses()
                };
                if (level > 0) {
                    treeNode.children = dig(key, level - 1);
                }
                list.push(treeNode);
            }
            return list;
        };
        return dig();
    }

    Component{
        id:com_avatar
        Item{
            HcClip{
                anchors.centerIn: parent
                width: height
                height: parent.height/3*2
                radius: [height/2,height/2,height/2,height/2]
                Rectangle {
                    anchors.fill: parent
                    color: {
                        if(options && options.avatar){
                            return options.avatar
                        }
                        return "transpreant"
                    }
                }
            }
        }
    }
    HcFrame{
        id:layout_controls
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 10
        }
        height: 90
        clip: true
        Row{
            spacing: 12
            anchors{
                left: parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
            Column{
                anchors.verticalCenter: parent.verticalCenter
                RowLayout{
                    spacing: 10
                    HcText{
                        text: qsTr("cellHeight:")
                        Layout.alignment: Qt.AlignVCenter
                    }
                    HcSlider{
                        id: slider_cell_height
                        value: 38
                        from: 38
                        to:100
                    }
                }
                RowLayout{
                    spacing: 10
                    HcText{
                        text: "depthPadding:"
                        Layout.alignment: Qt.AlignVCenter
                    }
                    HcSlider{
                        id: slider_depth_padding
                        value: 15
                        from: 15
                        to:100
                    }
                }
            }
            Column{
                spacing: 8
                anchors.verticalCenter: parent.verticalCenter
                HcToggleSwitch{
                    id: switch_showline
                    text:"showLine"
                    checked: false
                }
                HcToggleSwitch{
                    id: switch_checkable
                    text:"checkable"
                    checked: false
                }
            }
            Column{
                spacing: 8
                anchors.verticalCenter: parent.verticalCenter
                HcButton{
                    text: "all expand"
                    onClicked: {
                        tree_view.allExpand()
                    }
                }
                HcButton{
                    text: "all collapse"
                    onClicked: {
                        tree_view.allCollapse()
                    }
                }
            }
            HcButton{
                text: "print selection model"
                width: 150
                onClicked: {
                    var printData = []
                    var data = tree_view.selectionModel();
                    console.debug(data.length)
                    for(var i = 0; i <= data.length-1 ; i++){
                        const newObj = Object.assign({}, data[i].data);
                        delete newObj["__parent"];
                        delete newObj["children"];
                        printData.push(newObj)
                    }
                    console.debug(JSON.stringify(printData))
                }
            }
        }
    }

    HcTreeView{
        id:tree_view
        anchors{
            left: parent.left
            top: layout_controls.bottom
            topMargin: 10
            bottom: parent.bottom
            right: parent.right
        }
        cellHeight: slider_cell_height.value
        showLine: switch_showline.checked
        checkable:switch_checkable.checked
        depthPadding: slider_depth_padding.value
        onCurrentChanged: {
            console.log(current.data.title)
        }
        columnSource:[
            {
                title: qsTr("Title"),
                dataIndex: 'title',
                width: 300
            },{
                title: qsTr("Name"),
                dataIndex: 'name',
                width: 100
            },{
                title: qsTr("Avatar"),
                dataIndex: 'avatar',
                width: 100
            },{
                title: qsTr("Address"),
                dataIndex: 'address',
                width: 200
            },
        ]
        Component.onCompleted: {
            var data = treeData()
            dataSource = data
        }
    }
}
