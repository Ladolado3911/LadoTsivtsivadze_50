//
//  ViewController.swift
//  LadoTsivtsivadze_50
//
//  Created by Ladolado3911 on 09.07.21.
//

import UIKit

enum AmOrPm: String {
    case am = "am"
    case pm = "pm"
}

struct Time {
    var hour: Int
    var minute: Int
    var amORpm: AmOrPm
}

class ViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var clockView: UIView!
    
    var hours: [Int] = []
    var minutes: [Int] = []
    var amORpm: [String] = ["am", "pm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configPickerView()
        populateClockInfo()

    }
    
    func configPickerView() {
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func populateClockInfo() {
        for a in 1...60 {
            if a < 25 {
                hours.append(a)
            }
            minutes.append(a)
        }
        pickerView.reloadAllComponents()
    }
    
    func getPickerTime() -> Time {
        let hour = pickerView.selectedRow(inComponent: 0) + 1
        let minute = pickerView.selectedRow(inComponent: 1) + 1
        let amORpm2: AmOrPm = amORpm[pickerView.selectedRow(inComponent: 2)] == "am" ? .am : .pm
        
        return Time(hour: hour, minute: minute, amORpm: amORpm2)
    }
    
    @IBAction func onSetTime(_ sender: Any) {
        let selectedTime = getPickerTime()
        print("\(selectedTime.hour): \(selectedTime.minute): \(selectedTime.amORpm.rawValue)")
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return minutes.count
        case 2:
            return amORpm.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(hours[row])
        case 1:
            return String(minutes[row])
        case 2:
            return amORpm[row]
        default:
            return "None"
        }
    }
}

