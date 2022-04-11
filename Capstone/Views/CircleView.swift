//
//  CircleView.swift
//  Capstone
//
//  Created by BVU Student on 2/14/22.
//
//import other file, get a variable from file, set variable to that
import UIKit

/* NOT A VIEW */
class CircleView: UIButton {

    var selectedColor: String = "blue"
    //var i: Int?
    init(selectedColor: String, frame: CGRect) {
        print("Debug: \(selectedColor)")
        self.selectedColor = selectedColor
        
        //self.i = i
        super.init(frame: frame)
        drawOval()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.red.cgColor
        //self.isUserInteractionEnabled = true
        //self.is
    }

/*    public var selectedColor: String = "yellow"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        drawOval()
    }
        
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
    
    public func drawOval() {
        let path = UIBezierPath(ovalIn: self.bounds)
            
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        if (selectedColor == "blue") {
            shapeLayer.fillColor = UIColor.blue.cgColor
        }
        else if (selectedColor == "green") {
            shapeLayer.fillColor = UIColor.green.cgColor
        }
        else if (selectedColor == "red") {
            shapeLayer.fillColor = UIColor.red.cgColor
        }
        else if (selectedColor == "yellow") {
            shapeLayer.fillColor = UIColor.yellow.cgColor
        }
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.black.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
    /*override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first;
        let location = touch?.location(in: self.superview);
        if(location != nil)
        {
        self.frame.origin = CGPoint(x: location!.x-self.frame.size.width/2, y: location!.y-self.frame.size.height/2);
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }*/
    
    /*@objc func labelTapped(_ sender: UITapGestureRecognizer) {
            print("labelTapped")
        }
    
    func setupLabelTap() {
        
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(labelTap)
        
    }*/
    /*override func draw(_ rect: CGRect) {
        // Get the Graphics Context
        if let context = UIGraphicsGetCurrentContext() {
            
            // Set the circle outerline-width
            context.setLineWidth(8.0);
            
            // Set the circle outerline-colour
            UIColor.blue.set()
            
            // Create Circle
            //let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
            let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
            let radius = (frame.size.width - 10)/3.5
            context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
                
            // Draw
            context.strokePath()
        }
    }*/

}
