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
//  RefreshHeaderView.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 8/7/2564 BE.
//

import UIKit

open class RefreshHeaderView: RefreshComponent {
    
    fileprivate var previousOffsetY: CGFloat = 0.0
    fileprivate var scrollViewBounces: Bool  = true
    fileprivate var insetTDelta: CGFloat     = 0.0
    fileprivate var holdInsetTDelta: CGFloat = 0.0
    private var isEnding: Bool = false
    
    public convenience init(animator: RefreshProtocol = NormalHeaderAnimator(), handler: @escaping RefreshHandler) {
        self.init(frame: .zero)
        self.handler  = handler
        self.animator = animator
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.scrollViewBounces = self.scrollView?.bounces ?? true

        }
    }
    
    open override func start() {
        guard let scrollView = scrollView else { return }
        ignoreObserver(true)
        scrollView.bounces = false
        super.start()
        animator.refreshBegin(view: self)
        var insets           = scrollView.contentInset
        scrollViewInsets.top = insets.top
        insets.top          += animator.execute
        insetTDelta          = -animator.execute
        holdInsetTDelta      = -(animator.execute - animator.hold)
        var point = scrollView.contentOffset;
        point.y = -insets.top
        UIView.animate(withDuration: RefreshComponent.animationDuration, animations: {
            
            scrollView.contentOffset.y = self.previousOffsetY
            scrollView.contentInset    = insets
            scrollView.setContentOffset(point, animated: false);
            
            
        }) { (finished) in
            DispatchQueue.main.async {
                self.handler?()
                self.ignoreObserver(false)
                scrollView.bounces = self.scrollViewBounces
            }
        }
    }
    
    open override func stop() {
        guard let scrollView = scrollView else { return }
        ignoreObserver(true)
        animator.refreshWillEnd(view: self)
        if self.animator.hold != 0 {
            UIView.animate(withDuration: RefreshComponent.animationDuration) {
                scrollView.contentInset.top += self.holdInsetTDelta
            }
        }
        func beginStop() {
            guard !isEnding, isRefreshing else {
                return
            }
            isEnding = true
            animator.refreshEnd(view: self, finish: false)
            UIView.animate(withDuration: RefreshComponent.animationDuration, animations: {
                scrollView.contentInset.top += self.insetTDelta - self.holdInsetTDelta
            }) { (finished) in
                DispatchQueue.main.async {
                    self.state = .idle
                    super.stop()
                    self.animator.refreshEnd(view: self, finish: true)
                    self.ignoreObserver(false)
                    self.isEnding = false
                }
            }
        }
        if animator.endDelay > 0 {
            if !self.isEnding {
                let delay =  DispatchTimeInterval.milliseconds(Int(animator.endDelay * 1000))
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    beginStop()
                })
            }
        } else {
            beginStop()
        }
    }

    open override func offsetChange(change: [NSKeyValueChangeKey : Any]?) {
        guard let scrollView = scrollView else { return }
        super.offsetChange(change: change)
        guard isRefreshing == false else {
            if self.window == nil {return}
            let top          = scrollViewInsets.top
            let offsetY      = scrollView.contentOffset.y
            let height       = frame.size.height
            var scrollingTop = (-offsetY > top) ? -offsetY : top
            scrollingTop     = (scrollingTop > height + top) ? (height + top) : scrollingTop
            scrollView.contentInset.top = scrollingTop
            insetTDelta      = scrollViewInsets.top - scrollingTop
            return
        }
        
        var isRecordingProgress = false
        defer {
            if isRecordingProgress {
                let percent = -(previousOffsetY + scrollViewInsets.top) / animator.trigger
                animator.refresh(view: self, progressDidChange: percent)
            }
        }
        
        let offsets = previousOffsetY + scrollViewInsets.top
        if offsets < -animator.trigger {
            if !isRefreshing {
                if !scrollView.isDragging, state == .pulling {
                    beginRefreshing()
                    state = .refreshing
                } else {
                    if scrollView.isDragging {
                        state = .pulling
                        isRecordingProgress = true
                    }
                }
            }
        } else if offsets < 0 {
            if !isRefreshing {
                state = .idle
                isRecordingProgress = true
            }
        }
        previousOffsetY = scrollView.contentOffset.y
    }
}
