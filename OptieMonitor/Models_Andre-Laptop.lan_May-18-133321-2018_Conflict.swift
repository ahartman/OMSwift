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

struct RestData: Decodable {
    let message: String?
    let datetime: Date?
    let intraday: [QuoteLine]?
    let interday: [QuoteLine]?
}

struct Result: Decodable {
    var status: String
}
struct Polls: Decodable {
    var id: String
    var title: String
    var option1: String
    var option2: String
    var votes1: Int
    var votes2: Int
}
 struct Project2: Decodable {
    let result: Result
    let polls: [Polls]
}
