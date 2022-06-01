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
//  FastCheckLayer.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 8/7/2564 BE.
//

import UIKit

class FastCheckLayer: CALayer {
    private(set) var check: CAShapeLayer?
    let color: UIColor
    let lineWidth: CGFloat

    // MARK: - Public Methods
    func startAnimation() {
        let start = CAKeyframeAnimation(keyPath: "strokeStart")
        start.values = [0, 0.4, 0.3]
        start.isRemovedOnCompletion = false
        start.fillMode = CAMediaTimingFillMode.forwards
        start.duration = 0.5
        start.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        let end = CAKeyframeAnimation(keyPath: "strokeEnd")
        end.values = [0, 1, 0.9]

        end.isRemovedOnCompletion = false
        end.fillMode = CAMediaTimingFillMode.forwards
        end.duration = 0.8
        end.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        check?.add(start, forKey: "start")
        check?.add(end, forKey: "end")
    }

    func endAnimation() {
        check?.removeAllAnimations()
    }

    // MARK: - Initial Methods
    init(frame: CGRect, color: UIColor = UIColor.Asset.white, lineWidth: CGFloat = 1) {
        self.color      = color
        self.lineWidth  = lineWidth*2
        super.init()
        self.frame      = frame
        backgroundColor = UIColor.clear.cgColor
        drawCheck()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Privater Methods
    private func drawCheck() {
        let width = Double(frame.size.width)
        check = CAShapeLayer()
        check?.lineCap   = CAShapeLayerLineCap.round
        check?.lineJoin  = CAShapeLayerLineJoin.round
        check?.lineWidth = lineWidth
        check?.fillColor = UIColor.clear.cgColor
        check?.strokeColor = color.cgColor
        check?.strokeStart = 0
        check?.strokeEnd = 0
        let path = UIBezierPath()
        let aValue = sin(0.4) * (width/2)
        let bValue = cos(0.4) * (width/2)
        path.move(to: CGPoint.init(x: width/2 - bValue, y: width/2 - aValue))
        path.addLine(to: CGPoint.init(x: width/2 - width/20, y: width/2 + width/8))
        path.addLine(to: CGPoint.init(x: width - width/5, y: width/2 - aValue))
        check?.path = path.cgPath
        addSublayer(check!)
    }

}
