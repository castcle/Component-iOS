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
//  CCActionSheet.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 15/10/2564 BE.
//

import UIKit
import Core

public class CCActionSheet: UIViewController {
    
    // MARK: - Constants
    let stackViewTopPadding: CGFloat = 20
    let stackViewBottomPadding: CGFloat = 30
    let stackViewLeadingPadding: CGFloat = 30
    let stackViewTrailingPadding: CGFloat = 30
    let buttonHeight: CGFloat = 35
    let interButtonSpace: CGFloat = 16
    let backgroundView = UIView()
    let stackView = UIStackView()
    let handleView = HandleView()
    var isGestureDismiss: Bool = true
    
    // MARK: - Views
    var alertView: UIView!
    var actions = [CCAction]()
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    var initialAlertViewFrame: CGRect!
    var alertViewHeight: CGFloat {
        return (CGFloat(self.actions.count) * (self.buttonHeight + self.interButtonSpace)) + self.stackViewTopPadding + self.stackViewBottomPadding
    }
    
    // MARK: - Initializers
    private override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.customInit()
    }
    
    public init(isGestureDismiss: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.customInit()
        self.isGestureDismiss = isGestureDismiss
    }
    
    private func customInit() {
        modalPresentationStyle = .overCurrentContext
        UIView.setAnimationsEnabled(false)
    }
    
    // MARK: - Controller's lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackgroundView()
        self.setupAlertView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showController()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(true)
    }
    
    public func addActions(_ actions: [CCAction]) {
        self.actions.unsheft(contentsOf: actions)
    }
    
    // MARK: - Setups
    private func setupBackgroundView() {
        self.view.backgroundColor = UIColor.clear
        self.backgroundView.backgroundColor = UIColor.black
        self.backgroundView.alpha = 0
        self.backgroundView.frame = view.frame
        if self.isGestureDismiss {
            self.backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        }
        self.view.addSubview(self.backgroundView)
        self.view.sendSubviewToBack(self.backgroundView)
    }
    
    private func setupAlertView() {
        self.alertView = UIView()
        self.alertView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.alertView.layer.cornerRadius = 12
        self.alertView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 12)
        self.alertView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerHandler(_:))))
        self.view.addSubview(self.alertView)
        
        self.setAlertViewConstraints()
        self.setAlertViewContentConstraints()
    }
    
    private func reloadAlertViewConstraints() {
        
    }
    
    private func setAlertViewConstraints() {
        self.alertView.translatesAutoresizingMaskIntoConstraints = false
        self.alertView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        self.alertView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        self.alertView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height - self.alertViewHeight).isActive = true
        self.alertView.transform = CGAffineTransform(translationX: 0, y: self.alertViewHeight)
    }
    
    private func setAlertViewContentConstraints() {
        for button in self.actions {
            self.stackView.addArrangedSubview(button)
        }
        self.stackView.axis = .vertical
        self.stackView.spacing = self.interButtonSpace
        self.stackView.alignment = .fill
        self.stackView.distribution = .fillEqually
        self.alertView.addSubview(self.stackView)
        self.alertView.addSubview(self.handleView)
        
        self.setHandleViewConstraints()
        self.setStackViewConstraints()
    }
    
    private func setStackViewConstraints() {
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.leadingAnchor.constraint(equalTo: self.alertView.leadingAnchor, constant: self.stackViewLeadingPadding).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.alertView.trailingAnchor, constant: -self.stackViewTrailingPadding).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.alertView.topAnchor, constant: self.stackViewTopPadding).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: self.alertViewHeight - self.stackViewTopPadding - self.stackViewBottomPadding).isActive = true
    }
    
    private func setHandleViewConstraints() {
        self.handleView.translatesAutoresizingMaskIntoConstraints = false
        self.handleView.centerXAnchor.constraint(equalTo: self.alertView.centerXAnchor).isActive = true
        self.handleView.widthAnchor.constraint(equalTo: self.alertView.widthAnchor, multiplier: 0.2).isActive = true
        self.handleView.heightAnchor.constraint(equalToConstant: 6).isActive = true
        self.handleView.topAnchor.constraint(equalTo: self.alertView.topAnchor, constant: 8).isActive = true
    }
    
    // MARK: - Actions
    @objc func dismissAlert() {
        self.hideController { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: false, completion: nil)
        }
    }

    public func dismissActionSheet() {
        self.dismissAlert()
    }
}
