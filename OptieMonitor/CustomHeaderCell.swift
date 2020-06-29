//
//  CustomHeaderCell.swift
//  André Hartman
//
//  Created by André Hartman on 21/10/16.
//
import UIKit
class CustomHeaderCell: UITableViewCell {
    @IBOutlet weak var datetimeHeaderLabel: UILabel!
    @IBOutlet weak var callPriceHeaderLabel: UILabel!
    @IBOutlet weak var callDeltaHeaderLabel: UILabel!
    @IBOutlet weak var putPriceHeaderLabel: UILabel!
    @IBOutlet weak var putDeltaHeaderLabel: UILabel!
    @IBOutlet weak var indexHeaderLabel: UILabel!
    @IBOutlet weak var orderValueHeaderLabel: UILabel!
    @IBOutlet weak var captionHeaderLabel: UILabel!

    let writeFormatter = DateFormatter()
    
    func configure() {
        backgroundColor = mainColor
        writeFormatter.dateFormat = "HH:mm"
        datetimeHeaderLabel.text = writeFormatter.string(from: quotesDatetime)
        callPriceHeaderLabel.text = "Call"
        callDeltaHeaderLabel.text = "∂"
        putDeltaHeaderLabel.text = "∂"
        putPriceHeaderLabel.text = "Put"
        orderValueHeaderLabel.text = "€"
        indexHeaderLabel.text = "Index"
        captionHeaderLabel.text = orderCaption
    }
}
