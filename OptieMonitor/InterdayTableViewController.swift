//
//  InterdayTableViewController.swift
//  OptieMonitor
//
//  Created by André Hartman on 19/11/15.
//  Copyright © 2016 André Hartman. All rights reserved.
//
import UIKit
class InterdayTableViewController: OMTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interLines.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! PriceTableViewCell
        cell.configure(interLines, row: indexPath.row)
        return cell
    }
}
