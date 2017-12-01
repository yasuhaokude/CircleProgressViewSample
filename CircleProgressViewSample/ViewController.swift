//
//  ViewController.swift
//  CircleProgressViewSample
//
//  Created by 奥出泰葉 on 2017/12/01.
//  Copyright © 2017年 奥出泰葉. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var circleProgressView: UIView!
    @IBOutlet weak var label: UILabel!
    
    var circleLayer: CAShapeLayer! = nil
    var timer: Timer!
    let timeInterval: CGFloat = 0.02
    let maxSeconds: CGFloat = 30.00
    var currentSeconds: CGFloat = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel(currentSec: 0.00, maxSec: maxSeconds)
        initCircleProgressView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCircleProgressView() {
        let startAngle = CGFloat(Double.pi * 3 / 2);
        let endAngle = startAngle + CGFloat(Double.pi * 2);
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circleProgressView.frame.size.width / 2.0, y: circleProgressView.frame.size.height / 2.0), radius: (circleProgressView.frame.size.width - 10)/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 5.0
        circleLayer.strokeEnd = 0.0
        circleProgressView.layer.addSublayer(circleLayer)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.recordButtonTapped))
        circleProgressView.addGestureRecognizer(longPressGesture)
    }
    
    func updateLabel(currentSec: CGFloat, maxSec: CGFloat) {
        label.text = (NSString(format: "%.2f", currentSec) as String)+"/"+(NSString(format: "%.2f", maxSec) as String)
    }
    
    func updateShapeLayerStroke(layer: CAShapeLayer, strokeEnd: CGFloat) {
        layer.strokeEnd = strokeEnd
    }
    
    @objc func recordButtonTapped(gesture: UITapGestureRecognizer){
        if gesture.state == .began {
            startTimer()
        } else if  gesture.state == .ended {
            stopTimer()
            
        }
    }

    
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: TimeInterval(timeInterval),
            target: self,
            selector: #selector(self.recording),
            userInfo: nil,
            repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        currentSeconds = 0.00
    }

    @objc func recording() {
        currentSeconds += timeInterval
        if currentSeconds > maxSeconds {
            currentSeconds = maxSeconds
        }
        let currentStrokeEnd = currentSeconds / maxSeconds
        print(currentStrokeEnd)
        updateShapeLayerStroke(layer: circleLayer, strokeEnd: CGFloat(currentStrokeEnd > 1.0 ? 1.0 : currentStrokeEnd))
        updateLabel(currentSec: currentSeconds, maxSec: maxSeconds)
        
        if currentSeconds >= maxSeconds {
            stopTimer()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer?.invalidate()
    }


}

