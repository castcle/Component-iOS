//
//  RefreshProtocol.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 8/7/2564 BE.
//

import UIKit

public protocol RefreshProtocol {
    var view: UIView {get}
    
    var insets: UIEdgeInsets {set get}
    
    var trigger: CGFloat {set get}
    
    var execute: CGFloat {set get}
    
    var endDelay: CGFloat {set get}
    
    var hold: CGFloat {set get}
    
    mutating func refreshBegin(view: RefreshComponent)
    
    mutating func refreshWillEnd(view: RefreshComponent)
    
    mutating func refreshEnd(view: RefreshComponent, finish: Bool)
    
    mutating func refresh(view: RefreshComponent, progressDidChange progress: CGFloat)
    
    mutating func refresh(view: RefreshComponent, stateDidChange state: RefreshState)
}
