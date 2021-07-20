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
//  RefreshComponent.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 8/7/2564 BE.
//

import UIKit

public typealias RefreshHandler = (() -> ())

public enum RefreshState {
    case idle
    case pulling
    case refreshing
    case willRefresh
    case noMoreData
}

open class RefreshComponent: UIView {
    
    open weak var scrollView: UIScrollView?
    
    open var scrollViewInsets: UIEdgeInsets = .zero
    
    open var handler: RefreshHandler?
    
    open var animator: RefreshProtocol!
    
    open var state: RefreshState = .idle {
        didSet {
            if state != oldValue {
                DispatchQueue.main.async {
                    self.animator.refresh(view: self, stateDidChange: self.state)
                }
            }
        }
    }
    
    fileprivate var isObservingScrollView = false
    
    fileprivate var isIgnoreObserving     = false
    
    fileprivate(set) var isRefreshing     = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin]
    }
    
    public convenience init(animator: RefreshProtocol = RefreshAnimator(), handler: @escaping RefreshHandler) {
        self.init(frame: .zero)
        self.handler  = handler
        self.animator = animator
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeObserver()
        if let newSuperview = newSuperview as? UIScrollView {
            scrollViewInsets = newSuperview.contentInset
            DispatchQueue.main.async { [weak self, newSuperview] in
                guard let weakSelf = self else { return }
                weakSelf.addObserver(newSuperview)
            }
        }
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        scrollView = superview as? UIScrollView
        let view = animator.view
        if view.superview == nil {
            let inset = animator.insets
            addSubview(view)
            view.frame = CGRect(x: inset.left,
                                y: inset.top,
                                width: bounds.size.width - inset.left - inset.right,
                                height: bounds.size.height - inset.top - inset.bottom)
            view.autoresizingMask = [
                .flexibleWidth,
                .flexibleTopMargin,
                .flexibleHeight,
                .flexibleBottomMargin
            ]
        }
    }
    
    //MARK: Public Methods
    public final func beginRefreshing() -> Void {
        guard isRefreshing == false else { return }
        if self.window != nil {
            state = .refreshing
            start()
        }else {
            if state != .refreshing {
                state = .willRefresh
                DispatchQueue.main.async {
                    self.scrollViewInsets = self.scrollView?.contentInset ?? .zero
                    if self.state == .willRefresh {
                        self.state = .refreshing
                        self.start()
                    }
                }
            }
        }
    }
    
    public final func endRefreshing() -> Void {
        guard isRefreshing else { return }
        self.stop()
    }
    
    public func ignoreObserver(_ ignore: Bool = false) {
        isIgnoreObserving = ignore
    }
    
    public func start() {
        isRefreshing = true
    }
    
    public func stop() {
        isRefreshing = false
    }
    
    public func sizeChange(change: [NSKeyValueChangeKey : Any]?) {}
    
    public func offsetChange(change: [NSKeyValueChangeKey : Any]?) {}
}



//MARK: Observer Methods 
extension RefreshComponent {
    
    fileprivate static var context            = "RefreshContext"
    fileprivate static let offsetKeyPath      = "contentOffset"
    fileprivate static let contentSizeKeyPath = "contentSize"
    public static let animationDuration       = 0.25
    
    fileprivate func removeObserver() {
        if let scrollView = superview as? UIScrollView, isObservingScrollView {
            scrollView.removeObserver(self, forKeyPath: RefreshComponent.offsetKeyPath, context: &RefreshComponent.context)
            scrollView.removeObserver(self, forKeyPath: RefreshComponent.contentSizeKeyPath, context: &RefreshComponent.context)
            isObservingScrollView = false
        }
    }
    
    fileprivate func addObserver(_ view: UIView?) {
        if let scrollView = view as? UIScrollView, !isObservingScrollView {
            scrollView.addObserver(self, forKeyPath: RefreshComponent.offsetKeyPath, options: [.initial, .new], context: &RefreshComponent.context)
            scrollView.addObserver(self, forKeyPath: RefreshComponent.contentSizeKeyPath, options: [.initial, .new], context: &RefreshComponent.context)
            isObservingScrollView = true
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &RefreshComponent.context {
            guard isUserInteractionEnabled == true && isHidden == false else {
                return
            }
            if keyPath == RefreshComponent.contentSizeKeyPath {
                if isIgnoreObserving == false {
                    sizeChange(change: change)
                }
            } else if keyPath == RefreshComponent.offsetKeyPath {
                if isIgnoreObserving == false {
                    offsetChange(change: change)
                }
            }
        }
    }
}
