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
//  NavigationBar.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 8/7/2564 BE.
//

import UIKit
import Core

public enum NavBarButtonType {
    case logo
    case menu
    case back
    case profile
    
    public var image: UIImage {
        switch self {
        case .logo:
            return UIImage.init(icon: .castcle(.logo), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        case .menu:
            return UIImage.init(icon: .castcle(.alignJustify), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        case .back:
            return UIImage.init(icon: .castcle(.back), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        case .profile:
            return UIImage.init(icon: .castcle(.profile), size: CGSize(width: 24, height: 24), textColor: UIColor.Asset.white)
        }
    }
    
    public var barButton: UIButton {
        let icon = UIButton(type: .system)
        icon.setImage(self.image.withRenderingMode(.alwaysOriginal), for: .normal)
        return icon
    }
}

public enum NavBarType {
    case primary
    case secondary
    case webView
}

public enum BarButtonActionType {
    case leftButton
    case firstRightButton
    case secondRightButton
}

public extension UIViewController {
    
    func customNavigationBar(_ type: NavBarType, title: String, urlString: String = "", leftBarButton: NavBarButtonType? = nil) {
        
        // MARK: - Set Background
        navigationController?.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        navigationController?.navigationBar.isTranslucent = false
        
        if type == .primary {
            self.setupPrimaryNavigationBar(title: title, leftBarButton: leftBarButton)
        } else if type == .webView {
            self.setupWebViewNavigationBar(title: title, urlString: urlString)
        } else {
            self.setupSecondaryNavigationBar(title: title)
        }
    }
    
    private func setupPrimaryNavigationBar(title: String, leftBarButton: NavBarButtonType?) {
        // MARK: - Title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.Asset.lightBlue,
            .font: UIFont.asset(.regular, fontSize: .h4)
        ]
        
        navigationItem.title = title
        
        // MARK: - Left Bar Button
        self.setupLeftNavigationBar(leftBarButton: leftBarButton)
    }
    
    private func setupSecondaryNavigationBar(title: String) {
        // MARK: - Title
        let leftButton: NavBarButtonType = .back
        let icon = UIButton(type: .system)
        icon.setImage(leftButton.image.withRenderingMode(.alwaysOriginal), for: .normal)
        icon.setTitle("   \(title)", for: .normal)
        icon.setTitleColor(UIColor.Asset.white, for: .normal)
        icon.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        icon.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        icon.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: icon)
    }
    
    private func setupWebViewNavigationBar(title: String, urlString: String) {
        // MARK: - Title
        let titleStackView: UIStackView = {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
            titleLabel.textColor = UIColor.Asset.lightBlue
            titleLabel.textAlignment = .center
            titleLabel.text = title
            
            let urlLabel = UILabel()
            urlLabel.font = UIFont.asset(.regular, fontSize: .custom(size: 10))
            urlLabel.textColor = UIColor.Asset.lightBlue
            urlLabel.textAlignment = .center
            urlLabel.text = urlString
            
            let stackView = UIStackView(arrangedSubviews: [titleLabel, urlLabel])
            stackView.axis = .vertical
            return stackView
        }()
        
        navigationItem.titleView = titleStackView
        
        // MARK: - Left Bar Button
        self.setupLeftNavigationBar(leftBarButton: .back)
    }
    
    private func setupLeftNavigationBar(leftBarButton: NavBarButtonType?) {

        if let leftButton = leftBarButton {
            let icon = UIButton(type: .system)
            icon.setImage(leftButton.image.withRenderingMode(.alwaysOriginal), for: .normal)
            
            if leftBarButton == .back {
                icon.addTarget(self, action: #selector(backAction), for: .touchUpInside)
            }
        
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: icon)
        }
    }
    
    @objc private func backAction() {
        Utility.currentViewController().navigationController?.popViewController(animated: true)
    }
}
