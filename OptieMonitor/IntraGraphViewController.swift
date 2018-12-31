//
//  IntraGraphViewController.swift
//  OptieMonitor
//
//  Created by André Hartman on 12/12/16.
//  Copyright © 2016 André Hartman. All rights reserved.
//
import UIKit
class IntraGraphViewController: OMGraphViewController {
    override func viewWillAppear(_ animated: Bool) {
        if(!intraLines.isEmpty) {
            graphLines = intraGraph()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        super.viewWillAppear(animated)
    }
    func intraGraph() -> [QuoteLine]{
        var intraGraphLines = [QuoteLine]()
        for line in intraLines {
            intraGraphLines.append(QuoteLine(
                datetime: line.datetime,
                datetimeQuote: line.datetimeQuote,
                callValue: (line.callValue - intraLines[0].callValue) * line.nrContracts,
                putValue: (line.putValue - intraLines[0].putValue) * line.nrContracts,
                indexValue: line.indexValue,
                nrContracts: line.nrContracts))
        }
        return intraGraphLines
    }
}
