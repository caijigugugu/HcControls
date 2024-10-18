import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

import HcControls
import "./content"
Item {
    id:_hcDialogWindow
    Flickable {
        id: scrollView
        anchors.fill: parent
         ColumnLayout {
            id:container
            width: parent.width

            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 68
                padding: 10
                HcPagination {
                    id: pagination
                    Layout.fillWidth: true
                    height: 50
                    totalRecords: 250
                    defaultIndex:1
                    onRequestPage:
                        (page,count)=>{
                            console.log("onRequestPage",page,count)
                        }
                }
            }
            HcFrame {
                Layout.fillWidth: true
                Layout.preferredHeight: 68
                padding: 10
                HcSimplifiedPagination {
                    id: _pagination
                    width: 650
                    height: 50
                    totalRecords: 250
                    recordsPerPage: 15
                    onCurrentPageChanged: {
                        console.log("onRequestPage",currentPage)
                    }
                }
            }
         }
    }


}
