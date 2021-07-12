//
//  RefreshAnimator.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 8/7/2564 BE.
//

import UIKit

open class RefreshAnimator: RefreshProtocol {
    
    open var view: UIView
    
    open var insets: UIEdgeInsets
    
    open var trigger: CGFloat = 60.0
    
    open var execute: CGFloat = 60.0
    
    open var endDelay: CGFloat = 0
    
    public var hold: CGFloat   = 60
    
    public init() {
        view = UIView()
        insets = UIEdgeInsets.zero
    }
    
    open func refreshBegin(view: RefreshComponent) {}
    
    open func refreshWillEnd(view: RefreshComponent) {}
    
    open func refreshEnd(view: RefreshComponent, finish: Bool) {}
    
    open func refresh(view: RefreshComponent, progressDidChange progress: CGFloat) {}
    
    open func refresh(view: RefreshComponent, stateDidChange state: RefreshState) {}
}
