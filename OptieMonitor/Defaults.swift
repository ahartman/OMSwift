//
//  Defaults.swift
//  SwiftCharts
//
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//
import SwiftCharts

class Env {
    static var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

struct Defaults {
    static var chartSettings: ChartSettings {
        if Env.iPad {
            return self.iPadChartSettings
        } else {
            return self.iPhoneChartSettings
        }
    }
    fileprivate static var iPadChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 20
        chartSettings.top = 20
        chartSettings.trailing = 20
        chartSettings.bottom = 20
        chartSettings.labelsToAxisSpacingX = 10
        chartSettings.labelsToAxisSpacingY = 10
        chartSettings.axisTitleLabelsToLabelsSpacing = 5
        chartSettings.axisStrokeWidth = 1
        chartSettings.spacingBetweenAxesX = 15
        chartSettings.spacingBetweenAxesY = 15
        return chartSettings
    }
    
    fileprivate static var iPhoneChartSettings: ChartSettings {
        var chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8
        return chartSettings
    }
    
    static func chartFrame(_ containerBounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 10, width: containerBounds.size.width, height: containerBounds.size.height)
    }
    static var labelSettings: ChartLabelSettings {
        return ChartLabelSettings(font: Defaults.labelFont)
    }
    static var labelFont: UIFont {
        return Defaults.fontWithSize(Env.iPad ? 14 : 11)
    }
    static var labelFontSmall: UIFont {
        return Defaults.fontWithSize(Env.iPad ? 12 : 10)
    }
    static func fontWithSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static var guidelinesWidth: CGFloat {
        return Env.iPad ? 0.5 : 0.5
    }
    static var minBarSpacing: CGFloat {
        return Env.iPad ? 10 : 5
    }
    static var barWidthTotal: CGFloat {
        return Env.iPad ? 500 : 300
    }
    static var callColor: UIColor {
        return UIColor.gray.withAlphaComponent(0.6)
    }
    static var putColor: UIColor {
        return UIColor.blue.withAlphaComponent(0.6)
    }
}
