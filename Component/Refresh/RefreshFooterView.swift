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
//  RefreshFooterView.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 8/7/2564 BE.
//

import UIKit

open class RefreshFooterView: RefreshComponent {
    open var noMoreData = false {
        didSet {
            if noMoreData != oldValue {
                state = .idle
            }
        }
    }

    open override var isHidden: Bool {
        didSet {
            if isHidden {
                scrollView?.contentInset.bottom = scrollViewInsets.bottom
                var rect = self.frame
                rect.origin.y = scrollView?.contentSize.height ?? 0.0
                self.frame = rect
            } else {
                scrollView?.contentInset.bottom = scrollViewInsets.bottom + animator.execute
                var rect = self.frame
                rect.origin.y = scrollView?.contentSize.height ?? 0.0
                self.frame = rect
            }
        }
    }

    public convenience init(animator: RefreshProtocol = NormalFooterAnimator(), handler: @escaping RefreshHandler) {
        self.init(frame: .zero)
        self.handler  = handler
        self.animator = animator
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.scrollViewInsets = weakSelf.scrollView?.contentInset ?? UIEdgeInsets.zero
            weakSelf.scrollView?.contentInset.bottom = weakSelf.scrollViewInsets.bottom + weakSelf.bounds.size.height
            var rect = weakSelf.frame
            rect.origin.y = weakSelf.scrollView?.contentSize.height ?? 0.0
            weakSelf.frame = rect
        }
    }

    open override func start() {
        guard let scrollView = scrollView else { return }
        super.start()
        animator.refreshBegin(view: self)
        let xAxis = scrollView.contentOffset.x
        let yAxis = max(0.0, scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            scrollView.contentOffset = .init(x: xAxis, y: yAxis)
        }, completion: { _ in
            self.handler?()
        })
    }

    open override func stop() {
        guard let scrollView = scrollView else { return }
        animator.refreshEnd(view: self, finish: false)
        UIView.animate(withDuration: RefreshComponent.animationDuration, delay: 0, options: .curveLinear, animations: {
            // MARK: - Block animate
        }, completion: { _ in
            if !self.noMoreData {
                self.state = .idle
            }
            super.stop()
            self.animator.refreshEnd(view: self, finish: true)
        })
        if scrollView.isDecelerating {
            var contentOffset = scrollView.contentOffset
            contentOffset.y = min(contentOffset.y, scrollView.contentSize.height - scrollView.frame.size.height)
            if contentOffset.y < 0.0 {
                contentOffset.y = 0.0
                UIView.animate(withDuration: 0.1, animations: {
                    scrollView.setContentOffset(contentOffset, animated: false)
                })
            } else {
                scrollView.setContentOffset(contentOffset, animated: false)
            }
        }
    }

    open override func sizeChange(change: [NSKeyValueChangeKey: Any]?) {
        guard let scrollView = scrollView else { return }
        super.sizeChange(change: change)
        let targetY = scrollView.contentSize.height + scrollViewInsets.bottom
        if self.frame.origin.y != targetY {
            var rect = self.frame
            rect.origin.y = targetY
            self.frame = rect
        }
    }

    open override func offsetChange(change: [NSKeyValueChangeKey: Any]?) {
        guard let scrollView = scrollView else { return }
        super.offsetChange(change: change)
        guard !isRefreshing && !noMoreData && !isHidden else {
            return
        }

        if scrollView.contentSize.height <= 0.0 || scrollView.contentOffset.y + scrollView.contentInset.top <= 0.0 {
            alpha = 0.0
            return
        } else {
            alpha = 1.0
        }

        if scrollView.contentSize.height + scrollView.contentInset.top > scrollView.bounds.size.height {
            if scrollView.contentSize.height - scrollView.contentOffset.y + scrollView.contentInset.bottom  <= scrollView.bounds.size.height {
                state = .refreshing
                beginRefreshing()
            }
        } else {
            if scrollView.contentOffset.y + scrollView.contentInset.top >= animator.trigger / 2.0 {
                state = .refreshing
                beginRefreshing()
            }
        }
    }

    open func noticeNoMoreData() {
        noMoreData = true
        self.state = .noMoreData
    }

    open func resetNoMoreData() {
        noMoreData = false
    }

}
