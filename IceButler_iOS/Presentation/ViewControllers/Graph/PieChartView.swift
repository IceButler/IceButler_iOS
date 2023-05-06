//
//  PieChartView.swift
//  IceButler_iOS
//
//  Created by 유상 on 2023/05/06.
//

import UIKit

class PieChartView: UIView {

    override func draw(_ rect: CGRect) {
           let center = CGPoint(x: rect.midX, y: rect.midY)
           
           let colors = [UIColor.orange, UIColor.black, UIColor.systemGreen, UIColor.systemPink, UIColor.cyan, UIColor.systemTeal]
           let values: [CGFloat] = [10, 20, 70]
           let total = values.reduce(0, +)
           
           var startAngle: CGFloat = (-(.pi) / 2)
           var endAngle: CGFloat = 0.0
           
           values.forEach { (value) in
               endAngle = (value / total) * (.pi * 2)
               
               let path = UIBezierPath()
               path.move(to: center)
               path.addArc(withCenter: center,
                           radius: 60,
                           startAngle: startAngle,
                           endAngle: startAngle + endAngle,
                           clockwise: true)
               
               colors.randomElement()?.set()
               path.fill()
               startAngle += endAngle
               path.close()
               
               // slice space
               UIColor.white.set()
               path.lineWidth = 3
               path.stroke()
           }
           
           let semiCircle = UIBezierPath(arcCenter: center,
                                         radius: 40,
                                         startAngle: 0,
                                         endAngle: (360 * .pi) / 180,
                                         clockwise: true)
           UIColor.white.set()
           semiCircle.fill()
       }

}
