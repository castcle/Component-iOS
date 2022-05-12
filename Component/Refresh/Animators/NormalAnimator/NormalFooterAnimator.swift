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
//  NormalFooterAnimator.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 8/7/2564 BE.
//

import UIKit

open class NormalFooterAnimator: UIView, RefreshProtocol {

    static let bundle = RefreshBundle.bundle(name: "NormalFooter", for: NormalFooterAnimator.self)
    open var loadingMoreDescription = "Loading more" // bundle?.localizedString(key: "CRRefreshFooterIdleText")
    open var noMoreDataDescription  = "No more data" // bundle?.localizedString(key: "CRRefreshFooterNoMoreText")
    open var loadingDescription     = "Loading..." // bundle?.localizedString(key: "CRRefreshFooterRefreshingText")

    open var view: UIView { return self }
    open var duration: TimeInterval = 0.3
    open var insets: UIEdgeInsets   = .zero
    open var trigger: CGFloat       = 50.0
    open var execute: CGFloat       = 50.0
    open var endDelay: CGFloat      = 0
    open var hold: CGFloat          = 50

    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.init(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    fileprivate lazy var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        indicatorView.isHidden = true
        return indicatorView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = loadingMoreDescription
        addSubview(titleLabel)
        addSubview(indicatorView)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func refreshBegin(view: RefreshComponent) {
        indicatorView.startAnimating()
        titleLabel.text = loadingDescription
        indicatorView.isHidden = false
    }

    public func refreshWillEnd(view: RefreshComponent) {
        // MARK: - Refresh Will End
    }

    open func refreshEnd(view: RefreshComponent, finish: Bool) {
        indicatorView.stopAnimating()
        titleLabel.text = loadingMoreDescription
        indicatorView.isHidden = true
    }

    open func refresh(view: RefreshComponent, progressDidChange progress: CGFloat) {
        // MARK: - Progress Did Change
    }

    open func refresh(view: RefreshComponent, stateDidChange state: RefreshState) {
        switch state {
        case .idle:
            titleLabel.text = loadingMoreDescription
        case .refreshing :
            titleLabel.text = loadingDescription
        case .noMoreData:
            titleLabel.text = noMoreDataDescription
        case .pulling:
            titleLabel.text = loadingMoreDescription
        default:
            break
        }
        setNeedsLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let viewSize = self.bounds.size
        let viewWidth = viewSize.width
        let viewHeight = viewSize.height
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: viewWidth / 2.0, y: viewHeight / 2.0 - 5.0 + insets.top)
        indicatorView.center = CGPoint.init(x: titleLabel.frame.origin.x - 18.0, y: titleLabel.center.y)
    }
}
