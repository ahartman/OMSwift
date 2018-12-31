//
//  InterGraphViewController.swift
//  OptieMonitor
//
//  Created by André Hartman on 12/12/16.
//  Copyright © 2016 André Hartman. All rights reserved.
//
import UIKit
class InterGraphViewController: OMGraphViewController {
    override func viewWillAppear(_ animated: Bool) {
        if(!interLines.isEmpty){
            graphLines = interGraph()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        super.viewWillAppear(animated)
    }
    func interGraph() -> [QuoteLine]{
        var interGraphLines = [QuoteLine]()
        for line in interLines {
            interGraphLines.append(QuoteLine(
                datetime: line.datetime,
                datetimeQuote: line.datetimeQuote,
                callValue: line.callValue * line.nrContracts,
                putValue: line.putValue * line.nrContracts,
                indexValue: line.indexValue,
                nrContracts: line.nrContracts))
        }
        return interGraphLines
    }
}
