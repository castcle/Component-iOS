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
//  CCAction.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 15/10/2564 BE.
//

import UIKit
import Core

public class CCAction: UIView {
    
    private let leftButtonPadding: CGFloat = 8
    private let imageViewWidth: CGFloat = 20
    private let interImageTitleSpace: CGFloat = 20
    
    private var button = UIButton()
    private var imageView = UIImageView()
    
    private var onTapCompletion: (()->Void)?
    private var isCancelButton: Bool
    private var _style: CCAction.Style
    
    public override var bounds: CGRect {
        didSet {
            if self.isCancelButton {
                self.layer.cornerRadius = self.frame.height/2
                self.layer.masksToBounds = true
            }
        }
    }
    public var style: CCAction.Style { return self._style }
    
    // MARK: - Initializers
    private override init(frame: CGRect) {
        self.isCancelButton = false
        self.onTapCompletion = nil
        self._style = .default
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(title: String, image: UIImage? = nil, style: CCAction.Style = .default, completion: @escaping ()->Void) {
        self.init()
        self.button.setTitle(title, for: .normal)
        self.button.titleLabel?.font =  UIFont.asset(.bold, fontSize: .body)
        self.imageView.image = image
        self.onTapCompletion = completion
        self.isCancelButton = false
        self._style = style
        self.setupView()
    }
    
    convenience init(title: String, completion: @escaping ()->Void) {
        self.init()
        self.button.setTitle(title, for: .normal)
        self.onTapCompletion = completion
        self.isCancelButton = true
        self.setupView()
    }
    
    // MARK: - Setups
    private func setupView() {
        self.button.setTitleColor(style == .default ? UIColor.Asset.white : UIColor.Asset.denger, for: .normal)
        self.addSubview(self.button)
        self.setButtonConstraints()
        if !self.isCancelButton {
            self.setupNotCancelView()
        } else {
            self.setupCancelButton()
        }
        
        self.setButtonAction()
    }
    
    private func setupCancelButton() {
        self.backgroundColor = UIColor.Asset.darkGray
    }
    
    private func setupNotCancelView() {
        if #available(iOS 11.0, *) {
            self.button.contentHorizontalAlignment = .leading
        } else {
            self.button.contentHorizontalAlignment = .left
        }
        self.button.imageView?.contentMode = .scaleAspectFit
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = self.imageView.image?.withRenderingMode(.alwaysTemplate)
        self.imageView.tintColor = self.style == .default ? UIColor.Asset.white : UIColor.Asset.denger
        self.addSubview(self.imageView)
        self.bringSubviewToFront(self.button)
        self.setImageViewConstraints()
        self.button.titleEdgeInsets = UIEdgeInsets(top: 0, left: self.leftButtonPadding + self.imageViewWidth + self.interImageTitleSpace, bottom: 0, right: 0)
    }
    
    private func setButtonConstraints() {
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        self.button.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        self.button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.button.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    private func setImageViewConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: self.leftButtonPadding).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: self.imageViewWidth).isActive = true
    }
    
    private func setButtonAction() {
        self.button.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
    }
    
    @objc private func buttonAction(_ sender: Any) {
        self.onTapCompletion?()
    }
    
}
