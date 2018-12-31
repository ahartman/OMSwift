//
//  PriceTableViewCell.swift
//  André Hartman
//
//  Created by André Hartman on 16/10/16.
//
import UIKit
var callPricePercentage = 0.0
var putPricePercentage = 0.0
var orderValuePercentage = 0.0
var lastIndex = 0

class PriceTableViewCell: UITableViewCell {
    @IBOutlet weak var datetimeTextLabel: UILabel!
    @IBOutlet weak var callPriceTextLabel: UILabel!
    @IBOutlet weak var callDeltaTextLabel: UILabel!
    @IBOutlet weak var putPriceTextLabel: UILabel!
    @IBOutlet weak var putDeltaTextLabel: UILabel!
    @IBOutlet weak var orderValueTextLabel: UILabel!
    @IBOutlet weak var indexTextLabel: UILabel!
    
    func configure(_ lines: [QuoteLine], row: Int/*, source: String*/) {
        let line = lines[row]

        let orderValue = (line.callValue+line.putValue)*line.nrContracts
        let orderFirstValue = (lines[0].callValue+lines[0].putValue)*line.nrContracts
        
        let callDelta = line.callValue - lines[0].callValue
        let putDelta = line.putValue - lines[0].putValue
        var orderDelta = orderValue - orderFirstValue

        let previousRow = (row == 0) ? 0 : row-1
        let previousLine = lines[previousRow]
        let callChanged = line.callValue - previousLine.callValue
        let putChanged = line.putValue - previousLine.putValue
        let orderPreviousValue = (lines[previousRow].callValue+lines[previousRow].putValue)*line.nrContracts
        var orderChanged = orderValue - orderPreviousValue
        var indexDelta = line.indexValue - previousLine.indexValue
        
        if(row == lines.count - 1) {
            callPricePercentage = (line.callValue-lines[0].callValue)/lines[0].callValue
            putPricePercentage = (line.putValue-lines[0].putValue)/lines[0].putValue
            orderValuePercentage = (orderValue-orderFirstValue)/orderFirstValue
            lastIndex = line.indexValue
        }
        if(row == 0){
            orderDelta = orderValue
            orderChanged = 1
            indexDelta = line.indexValue
        }
        // datetime
        datetimeTextLabel.text = line.datetimeQuote

        // prices
        let customGreen = UIColor(red : 81.0/255.0, green : 199.0/255.0, blue : 69.0/255.0, alpha : 1)
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.locale = Locale(identifier: "nl_BE")
        numberFormatter.numberStyle = .currency
        callPriceTextLabel.text = numberFormatter.string(from: NSNumber(value: line.callValue))
        putPriceTextLabel.text = numberFormatter.string(from: NSNumber(value: line.putValue))

        // delta
        numberFormatter.positivePrefix = numberFormatter.plusSign
        callDeltaTextLabel.text = (callChanged == 0) ? " " : numberFormatter.string(from: NSNumber(value: callDelta))
        callDeltaTextLabel.textColor = (callDelta < 0) ? customGreen : UIColor.red
        putDeltaTextLabel.text = (putChanged == 0) ? " " : numberFormatter.string(from: NSNumber(value: putDelta))
        putDeltaTextLabel.textColor = (putDelta < 0) ? customGreen : UIColor.red

        // orderValue
        numberFormatter.maximumFractionDigits = 0
        orderValueTextLabel.text = (orderChanged == 0) ? " " : numberFormatter.string(from: NSNumber(value: orderDelta))
        orderValueTextLabel.textColor = (orderDelta < 0) ? customGreen : UIColor.red
        
        // index
        numberFormatter.numberStyle = .decimal
        indexTextLabel.text = (indexDelta == 0) ? " " : numberFormatter.string(from: NSNumber(value: indexDelta))
        if(row == 0){
            indexTextLabel.text = String(describing: indexTextLabel.text!.dropFirst(1))
        }
    }
}
