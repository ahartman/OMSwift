//
//  OMGraphViewController.swift
//  OptieMonitor
//
//  Created by André Hartman on 5/08/17.
//  Copyright © 2017 André Hartman. All rights reserved.
//
import SwiftCharts
class OMGraphViewController: UIViewController {
    var chart: Chart?
    var graphLines = [QuoteLine]()

    override func viewWillAppear(_ animated: Bool) {
        initChart()
        super.viewWillAppear(animated)
    }
    @objc func rotated(){
        chartFrame = CGRect(x:0, y:0, width: 0, height: 0)
        initChart()
    }
    func initChart() {
        if(chartFrame.width == 0.0) {
            chartFrame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        }        
        self.chart?.clearView()
        let chart = self.doChart()
        self.view.addSubview(chart.view)
        self.chart = chart
    }
    
    func doChart() -> Chart {
        let labelSettings = ChartLabelSettings(font: Defaults.labelFont)
        let maxBars = (UIDevice.current.orientation == UIDeviceOrientation.portrait) ? 20 : 30
        let maxXValues = maxBars / 4

        var filteredGraphLines = [QuoteLine]()
        if(maxBars < graphLines.count){
            let temp = graphLines.count / maxBars
            let maxBar = graphLines.count / temp
            var j = 0
            for i in stride(from: graphLines.count - 1, to: 0, by: -1) {
                j = (j == maxBar) ? 1 : j+1
                if j < maxBar {
                    filteredGraphLines.append(graphLines[i])
                }
            }
        } else {
            filteredGraphLines = graphLines
        }
        let contractValue = filteredGraphLines[0].callValue+filteredGraphLines[0].putValue

        let models = populateModels(filteredGraphLine: filteredGraphLines)
        let lineChartPoints = filteredGraphLines.enumerated().map {
            index, tuple in ChartPoint(x: ChartAxisValueDouble(index), y: ChartAxisValueDouble(tuple.indexValue))
        }
        
        // Y bar axis max value
        let maxBarYY = max(abs(models.maxY),abs(models.minY))
        var multipleBar:Double = pow(10,floor(log(maxBarYY)/log(10)))
        multipleBar = (multipleBar == 0) ? 1.0 : multipleBar

        var maxBarYAxis = (maxBarYY / multipleBar).rounded(.awayFromZero) * multipleBar
        maxBarYAxis = (maxBarYAxis == 0) ? 1 : maxBarYAxis
        let minBarYAxis = (models.minY == 0) ? 0: -1 * maxBarYAxis
        
        // Y line axis max value
        let lineYOpen = filteredGraphLines[0].indexValue
        let maxLine = filteredGraphLines.map{$0.indexValue}.max()! - lineYOpen
        let minLine = filteredGraphLines.map{$0.indexValue}.min()! - lineYOpen
        let maxLineYY = max(abs(maxLine),abs(minLine))
        let divider = maxLineYY/5 + 1
        let maxLineYAxis = lineYOpen + divider * 5
        let minLineYAxis = lineYOpen - divider * 5
        
        // X axis values
        let xValues = [ChartAxisValueString("", order: 0, labelSettings: labelSettings)] + models.positiveBarModel.map{$0.constant} + [ChartAxisValueString("", order: filteredGraphLines.count, labelSettings: labelSettings)]
        
        // X axis label calculation
        let maxX = (filteredGraphLines.count) / maxXValues
        var j = 0
        for i in stride(from:0, to: filteredGraphLines.count, by: 1) {
            j = (j == maxX) ? 1 : j+1
            xValues[i].hidden = (j < maxX) ? true : false
        }

        // Y axis values
        let yLineValues = stride(from: minLineYAxis, through: maxLineYAxis, by: divider).map{ChartAxisValueDouble(Double($0), labelSettings: labelSettings)}
        let yBarValues =
            stride(from: minBarYAxis, through: maxBarYAxis, by: multipleBar).map{ChartAxisValueCurrency(Double($0), labelSettings: labelSettings)}
        
        // axis models
        let yLowModels: [ChartAxisModel] = [
            ChartAxisModel(axisValues: yBarValues, lineColor: UIColor.black, axisTitleLabels: [ChartAxisLabel(text: "Waarde", settings: ChartLabelSettings(font: Defaults.labelFont, fontColor: UIColor.black).defaultVertical())])]
        let yHighModels: [ChartAxisModel] = [
            ChartAxisModel(axisValues: yLineValues, lineColor: UIColor.black, axisTitleLabels: [ChartAxisLabel(text: "Index", settings: ChartLabelSettings(font: Defaults.labelFont, fontColor: UIColor.black).defaultVertical())])]
        let xLowModels: [ChartAxisModel] = [
            ChartAxisModel(axisValues: xValues, lineColor: UIColor.black, axisTitleLabels: [ChartAxisLabel(text: "Datum", settings: ChartLabelSettings(font: Defaults.labelFont, fontColor: UIColor.black))])]
        let xHighModels: [ChartAxisModel] = []
        
        // chartFrame
        //let chartFrame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        let coordsSpace = ChartCoordsSpace(chartSettings: Defaults.chartSettings, chartSize: chartFrame.size, yLowModels: yLowModels, yHighModels: yHighModels, xLowModels: xLowModels, xHighModels: xHighModels)
        let chartInnerFrame = coordsSpace.chartInnerFrame
        
        // create axes
        let yLowAxes = coordsSpace.yLowAxesLayers
        let yHighAxes = coordsSpace.yHighAxesLayers
        let xLowAxes = coordsSpace.xLowAxesLayers
        
        // create layers with references to axes
        let lineModel = ChartLineModel(chartPoints: lineChartPoints, lineColor: UIColor.red, lineWidth: 2, animDuration: 1, animDelay: 0)
        let chartLineLayer = ChartPointsLineLayer<ChartPoint>(xAxis: xLowAxes[0].axis, yAxis: yHighAxes[0].axis, lineModels: [lineModel])
        
        let barViewSettings = ChartBarViewSettings(animDuration: 0.5)
        let barWidth = chartInnerFrame.width / (CGFloat(graphLines.count) * 1.2)
        let chartPositiveStackedBarsLayer = ChartStackedBarsLayer(xAxis: xLowAxes[0].axis, yAxis: yLowAxes[0].axis, innerFrame: chartInnerFrame, barModels: models.positiveBarModel, barWidth: barWidth, settings: barViewSettings)
        let chartNegativeStackedBarsLayer = ChartStackedBarsLayer(xAxis: xLowAxes[0].axis, yAxis: yLowAxes[0].axis, innerFrame: chartInnerFrame, barModels: models.negativeBarModel, barWidth: barWidth, settings: barViewSettings)
        
        // show a gap between positive and negative bar
        let dummyZeroYChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(0))
        let yZeroGapLayer = ChartPointsViewsLayer(
            xAxis: xLowAxes[0].axis,
            yAxis: yLowAxes[0].axis,
            chartPoints: [dummyZeroYChartPoint],
            viewGenerator: {
                (chartPointModel, layer, chart) -> UIView? in
                let height: CGFloat = 2.0
                let v = UIView(
                    frame: CGRect(
                        x: 0,
                        y: chartPointModel.screenLoc.y - height / 2,
                        width: chartInnerFrame.origin.x + chartInnerFrame.size.height,
                        height: height
                    )
                )
                v.backgroundColor = UIColor.white
                return v
        })
        let dummy100YChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(contractValue))
        let y100GapLayer = ChartPointsViewsLayer(
            xAxis: xLowAxes[0].axis,
            yAxis: yLowAxes[0].axis,
            chartPoints: [dummy100YChartPoint],
            viewGenerator: {
                (chartPointModel, layer, chart) -> UIView? in
                let height: CGFloat = 1.0
                let v = UIView(
                    frame: CGRect(
                        x: 0,
                        y: chartPointModel.screenLoc.y - height / 2,
                        width: chartInnerFrame.origin.x + chartInnerFrame.size.height,
                        height: height
                    )
                )
                v.backgroundColor = UIColor.red
                return v
        })
        let dummy50YChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(contractValue/2))
        let y50GapLayer = ChartPointsViewsLayer(
            xAxis: xLowAxes[0].axis,
            yAxis: yLowAxes[0].axis,
            chartPoints: [dummy50YChartPoint],
            viewGenerator: {
                (chartPointModel, layer, chart) -> UIView? in
                let height: CGFloat = 1.0
                let v = UIView(
                    frame: CGRect(
                        x: 0,
                        y: chartPointModel.screenLoc.y - height / 2,
                        width: chartInnerFrame.origin.x + chartInnerFrame.size.height,
                        height: height
                    )
                )
                v.backgroundColor = UIColor.red
                return v
        })
        let dummy25YChartPoint = ChartPoint(x: ChartAxisValueDouble(0), y: ChartAxisValueDouble(contractValue/4))
        let y25GapLayer = ChartPointsViewsLayer(
            xAxis: xLowAxes[0].axis,
            yAxis: yLowAxes[0].axis,
            chartPoints: [dummy25YChartPoint],
            viewGenerator: {
                (chartPointModel, layer, chart) -> UIView? in
                let height: CGFloat = 1.0
                let v = UIView(
                    frame: CGRect(
                        x: 0,
                        y: chartPointModel.screenLoc.y - height / 2,
                        width: chartInnerFrame.origin.x + chartInnerFrame.size.height,
                        height: height
                    )
                )
                v.backgroundColor = UIColor.red
                return v
        })
        var layers: [ChartLayer] = []
        if(filteredGraphLines[0].datetimeQuote.range(of:":") != nil){
            layers = [xLowAxes[0], yLowAxes[0], yHighAxes[0],
                      chartPositiveStackedBarsLayer, chartNegativeStackedBarsLayer, chartLineLayer,
                      yZeroGapLayer]
        } else {
            layers = [xLowAxes[0], yLowAxes[0], yHighAxes[0],
                      chartPositiveStackedBarsLayer, chartNegativeStackedBarsLayer, chartLineLayer,
                      yZeroGapLayer,
                      y100GapLayer, y50GapLayer, y25GapLayer]
        }

        return Chart(
            frame: chartFrame,
            innerFrame: chartInnerFrame,
            settings: Defaults.chartSettings,
            layers: layers
        )
    }

    fileprivate func populateModels(filteredGraphLine: [QuoteLine]) -> (positiveBarModel: [ChartStackedBarModel], negativeBarModel: [ChartStackedBarModel], maxY: Double, minY: Double) {
        var positiveModel = [ChartStackedBarModel]()
        var negativeModel = [ChartStackedBarModel]()
        var maxYValue: Double = 0.0
        var minYValue: Double = 0.0
        let labelSettings = ChartLabelSettings(font: Defaults.labelFont)
        
        for (counter, line) in filteredGraphLine.enumerated() {
            var positiveItem = [ChartStackedBarItemModel]()
            var negativeItem = [ChartStackedBarItemModel]()
            maxYValue = max(maxYValue, line.callValue, line.putValue, line.callValue + line.putValue)
            minYValue = min(minYValue, line.callValue, line.putValue, line.callValue + line.putValue)
            
            if(line.callValue > 0) {
                positiveItem.append(ChartStackedBarItemModel(quantity: line.callValue, bgColor: Defaults.callColor))
            } else {
                negativeItem.append(ChartStackedBarItemModel(quantity: line.callValue, bgColor: Defaults.callColor))
            }
            if(line.putValue > 0){
                positiveItem.append(ChartStackedBarItemModel(quantity: line.putValue, bgColor: Defaults.putColor))
            } else {
                negativeItem.append(ChartStackedBarItemModel(quantity: line.putValue, bgColor: Defaults.putColor))
            }
            
            positiveModel.append(
                ChartStackedBarModel(constant: ChartAxisValueString(line.datetimeQuote, order: counter, labelSettings: labelSettings), start: ChartAxisValueDouble(0), items: positiveItem))
            
            negativeModel.append(
                ChartStackedBarModel(constant: ChartAxisValueString(line.datetimeQuote, order: counter, labelSettings: labelSettings), start: ChartAxisValueDouble(0), items: negativeItem))
        }
        return (positiveModel, negativeModel, maxYValue, minYValue)
    }
}

class ChartAxisValueCurrency: ChartAxisValueDouble {
    override var description: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale(identifier: "nl_BE")
        let currency = numberFormatter.string(from: NSNumber(value: scalar))
        return currency!
    }
}
