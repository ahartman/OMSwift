//
//  Theme.swift
//  OptieMonitor
//
//  Created by André Hartman on 24/11/15.
//  Copyright © 2015 André Hartman. All rights reserved.
//
import UIKit

func applyTheme() {
    let sharedApplication = UIApplication.shared
    sharedApplication.delegate?.window??.tintColor = mainColor
    
    styleForTabBar()
    styleForNavigationBar()
    styleForTableView()
}

func styleForTabBar() {
    UITabBar.appearance().barTintColor = barTintColor
    UITabBar.appearance().tintColor = UIColor.white
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for:.selected)
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for:UIControl.State())
}

func styleForNavigationBar() {
    //UINavigationBar.appearance().barTintColor = barTintColor
    UINavigationBar.appearance().barTintColor = mainColor
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
}

func styleForTableView() {
    UITableView.appearance().backgroundColor = backgroundColor
    UITableView.appearance().separatorStyle = .singleLine
}

func formatDate(_ date: Date) ->  String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    let dateStr = dateFormatter.string(from: date)
    return dateStr
}

var mainColor: UIColor {
    return UIColor(red: 91.0/255.0, green: 126.0/255.0, blue: 180.0/255.0, alpha: 1.0)
}
var barTintColor: UIColor {
    return UIColor(red: 83.0/255.0, green: 142.0/255.0, blue: 247.0/255.0, alpha: 1.0)
}
var barTextColor: UIColor {
    return UIColor(red: 254.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
}
var backgroundColor: UIColor {
    let lighterColor = mainColor.lighter(by: 60)
    return lighterColor!
}
var secondaryColor: UIColor {
    return UIColor(red: 251.0/255.0, green: 243.0/255.0, blue: 241.0/255.0, alpha: 1.0)
}
var textColor: UIColor {
    return UIColor(red: 63.0/255.0, green: 62.0/255.0, blue: 61.0/255.0, alpha: 1.0)
}
var headingTextColor: UIColor {
    return UIColor(red: 44.0/255.0, green: 45.0/255.0, blue: 40.0/255.0, alpha: 1.0)
}
var subtitleTextColor: UIColor {
    return UIColor(red: 156.0/255.0, green: 155.0/255.0, blue: 150.0/255.0, alpha: 1.0)
}
var standardTextFont: UIFont {
    return UIFont(name: "HelveticaNeue-Medium", size: 14)!
}
var subtitleFont: UIFont {
    return UIFont(name: "HelveticaNeue-Light", size: 14)!
}
var headlineFont: UIFont {
    return UIFont(name: "HelveticaNeue-Bold", size: 14)!
}

extension UIColor {
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        } else {
            return nil
        }
    }
}


