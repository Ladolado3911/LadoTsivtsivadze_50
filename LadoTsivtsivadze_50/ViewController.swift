//
//  ViewController.swift
//  LadoTsivtsivadze_50
//
//  Created by Ladolado3911 on 09.07.21.
//

import UIKit
import CoreGraphics

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
    @IBOutlet weak var imgView: UIImageView!
    
    var hours: [Int] = []
    var minutes: [Int] = []
    var amORpm: [String] = ["am", "pm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configPickerView()
        populateClockInfo()
        setClock()

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
    
    func setClock() {
        imgView.image = getClock()
    }
    
    func getClock() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: imgView.bounds.size)
        let image = renderer.image { ctx in
            
            let ctx = UIGraphicsGetCurrentContext()
            let rect = imgView.bounds
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let rad = (rect.width / 2) - 20
                
            let endAngle = CGFloat(2 * Double.pi)
            ctx?.addArc(center: center,
                        radius: rad,
                        startAngle: 0,
                        endAngle: endAngle,
                        clockwise: false)
            
            ctx?.setFillColor(UIColor.gray.cgColor)
            ctx?.setStrokeColor(UIColor.white.cgColor)
            ctx?.setLineWidth(4.0)
            ctx?.drawPath(using: .fillStroke)
        }
        return image
    }
    
    func degree2radian(a: CGFloat) -> CGFloat {
        let b = CGFloat(Double.pi) * a / 180
        return b
    }
    
    func drawSecondMarker(ctx: CGContext, x: CGFloat, y: CGFloat, radius: CGFloat, color: UIColor) {
        // generate a path
        let path = CGMutablePath()
        // move to starting point on edge of circle
        //CGPathMoveToPoint(path, nil, radius, 0)
        path.move(to: .zero)

        // draw line of required length
        //CGPathAddLineToPoint(path, nil, x, y)
        path.move(to: CGPoint(x: x, y: y))
        // close subpath
        path.closeSubpath()
        //CGPathCloseSubpath(path)
        // add the path to the context
        ctx.addPath(path)
        // set the line width
        ctx.setLineWidth(1.5)
        // set the line color
        ctx.setStrokeColor(color.cgColor)
        // draw the line
        ctx.strokePath()
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

