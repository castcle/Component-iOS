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
    
    var image: UIImage {
        switch self {
        case .logo:
            return UIImage.init(icon: .castcle(.alignCenter), size: CGSize(width: 30, height: 30), textColor: UIColor.Asset.white)
        case .menu:
            return UIImage.init(icon: .castcle(.alignJustify), size: CGSize(width: 30, height: 30), textColor: UIColor.Asset.white)
        case .back:
            return UIImage.init(icon: .castcle(.batteryFull), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        }
    }
}

public enum NavBarType {
    case primary
    case secondary
}

public protocol CastcleTabbarDeleDelegate {
    func castcleTabbar(didSelectButtonBar button: Int)
}

public extension UIViewController {
    
    static var castcleTabbarDelegate: CastcleTabbarDeleDelegate?
    
    func customNavigationBar(_ type: NavBarType, title: String, leftBarButton: NavBarButtonType? = nil, rightBarButton: [NavBarButtonType]) {
        
        // MARK: - Set Background
        navigationController?.navigationBar.barTintColor = UIColor.Asset.black
        navigationController?.navigationBar.isTranslucent = false
        
        if type == .primary {
            self.setupPrimaryNavigationBar(title: title, leftBarButton: leftBarButton, rightBarButton: rightBarButton)
        } else {
            self.setupSecondaryNavigationBar(title: title, rightBarButton: rightBarButton)
        }
    }
    
    private func setupPrimaryNavigationBar(title: String, leftBarButton: NavBarButtonType?, rightBarButton: [NavBarButtonType]) {
        // MARK: - Title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.Asset.lightBlue,
            .font: UIFont.asset(.regular, fontSize: .h3)
        ]
        
        navigationItem.title = title
        
        // MARK: - Left Bar Button
        self.setupLeftNavigationBar(leftBarButton: leftBarButton)
        
        // MARK: - Right Bar Button
        self.setupRightNavigationBar(rightBarButton: rightBarButton)
    }
    
    private func setupSecondaryNavigationBar(title: String, rightBarButton: [NavBarButtonType]) {
        // MARK: - Title
        let leftButton: NavBarButtonType = .back
        let icon = UIButton(type: .system)
        icon.setImage(leftButton.image.withRenderingMode(.alwaysOriginal), for: .normal)
        icon.setTitle("   \(title)", for: .normal)
        icon.setTitleColor(UIColor.Asset.white, for: .normal)
        icon.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        icon.titleLabel?.font = UIFont.asset(.regular, fontSize: .h3)
        icon.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: icon)
        
        // MARK: - Right Bar Button
        self.setupRightNavigationBar(rightBarButton: rightBarButton)
    }
    
    private func setupLeftNavigationBar(leftBarButton: NavBarButtonType?) {

        if let leftButton = leftBarButton {
            let icon = UIButton(type: .system)
            icon.setImage(leftButton.image.withRenderingMode(.alwaysOriginal), for: .normal)
            icon.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: icon)
        }
    }
    
    private func setupRightNavigationBar(rightBarButton: [NavBarButtonType]) {
        var rightButton: [UIBarButtonItem] = []
        
        if rightBarButton.count > 0 {
            let firstItem = rightBarButton[0]
            let firstIcon = UIButton(type: .system)
            firstIcon.setImage(firstItem.image.withRenderingMode(.alwaysOriginal), for: .normal)
            firstIcon.addTarget(self, action: #selector(firstRightButtonAction), for: .touchUpInside)
            
            rightButton.append(UIBarButtonItem(customView: firstIcon))
        }
        
        if rightBarButton.count > 1 {
            let secondItem = rightBarButton[1]
            let secondIcon = UIButton(type: .system)
            secondIcon.setImage(secondItem.image.withRenderingMode(.alwaysOriginal), for: .normal)
            secondIcon.addTarget(self, action: #selector(secondRightButtonAction), for: .touchUpInside)
            
            rightButton.append(UIBarButtonItem(customView: secondIcon))
        }
        
        
        navigationItem.rightBarButtonItems = rightButton
    }
    
    @objc private func leftButtonAction() {
        UIViewController.castcleTabbarDelegate?.castcleTabbar(didSelectButtonBar: 1)
    }
    
    @objc private func firstRightButtonAction() {
        UIViewController.castcleTabbarDelegate?.castcleTabbar(didSelectButtonBar: 2)
    }
    
    @objc private func secondRightButtonAction() {
        UIViewController.castcleTabbarDelegate?.castcleTabbar(didSelectButtonBar: 3)
    }
}
