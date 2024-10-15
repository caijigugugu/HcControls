import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls
import "./content"

Item {
    id:_tableWindow
    property bool selectedAll: false
    signal checkBoxChanged
    Flickable {
        id: scrollView
        anchors.fill: parent
        HcTableView {
            id: _tableView
            anchors{
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: pagination.top
            }
            //verticalHeaderVisible: false
            borderWidth: 1
            columnSource:[
                {   //表头控件和文本
                    title: _tableView.customItem(com_column_checbox,{title:qsTr("")}),
                    dataIndex: 'checkbox',
                    width:70,
                    frozen: true
                },
                {
                    title: _tableView.customItem(com_column_filter_name,{title:qsTr("Name")}),
                    dataIndex: 'name',
                    readOnly:true
                },
                {
                    title: qsTr("Sex"),
                    dataIndex: 'sex',
                    minimumWidth:100,
                    maximumWidth:150,
                    frozen: true
                },
                {
                    title: _tableView.customItem(com_column_sort_age,{sort:0}),
                    dataIndex: 'age',
                    //当前列表格控件
                    editDelegate:com_combobox,
                    minimumWidth:100,
                    maximumWidth:350,
                    //表头是否可变化宽度
                    positionChange: true
                },
                {
                    title: qsTr("Address"),
                    dataIndex: 'address',
                    width:200,
                    minimumWidth:100,
                    maximumWidth:250
                },
                {
                    title: qsTr("A"),
                    dataIndex: 'a',
                    width:200,
                    minimumWidth:100,
                    maximumWidth:250
                },
                {
                    title: qsTr("B"),
                    dataIndex: 'b',
                    width:200,
                    minimumWidth:100,
                    maximumWidth:250
                },
                {
                    title: qsTr("操作"),
                    dataIndex: 'action',
                    width:150,
                    frozen: true
                }
            ]
        }
        HcPagination {
            id: pagination
            Layout.fillWidth: true
            height: 50
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 50
            totalRecords: _tableView.rows
            recordsPerPage:10
            onRequestPage: (page,count)=>{
            console.log("onRequestPage",page,count,currentPage)
                loadData(page,81)
            }
        }


        ScrollBar.vertical: ScrollBar {
             policy: scrollView.contentHeight
                     > scrollView.height ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
         }

    }
    //名称表头
    Component{
        id:com_column_filter_name
        Item{
            Text{
                text: qsTr("Name")
                anchors.centerIn: parent
            }
            HcIconButton {
                width: 35
                height: 20
                _imageWidth: 20
                verticalPadding:0
                horizontalPadding:0
                _src: ""
                anchors{
                    right: parent.right
                    rightMargin: 3
                    verticalCenter: parent.verticalCenter
                }

            }
        }
    }

    //年龄表头控件
    Component{
        id:com_column_sort_age
        Item{
            Text{
                text: qsTr("Age")
                anchors.centerIn: parent
            }
        }
    }
    //全选表头控件
    Component{
        id:com_column_checbox
        Item{
            RowLayout{
                anchors.centerIn: parent
                Text{
                    text: qsTr("全选")
                    Layout.alignment: Qt.AlignVCenter
                }
                CheckBox{
                    checked: true === _tableWindow.selectedAll
                    Layout.alignment: Qt.AlignVCenter
                }

            }
            MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        _tableWindow.selectedAll = !_tableWindow.selectedAll
                        var checked = _tableWindow.selectedAll
                        var columnModel = model.display
                        columnModel.title = _tableView.customItem(com_column_checbox,{"checked":checked})
                        model.display = columnModel
                        for(var i =0;i< _tableView.rows ;i++){
                            var rowData = _tableView.getRow(i);
                            rowData.checkbox = _tableView.customItem(com_checbox,{"checked":checked})
                            _tableView.setRow(i,rowData)
                        }
                    }
                }
        }
    }
    //表格check组件
    Component{
        id:com_checbox
        Item{
            CheckBox{
                anchors.centerIn: parent
                checked: true === options.checked
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var obj = _tableView.getRow(row)
                        obj.checkbox = _tableView.customItem(com_checbox,{checked:!options.checked})
                        _tableView.setRow(row,obj)
                        checkBoxChanged()
                    }
                }
            }
        }
    }
    //年龄表格下拉菜单
    Component{
        id:com_combobox
        HcComboBox {
            anchors.fill: parent
            //focus: true
            editText: display
            editable: true
            model: ListModel {
                ListElement { text: "100" }
                ListElement { text: "300" }
                ListElement { text: "500" }
                ListElement { text: "1000" }
            }
            Component.onCompleted: {
                currentIndex=["100","300","500","1000"].findIndex((element) => element === display)
                textBox.forceActiveFocus()
                textBox.selectAll()
            }
            onCommit: {
                editTextChaged(editText)
                _tableView.closeEditor()
            }
        }
    }

    //操作表格控件
    Component{
        id:com_action
        Item{
            RowLayout{
                anchors.centerIn: parent
                spacing: 10
                HcButton {
                    id: _stopBtn1
                    width: 60
                    height: 30
                    text: "删除"
                    font.pixelSize: 16
                    onClicked: {
                    }
                }
                HcButton {
                    id: _stopBtn2
                    width: 60
                    height: 30
                    text: "编辑"
                    font.pixelSize: 16
                    onClicked: {
                        var obj = _tableView.getRow(row)
                        obj.name = "12345"
                        _tableView.setRow(row,obj)
                    }
                }
            }
        }
    }

    function generateUuid() {
        var d = new Date().getTime();
        if (typeof performance !== 'undefined' && typeof performance.now === 'function') {
            d += performance.now();
        }
        var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = (d + Math.random() * 16) % 16 | 0;
            d = Math.floor(d / 16);
            return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        });
        return uuid;
    }

    function genTestObject(){
        var ages = ["100", "300", "500", "1000"];
        function getRandomAge() {
            var randomIndex = Math.floor(Math.random() * ages.length);
            return ages[randomIndex];
        }
        var sex = ["男", "女", "非二元性别", "生理性别与心理性别不一致"];
        function getRandomSex() {
            var randomIndex = Math.floor(Math.random() * sex.length);
            return sex[randomIndex];
        }
        var names = ["哇哇哇", "呜呜呜", "嘻嘻嘻", "呃呃呃","哈哈哈","哦哦哦","好好好"];
        function getRandomName(){
            var randomIndex = Math.floor(Math.random() * names.length);
            return names[randomIndex];
        }
        var addresses = ["深圳桥洞","北京地下室","深山石洞","工地宿舍","城中村"]
        function getRandomAddresses(){
            var randomIndex = Math.floor(Math.random() * addresses.length);
            return addresses[randomIndex];
        }
        return {
            checkbox:_tableView.customItem(com_checbox,{checked:_tableWindow.selectedAll}),
            name: getRandomName(),
            age:getRandomAge(),
            sex:getRandomSex(),
            address: getRandomAddresses(),
            a:"A",
            b:"B",
            action:_tableView.customItem(com_action),
            height:70,
            _minimumHeight:50,
            _maximumHeight:100,
            _positionChange: false,
            _key:  generateUuid()
        }
    }

    function loadData(page,count){
        const dataSource = []
        for(var i=0;i<count;i++){
            dataSource.push(genTestObject())
        }
        _tableView.dataSource = dataSource
    }
    onCheckBoxChanged: {
        for(var i =0;i< _tableView.rows ;i++){
            if(false === _tableView.getRow(i).checkbox.options.checked){
                selectedAll = false
                return
            }
        }
        selectedAll = true
    }

    Component.onCompleted: {
        loadData(1,81)
    }
}
