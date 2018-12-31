//
//  OMTableViewController.swift
//  OptieMonitor
//
//  Created by André Hartman on 5/08/17.
//  Copyright © 2017 André Hartman. All rights reserved.
//
import UIKit
class OMTableViewController: UITableViewController {
    override func tableView(_ tableView: UITableView,viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! CustomHeaderCell
        headerCell.configure()
        return headerCell }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "FooterCell") as! CustomFooterCell
        footerCell.configure()
        return footerCell }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30.0 }
    override func tableView (_ tableView:UITableView, heightForHeaderInSection section:Int) -> CGFloat {
        return 50.0 }
}
