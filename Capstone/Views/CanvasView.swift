//
//  CanvasView.swift
//  Capstone
//
//  Created by BVU Student on 3/16/22.
//

import UIKit

struct TouchPointsAndColor {
    var color: UIColor?
    var width: CGFloat?
    var opacity: CGFloat?
    var points: [CGPoint]?
     
   init(color: UIColor, points: [CGPoint]?) {
       self.color = color
       self.points = points
   }
}


class CanvasView: UIView {

     var lines = [TouchPointsAndColor]()
     var strokeWidth: CGFloat = 1.0
     var strokeColor: UIColor = .black
     var strokeOpacity: CGFloat = 1.0
     
     override func draw(_ rect: CGRect) {
         super.draw(rect)
         
       guard let context = UIGraphicsGetCurrentContext() else {
             return
         }
         
         lines.forEach { (line) in
             for (i, p) in (line.points?.enumerated())! {
                 if i == 0 {
                     context.move(to: p)
                 } else {
                     context.addLine(to: p)
                 }
                 context.setStrokeColor(line.color?.withAlphaComponent(line.opacity ?? 1.0).cgColor ?? UIColor.black.cgColor)
                 context.setLineWidth(line.width ?? 1.0)
             }
             context.setLineCap(.round)
             context.strokePath()
         }
     }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var annotes : Dictionary<String, Array<Dictionary<String, CGFloat>>> = ["accesspoint": [[:]]]
        
        for touch in touches {
            //if uploaded != false {
            // Set the Center of the Circle
            let circleCenter = touch.location(in: self)
            let dict = ["x": circleCenter.x, "y": circleCenter.y]
            
            NewProjectViewController().myArray.append(dict)
            
            annotes = ["accesspoint": NewProjectViewController().myArray]
            
            //print("Annotes: ", annotes)
            
            // Set a Circle Radius
            let circleWidth = CGFloat(25)
            let circleHeight = circleWidth
                
            // Create a new CircleView
            // 3
            //let circleView = CircleView(frame: CGRect(x: circleCenter.x, y: circleCenter.y, width: circleWidth, height: circleHeight))
            let myLayer = CALayer()
            
            let myImage = UIImage(systemName: "circle.fill")?.cgImage
            myLayer.frame = CGRect(x: circleCenter.x, y: circleCenter.y, width: circleWidth, height: circleHeight)
            myLayer.contents = myImage
            self.layer.addSublayer(myLayer)
            //self.addSubview(circleView)
            //}
        }
        //saved = false
        //print("touch")
    }
    
    
     //override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     //    lines.append(TouchPointsAndColor(color: UIColor(), points: [CGPoint]()))
     //}
     
     /*override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
         guard let touch = touches.first?.location(in: nil) else {
             return
         }
         
         guard var lastPoint = lines.popLast() else {return}
         lastPoint.points?.append(touch)
         lastPoint.color = strokeColor
         lastPoint.width = strokeWidth
         lastPoint.opacity = strokeOpacity
         lines.append(lastPoint)
         setNeedsDisplay()
     }*/
 }
