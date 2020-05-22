//
//  NotificationManagerViewController.swift
//  OptieMonitor
//
//  Created by André Hartman on 6/07/18.
//  Copyright © 2018 André Hartman. All rights reserved.
//
import UIKit
class NotificationManagerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    @IBOutlet weak var severityPicker: UIPickerView!
    @IBOutlet weak var frequencyPicker: UIPickerView!
    @IBOutlet weak var soundSwitch: UISwitch!
    
    var severityData = ["Alle mutaties","Onveranderd en negatief","Laatste mutatie negatief","Vandaag negatief","Order negatief","Geen meldingen"]
    var frequencyData = ["Elk kwartier","Elk half uur","Elk uur","Geen"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.severityPicker.delegate = self
        self.severityPicker.dataSource = self
        self.frequencyPicker.delegate = self
        self.frequencyPicker.dataSource = self
        self.soundSwitch.addTarget(self, action: #selector(action(sender:)), for: .valueChanged)

        severityPicker.selectRow(notificationSet.severity, inComponent: 0, animated: false)
        frequencyPicker.selectRow(notificationSet.frequency, inComponent: 0, animated: false)
        soundSwitch.isOn = (notificationSet.sound as NSNumber).boolValue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(notificationSet != notificationSetOrg) {
           postJSONData(action: "notificationSettings") { (error) in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
            }
        }
        notificationSetOrg = notificationSet
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let temp = (pickerView == severityPicker) ? severityData.count : frequencyData.count
        return temp
    }
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let temp = (pickerView == severityPicker) ? severityData[row] : frequencyData[row]
        return temp
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == severityPicker {
            notificationSet.severity = row
        } else {
            notificationSet.frequency = row
        }
    }
     @objc func action(sender: UISwitch) {
        notificationSet.sound = soundSwitch.isOn ? 1 : 0
    }
    func postJSONData(action: String, completion:((Error?) -> Void)?) {
        let encoder = JSONEncoder()
        let url = URL(string: dataURL + action)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers

        do {
            request.httpBody = try encoder.encode(notificationSet)
            print("Sent jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }

        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
            // APIs usually respond with the data you just sent in your POST request
            if responseData != nil {
                print("Instellingen gewijzigd")
            } else {
                print("No readable data received in response")
            }
        }
        task.resume()
    }
}
