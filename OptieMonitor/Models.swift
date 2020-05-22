//
//  Models.swift
//  OptieMonitor
//
//  Created by André Hartman on 13/02/18.
//  Copyright © 2018 André Hartman. All rights reserved.
//
import Foundation

var intraLines = [QuoteLine]()
var interLines = [QuoteLine]()
var quotesDatetime = Date()
var notificationSet = NotificationSetting(frequency: 0, severity: 0, sound: 0, orderID: 0)
var notificationSetOrg = NotificationSetting(frequency: 0, severity: 0, sound: 0, orderID: 0)
var incoming: RestData?

struct QuoteLine: Decodable {
    var datetime: Date
    var datetimeQuote: String
    var callValue: Double
    var putValue: Double
    var indexValue: Int
    var nrContracts: Double
    
    enum CodingKeys: String, CodingKey {
        case datetime, nrContracts
        case datetimeQuote = "datetimeSQL"
        case callValue = "callPrice"
        case putValue = "putPrice"
        case indexValue = "index1"
    }
}

struct NotificationSetting: Codable, Equatable {
    var frequency: Int
    var severity: Int
    var sound: Int
    var orderID: Int
}

struct RestData: Decodable {
    let message: String?
    let datetime: Date?
    let notificationSettings: NotificationSetting
    let intraday: [QuoteLine]?
    let interday: [QuoteLine]?
}

struct Result: Decodable {
    var status: String
}
