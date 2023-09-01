import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import MyScreenInfo
import HeatMapData
import QtDataVisualization


ApplicationWindow {
    id: heatmap
    property int resolution: 8
    property int updateTimeMs: 200
    width: 600
    height: 600


    onResolutionChanged: {
        console.log("resolution change")
    }

    Scatter3D {
        width: parent.width
        height: parent.height
            Scatter3DSeries {
                itemLabelFormat: "Pop density at (@xLabel N, @zLabel E): @yLabel"
                ItemModelScatterDataProxy  {
                    itemModel: dataModel
                    // Mapping model roles to surface series rows, columns, and values.
                    xPosRole: "xVal"
                    yPosRole: "yVal"
                    zPosRole: "zVal"
                }
            }
        }

    ListModel {
           id: dataModel
       }

    function datalineAppend(lineData)
    {
        //console.log("dataLine append")
        HeatMapData.populate(lineData)
    }


    Component.onCompleted: {
        console.log("HEATMAP open")
        var i = 0;
        var j = 0;

        while (i < resolution)
        {
            while (j < resolution)
            {
                dataModel.append({ "xVal": i * 100, "yVal": j * 100, "zVal": 1000})
                j++;
            }
            j = 0;
            i++;

        }
        dataModel.append({ "xVal": 0 * 100, "yVal": 0 * 100, "zVal": 0})
        dataModel.append({ "xVal": 8 * 100, "yVal": 8 * 100, "zVal": 2000})


    }
    Component.onDestruction: {
        console.log("HEATMAP destroyed")

    }
    onClosing: {
        console.log("HEATMAP close")
    }
    Timer{
        id : timer
        interval: heatmap.updateTimeMs
        running: true
        repeat: true
        property int modelIndex: 20
        onTriggered: {
            console.log("heatmap update")
//            dataModel.append({ "longitude": modelIndex, "latitude": "10", "pop_density": "4.75"})
            var res = resolution*resolution;

            var i = 0;
            while (i < res)
            {
                dataModel.get(i).zVal = HeatMapData.get(i)
                i++;
            }

            modelIndex ++
        }
    }
}
