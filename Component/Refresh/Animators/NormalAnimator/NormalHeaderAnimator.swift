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
//  NormalHeaderAnimator.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 8/7/2564 BE.
//

import UIKit

open class NormalHeaderAnimator: UIView, RefreshProtocol {
    
    static let bundle = RefreshBundle.bundle(name: "NormalHeader", for: NormalHeaderAnimator.self)
    
    open var pullToRefreshDescription = bundle?.localizedString(key: "CRRefreshHeaderIdleText") {
        didSet {
            if pullToRefreshDescription != oldValue {
                titleLabel.text = pullToRefreshDescription;
            }
        }
    }
    open var releaseToRefreshDescription = bundle?.localizedString(key: "CRRefreshHeaderPullingText")
    open var loadingDescription = bundle?.localizedString(key: "CRRefreshHeaderRefreshingText")

    open var view: UIView { return self }
    open var insets: UIEdgeInsets = .zero
    open var trigger: CGFloat  = 60.0
    open var execute: CGFloat  = 60.0
    open var endDelay: CGFloat = 0
    public var hold: CGFloat   = 60

    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = bundle?.imageFromBundle("refresh_arrow")
        return imageView
    }()
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 0.625, alpha: 1.0)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        indicatorView.isHidden = true
        return indicatorView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = pullToRefreshDescription
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(indicatorView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshBegin(view: RefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        imageView.isHidden     = true
        titleLabel.text        = loadingDescription
        imageView.transform    = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
    }
  
    open func refreshEnd(view: RefreshComponent, finish: Bool) {
        if finish {
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
            imageView.isHidden = false
            imageView.transform = CGAffineTransform.identity
        }else {
            titleLabel.text = pullToRefreshDescription
            setNeedsLayout()
        }
    }
    
    public func refreshWillEnd(view: RefreshComponent) {
        // MARK: - Refresh Will End
    }
    
    open func refresh(view: RefreshComponent, progressDidChange progress: CGFloat) {
        // MARK: - Progress Did Change
    }
    
    open func refresh(view: RefreshComponent, stateDidChange state: RefreshState) {
        switch state {
        case .refreshing:
            titleLabel.text = loadingDescription
            setNeedsLayout()
        case .pulling:
            titleLabel.text = releaseToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat(Double.pi))
            }) { (animated) in
                // MARK: - Block animated
            }
        case .idle:
            titleLabel.text = pullToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform.identity
            }) { (animated) in
                // MARK: - Block animated
            }
        default:
            break
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = bounds.size
        let w = s.width
        let h = s.height
        
        UIView.performWithoutAnimation {
            titleLabel.sizeToFit()
            titleLabel.center = .init(x: w / 2.0, y: h / 2.0)
            indicatorView.center = .init(x: titleLabel.frame.origin.x - 16.0, y: h / 2.0)
            imageView.frame = CGRect.init(x: titleLabel.frame.origin.x - 28.0, y: (h - 18.0) / 2.0, width: 18.0, height: 18.0)
        }
    }
    
}
