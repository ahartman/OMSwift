//
//  CustomFooterCell.swift
//  André Hartman
//
//  Created by André Hartman on 13/11/16.
//
import UIKit
class CustomFooterCell: UITableViewCell {
    @IBOutlet weak var datetimeFooterLabel: UILabel!
    @IBOutlet weak var callPriceFooterLabel: UILabel!
    @IBOutlet weak var callDeltaFooterLabel: UILabel!
    @IBOutlet weak var putPriceFooterLabel: UILabel!
    @IBOutlet weak var putDeltaFooterLabel: UILabel!
    @IBOutlet weak var orderValueFooterLabel: UILabel!
    @IBOutlet weak var indexFooterLabel: UILabel!

    func configure(){
        backgroundColor = mainColor
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        percentFormatter.positivePrefix = percentFormatter.plusSign

        callPriceFooterLabel.text = percentFormatter.string(from: NSNumber(value: callPricePercentage))
        putPriceFooterLabel.text = percentFormatter.string(from: NSNumber(value: putPricePercentage))
        orderValueFooterLabel.text = percentFormatter.string(from: NSNumber(value: orderValuePercentage))

        let intFormatter = NumberFormatter()
        intFormatter.minimumFractionDigits = 0
        indexFooterLabel.text = intFormatter.string(from: NSNumber(value: lastIndex))
    }
}
