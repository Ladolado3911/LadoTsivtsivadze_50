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
    var quarters: [CGFloat] = [3.14, 0, 1.57, 4.71]
    
    var hourAngle: CGFloat = 0
    var minuteAngle: CGFloat = 4.71
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.backgroundColor = .black
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
        imgView.image = nil
        imgView.image = getClock()
    }
    
    func getClock() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: imgView.bounds.size)
        let image = renderer.image { ctx in

            let rect = imgView.bounds
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let rad = (rect.width / 2) - 20
                
            let endAngle = CGFloat(2 * Double.pi)
            ctx.cgContext.addArc(center: center,
                        radius: rad,
                        startAngle: 0,
                        endAngle: endAngle,
                        clockwise: false)
            
            ctx.cgContext.setFillColor(UIColor.gray.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.white.cgColor)
            ctx.cgContext.setLineWidth(3)
            
            let angle = (2 * CGFloat.pi) / 60
            ctx.cgContext.translateBy(x: center.x, y: center.y)
            var currentAngle: CGFloat = 0
            for _ in 1...60 {
                let current = CGPoint(x: rad, y: 0)
                
                if hourAngle > 6.14 {
                    ctx.cgContext.setFillColor(UIColor.blue.cgColor)
                }
                
                if quarters.contains(CGFloat(Double(round(100 * currentAngle) / 100 ))) {
                    print("Cought")
                    let endPointHigh = CGPoint(x: rad - 35, y: 0)
                    addClockLine(tool: ctx.cgContext, starting: current, end: endPointHigh)
                    ctx.cgContext.rotate(by: angle)
                    print(CGFloat(Double(round(100 * currentAngle) / 100 )))
                    currentAngle += angle
                }
                else {
                    let endPoint = CGPoint(x: rad - 20, y: 0)
                    addClockLine(tool: ctx.cgContext, starting: current, end: endPoint)
                    ctx.cgContext.rotate(by: angle)
                    print(CGFloat(Double(round(100 * currentAngle) / 100 )))
                    currentAngle += angle
                }
            }
            ctx.cgContext.drawPath(using: .fillStroke)
            
            ctx.cgContext.rotate(by: -1.57)
            ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
            
            ctx.cgContext.addArc(center: .zero, radius: rad, startAngle: 0, endAngle: hourAngle, clockwise: false)
            
            ctx.cgContext.rotate(by: hourAngle)
            addClockLine(tool: ctx.cgContext, starting: .zero, end: CGPoint(x: rad - 90, y: 0))
            ctx.cgContext.rotate(by: -hourAngle)
            ctx.cgContext.rotate(by: minuteAngle)
            addClockLine(tool: ctx.cgContext, starting: .zero, end: CGPoint(x: rad - 60, y: 0))

            ctx.cgContext.strokePath()
        }
        return image
    }
    
    func addClockLine(tool ctx: CGContext, starting point1: CGPoint, end point2: CGPoint) {
        ctx.move(to: point1)
        ctx.addLine(to: point2)
    }
    
    func hourToRadian(hour: Int) -> CGFloat {
        CGFloat(CGFloat(hour) * ((2 * .pi) / 12))
    }
    
    func minuteToRadian(minute: Int) -> CGFloat {
        CGFloat(CGFloat(minute) * ((2 * .pi) / 60))
    }
    
    @IBAction func onSetTime(_ sender: Any) {
        let selectedTime = getPickerTime()
        print("\(selectedTime.hour): \(selectedTime.minute): \(selectedTime.amORpm.rawValue)")
        hourAngle = hourToRadian(hour: selectedTime.hour)
        minuteAngle = minuteToRadian(minute: selectedTime.minute)
        setClock()
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

extension ViewController: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        print("Did start anim")
    }
}

