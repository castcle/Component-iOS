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
//  FastAnimator.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 8/7/2564 BE.
//

import UIKit
import Core

open class FastAnimator: UIView, RefreshProtocol {
    
    open var view: UIView { return self }
    
    open var insets: UIEdgeInsets = .zero
    
    open var trigger: CGFloat = 55.0
    
    open var execute: CGFloat = 55.0
    
    open var endDelay: CGFloat = 1.5
    
    open var hold: CGFloat = 55.0
    
    private(set) var color: UIColor = UIColor.Asset.lightBlue
    
    private(set) var arrowColor: UIColor = UIColor.Asset.lightBlue
    
    private(set) var lineWidth: CGFloat = 1
    
    private(set) var fastLayer: FastLayer?


    //MARK: RefreshProtocol
    open func refreshBegin(view: RefreshComponent) {
        fastLayer?.arrow?.startAnimation().animationEnd = { [weak self] in
            self?.fastLayer?.circle?.startAnimation()
        }
    }
    
    open func refreshEnd(view: RefreshComponent, finish: Bool) {
        if finish {
            fastLayer?.arrow?.endAnimation()
            fastLayer?.circle?.endAnimation(finish: finish)
            fastLayer?.arrow?.setAffineTransform(CGAffineTransform.identity)
        }
    }
    
    open func refreshWillEnd(view: RefreshComponent) {
        fastLayer?.circle?.endAnimation(finish: false)
    }
    
    open func refresh(view: RefreshComponent, progressDidChange progress: CGFloat) {
        if progress >= 1 {
            let transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi))
            fastLayer?.arrow?.setAffineTransform(transform)
        } else {
            let transform = CGAffineTransform.identity.rotated(by: CGFloat(2 * Double.pi))
            fastLayer?.arrow?.setAffineTransform(transform)
        }
    }
    
    open func refresh(view: RefreshComponent, stateDidChange state: RefreshState) {

    }
    
    //MARK: Override
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if fastLayer == nil {
            let width  = frame.width
            let height = frame.height
            fastLayer = FastLayer(frame: .init(x: width/2 - 14,
                                               y: height/2 - 14,
                                               width: 28, height: 28),
                                  color: color,
                                  arrowColor: arrowColor,
                                  lineWidth: lineWidth)
            layer.addSublayer(fastLayer!)
        }
    }
    
    //MARK: Initial Methods
    public init(frame: CGRect,
             color: UIColor = UIColor.Asset.lightBlue,
             arrowColor: UIColor = UIColor.Asset.white,
             lineWidth: CGFloat = 1) {
        self.color      = color
        self.arrowColor = arrowColor
        self.lineWidth  = lineWidth
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
