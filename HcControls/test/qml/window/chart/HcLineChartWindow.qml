import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import HcControls

HcScrollablePage{

    id: root
    property var data : []
    property var secondData : []
    HcFrame{
        Layout.preferredWidth: 700
        Layout.preferredHeight: 370
        padding: 10
        Layout.topMargin: 20
        HcChart{
            id: chart
            anchors.fill: parent
            chartType: 'line'
            //样式可参考Chart.js
            chartData: { return {
                    labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July',"August","September","October","November","December"],
                    datasets: [{
                            label: 'First Dataset',
                            data: root.data,
                            fill: false, //图表中的线条下方是否填充颜色
                            //backgroundColor: "rgba(255,192,192,0.3)", // 填充区域颜色
                            borderColor: "red",
                            borderWidth: 1,
                            tension: 0 ,// 线条的平滑度
                            pointStyle: 'triangle',
                            pointRadius:0
                        },{
                            label: 'Second Dataset',
                            data: root.secondData,
                            fill: false,
                            borderColor: "blue",
                            borderWidth: 1,
                            tension: 0.1,
                        }]
                }
            }
            chartOptions: { return {
                    maintainAspectRatio: false,
                    title: {
                        display: true,
                        text: 'Chart.js Line Chart - Stacked'
                    },
                    tooltips: {
                        mode: 'index',
                        intersect: false
                    },
                    scales: {
                        xAxes: [{
                            scaleLabel: {
                                display: true,
                                labelString: 'month'  // X轴的单位
                            }
                        }],
                        yAxes: [{
                            scaleLabel: {
                                display: false,
                                labelString: 'Value (Units)',  // Y轴的单位
                                border: 'red'
                            }
                        }],
                    }
                }
            }
        }
        Timer{
            id: timer
            interval: 500
            repeat: true
            onTriggered: {
                root.secondData.push(Math.random()*90)
                root.data.push(Math.random()*100)
                if(root.data.length>12){
                timer.stop()
                    root.data.shift()
                    root.secondData.shift()
                }
                chart.animateToNewData()
            }
        }
        Component.onCompleted: {
            timer.restart()
        }
    }
}
