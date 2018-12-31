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
        //add pull down to refresh
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        // add double tap
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getJsonData(action: "currentOrder")
    }
    // table handling
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intraLines.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! PriceTableViewCell
        cell.configure(intraLines, row: indexPath.row)
        return cell
    }
    // user events handling
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getJsonData(action: "currentOrder")
        self.refreshControl?.endRefreshing()
    }
    @objc func doubleTapped() {
        getJsonData(action: "cleanOrder")
    }
    // retrieve data from server
    func getJsonData(action: String) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let url = URL(string: dataURL + action)!
        //let url = URL(string: "http://localhost:8090/polls/list")!
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
           do {
               let incoming = try decoder.decode(RestData.self, from: data!)
                //print(incoming)
                DispatchQueue.main.sync {
                    intraLines = incoming.intraday ?? intraLines
                    interLines = incoming.interday ?? interLines
                    quotesDatetime = incoming.datetime!
                    self.tableView.reloadData()
               }
                if let message = incoming.message {
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

//let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]






