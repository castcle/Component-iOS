//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  FastArrowLayer.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 8/7/2564 BE.
//

import UIKit

class FastArrowLayer: CALayer, CAAnimationDelegate {

    var color: UIColor = UIColor.Asset.white
    var lineWidth: CGFloat = 1
    private var lineLayer: CAShapeLayer?
    private var arrowLayer: CAShapeLayer?
    private let animationDuration: Double = 0.2
    var animationEnd: (() -> Void)?

    // MARK: - Initial Methods
    init(frame: CGRect,
         color: UIColor = UIColor.Asset.white,
         lineWidth: CGFloat = 1) {
        self.color      = color
        self.lineWidth  = lineWidth
        super.init()
        self.frame      = frame
        backgroundColor = UIColor.clear.cgColor
        initLineLayer()
        initArrowLayer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Privater Methods
    private func initLineLayer() {
        let width  = frame.size.width
        let height = frame.size.height
        let path = UIBezierPath()
        path.move(to: .init(x: width/2, y: 0))
        path.addLine(to: .init(x: width/2, y: height/2 + height/3))
        lineLayer = CAShapeLayer()
        lineLayer?.lineWidth   = lineWidth*2
        lineLayer?.strokeColor = color.cgColor
        lineLayer?.fillColor   = UIColor.clear.cgColor
        lineLayer?.lineCap     = CAShapeLayerLineCap.round
        lineLayer?.path        = path.cgPath
        lineLayer?.strokeStart = 0.5
        addSublayer(lineLayer!)
    }

    private func initArrowLayer() {
        let width  = frame.size.width
        let height = frame.size.height
        let path = UIBezierPath()
        path.move(to: .init(x: width/2 - height/6, y: height/2 + height/6))
        path.addLine(to: .init(x: width/2, y: height/2 + height/3))
        path.addLine(to: .init(x: width/2 + height/6, y: height/2 + height/6))
        arrowLayer = CAShapeLayer()
        arrowLayer?.lineWidth   = lineWidth*2
        arrowLayer?.strokeColor = color.cgColor
        arrowLayer?.lineCap     = CAShapeLayerLineCap.round
        arrowLayer?.lineJoin    = CAShapeLayerLineJoin.round
        arrowLayer?.fillColor   = UIColor.clear.cgColor
        arrowLayer?.path        = path.cgPath
        addSublayer(arrowLayer!)
    }

    // MARK: - public Methods
    @discardableResult
    func startAnimation() -> Self {
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.duration  = animationDuration
        start.fromValue = 0
        start.toValue   = 0.5
        start.isRemovedOnCompletion = false
        start.fillMode  = CAMediaTimingFillMode.forwards
        start.delegate    = self
        start.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.duration  = animationDuration
        end.fromValue = 1
        end.toValue   = 0.5
        end.isRemovedOnCompletion = false
        end.fillMode  = CAMediaTimingFillMode.forwards
        end.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        arrowLayer?.add(start, forKey: "strokeStart")
        arrowLayer?.add(end, forKey: "strokeEnd")

        return self
    }

    func endAnimation() {
        arrowLayer?.isHidden = false
        lineLayer?.isHidden  = false
        arrowLayer?.removeAllAnimations()
        lineLayer?.removeAllAnimations()
    }

    private func addLineAnimation() {
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.fromValue = 0.5
        start.toValue = 0
        start.isRemovedOnCompletion = false
        start.fillMode  = CAMediaTimingFillMode.forwards
        start.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        start.duration  = animationDuration/2
        lineLayer?.add(start, forKey: "strokeStart")

        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.beginTime = CACurrentMediaTime() + animationDuration/3
        end.duration  = animationDuration/2
        end.fromValue = 1
        end.toValue   = 0.03
        end.isRemovedOnCompletion = false
        end.fillMode  = CAMediaTimingFillMode.forwards
        end.delegate  = self
        end.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        lineLayer?.add(end, forKey: "strokeEnd")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let anim = anim as? CABasicAnimation {
            if anim.keyPath == "strokeStart" {
                arrowLayer?.isHidden = true
                addLineAnimation()
            } else {
                lineLayer?.isHidden = true
                animationEnd?()
            }
        }
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }
}
