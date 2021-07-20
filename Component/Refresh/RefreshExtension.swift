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
//  RefreshExtension.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 8/7/2564 BE.
//

import UIKit

private var kRefreshHeaderKey = "kRefreshHeaderKey"
private var kRefreshFooterKey = "kRefreshFooterKey"

public typealias RefreshView = UIScrollView

extension RefreshView {
    public var cr: RefreshDSL {
        return RefreshDSL(scroll: self)
    }
}

public struct RefreshDSL: RefreshViewProtocol {
    
    public var scroll: RefreshView
    
    internal init(scroll: RefreshView) {
        self.scroll = scroll
    }

    @discardableResult
    public func addHeadRefresh(animator: RefreshProtocol = NormalHeaderAnimator(), handler: @escaping RefreshHandler) -> RefreshHeaderView {
        return RefreshMake.addHeadRefreshTo(refresh: scroll, animator: animator, handler: handler)
    }
    
    public func beginHeaderRefresh() {
        header?.beginRefreshing()
    }
    
    public func endHeaderRefresh() {
        header?.endRefreshing()
    }
    
    public func removeHeader() {
        var headRefresh = RefreshMake(scroll: scroll)
        headRefresh.removeHeader()
    }
    
    @discardableResult
    public func addFootRefresh(animator: RefreshProtocol = NormalFooterAnimator(), handler: @escaping RefreshHandler) -> RefreshFooterView {
        return RefreshMake.addFootRefreshTo(refresh: scroll, animator: animator, handler: handler)
    }
    
    public func noticeNoMoreData() {
        footer?.endRefreshing()
        footer?.noticeNoMoreData()
    }
    
    public func resetNoMore() {
        footer?.resetNoMoreData()
    }
    
    public func endLoadingMore() {
        footer?.endRefreshing()
    }
    
    public func removeFooter() {
        var footRefresh = RefreshMake(scroll: scroll)
        footRefresh.removeFooter()
    }
}


public struct RefreshMake: RefreshViewProtocol {
    
    public var scroll: RefreshView
    
    internal init(scroll: RefreshView) {
        self.scroll = scroll
    }
    
    @discardableResult
    internal static func addHeadRefreshTo(refresh: RefreshView, animator: RefreshProtocol = NormalHeaderAnimator(), handler: @escaping RefreshHandler) -> RefreshHeaderView {
        var make = RefreshMake(scroll: refresh)
        make.removeHeader()
        let header     = RefreshHeaderView(animator: animator, handler: handler)
        let headerH    = header.animator.execute
        header.frame   = .init(x: 0, y: -headerH, width: refresh.bounds.size.width, height: headerH)
        refresh.addSubview(header)
        make.header = header
        return header
    }
    
    public mutating func removeHeader() {
        header?.endRefreshing()
        header?.removeFromSuperview()
        header = nil
    }
    
    @discardableResult
    internal static func addFootRefreshTo(refresh: RefreshView, animator: RefreshProtocol = NormalFooterAnimator(), handler: @escaping RefreshHandler) -> RefreshFooterView {
        var make = RefreshMake(scroll: refresh)
        make.removeFooter()
        let footer     = RefreshFooterView(animator: animator, handler: handler)
        let footerH    = footer.animator.execute
        footer.frame   = .init(x: 0, y: refresh.contentSize.height + refresh.contentInset.bottom, width: refresh.bounds.size.width, height: footerH)
        refresh.addSubview(footer)
        make.footer = footer
        return footer
    }
    
    public mutating func removeFooter() {
        footer?.endRefreshing()
        footer?.removeFromSuperview()
        footer = nil
    }
}

public protocol RefreshViewProtocol {
    var scroll: RefreshView {set get}
    var header: RefreshHeaderView? {set get}
    var footer: RefreshFooterView? {set get}
}

extension RefreshViewProtocol {
    
    public var header: RefreshHeaderView? {
        get {
            return (objc_getAssociatedObject(scroll, &kRefreshHeaderKey) as? RefreshHeaderView)
        }
        set {
            objc_setAssociatedObject(scroll, &kRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var footer: RefreshFooterView? {
        get {
            return (objc_getAssociatedObject(scroll, &kRefreshFooterKey) as? RefreshFooterView)
        }
        set {
            objc_setAssociatedObject(scroll, &kRefreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
