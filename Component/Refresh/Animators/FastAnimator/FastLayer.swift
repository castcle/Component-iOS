//
//  FastLayer.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 8/7/2564 BE.
//

import UIKit

class FastLayer: CALayer {
    
    private (set)var circle: FastCircleLayer?
    
    private (set)var arrow: FastArrowLayer?
    
    let color: UIColor
    
    let arrowColor: UIColor

    let lineWidth: CGFloat
    
    //MARK: Public Methods
    
    
    //MARK: Override
    
    
    //MARK: Initial Methods
    init(frame: CGRect, color: UIColor = UIColor.Asset.lightBlue, arrowColor: UIColor = UIColor.Asset.white, lineWidth: CGFloat = 1) {
        self.color      = color
        self.arrowColor = arrowColor
        self.lineWidth  = lineWidth
        super.init()
        self.frame = frame
        backgroundColor = UIColor.clear.cgColor
        initCircle()
        initArrowLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Privater Methods
    private func initCircle() {
        circle = FastCircleLayer(frame: bounds, color: color, pointColor: arrowColor, lineWidth: lineWidth)
        addSublayer(circle!)
    }
    
    private func initArrowLayer() {
        arrow = FastArrowLayer(frame: bounds, color: arrowColor, lineWidth: lineWidth)
        addSublayer(arrow!)
    }
    
}
