//
//  IntradayTableViewController.swift
//  OptieMonitor
//
//  Created by André Hartman on 19/11/15.
//  Copyright © 2016 André Hartman. All rights reserved.
//
import UIKit

class IntraTableViewController: OMTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // enter foreground
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
       //add pull down to refresh
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        // add double tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
        getJsonData(action: "currentOrder")

    }

    @objc func willEnterForeground() {
        getJsonData(action: "currentOrder")
    }
    
    // MARK: table handling
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intraLines.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! PriceTableViewCell
        cell.configure(intraLines, row: indexPath.row)
        return cell
    }
    
    // MARK: user events handling
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getJsonData(action: "currentOrder")
        self.refreshControl?.endRefreshing()
    }
    @objc func doubleTapped() {
        getJsonData(action: "cleanOrder")
    }

    func getJsonData(action: String) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let url = URL(string: dataURL + action)!
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
           do {
                //let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                //print(json)
                let incomingData = try decoder.decode(RestData.self, from: data!)
            incoming = incomingData
            //print("incoming: \(action)")
            //print(incoming)
            DispatchQueue.main.sync {
                    intraLines = incomingData.intraday ?? intraLines
                    interLines = incomingData.interday ?? interLines
                    quotesDatetime = incomingData.datetime!
                    notificationSet = incomingData.notificationSettings
                    notificationSetOrg = incomingData.notificationSettings
                    self.tableView.reloadData()
                    //print("reloadData")
               }
                if let message = incomingData.message {
                    self.showAlert(messageText: message)
                }
            } catch {
                print("error trying to convert data to JSON")
                print(error)
            }
            }
            .resume()
    }

    func showAlert(messageText: String) {
        let alert = UIAlertController(title: "AEX", message: messageText, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 2 //seconds
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
}





