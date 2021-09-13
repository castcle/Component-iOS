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
//  InternalWebViewController.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 27/7/2564 BE.
//

import UIKit
import WebKit
import Core
import Defaults

class InternalWebViewController: UIViewController{

    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var webView: WKWebView!
    
    public var viewModel: InternalWebViewModel = InternalWebViewModel()
    let loadingText: String = "Loading ..."
    enum WebViewKeyPath: String {
        case estimatedProgress
        case title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Defaults[.screenId] = ""
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.progressView.progressTintColor = UIColor.Asset.lightBlue
        self.customNavigationBar(.webView, title: self.loadingText, urlString: self.viewModel.request.url?.host ?? "")
        self.webView.navigationDelegate = self
        self.webView.load(self.viewModel.request)
        self.addWebViewObservers()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeWebViewObservers()
    }
    
    private func addWebViewObservers() {
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
    }
    
    private func removeWebViewObservers() {
        self.webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
        self.webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        self.webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack))
        self.webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward))
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case WebViewKeyPath.estimatedProgress.rawValue:
            self.progressView.progress = Float(self.webView.estimatedProgress)
            if self.progressView.progress == 1.0 {
                self.progressView.alpha = 0.0
            } else if self.progressView.alpha != 1.0 {
                self.progressView.alpha = 1.0
            }
        case WebViewKeyPath.title.rawValue:
            self.viewModel.titleWeb = ((self.viewModel.titleHidden ? self.loadingText : self.webView.title) ?? self.loadingText)
            if let scheme = self.webView.url?.scheme,
                let host = self.webView.url?.host {
                self.viewModel.detailWeb = "\(scheme)://\(host)"
            } else {
                self.viewModel.detailWeb = ""
            }

            self.customNavigationBar(.webView, title: self.viewModel.titleWeb, urlString: self.viewModel.detailWeb)
        default:
            break
        }
    }
}

extension InternalWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        switch navigationAction.navigationType {
        case .linkActivated:
            webView.load(navigationAction.request)
        default:
            // TODO: Handle other types
            break
        }
        decisionHandler(.allow)
    }
}
