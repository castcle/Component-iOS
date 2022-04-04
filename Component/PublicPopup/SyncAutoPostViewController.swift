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
//  SyncAutoPostViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 1/4/2565 BE.
//

import UIKit
import Core
import SwiftColor

class SyncAutoPostViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var popupView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var syncLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var checkImage: UIImageView!
    
    var viewModel = SyncTwitterAutoPostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.backgroundColor = UIColor.Asset.black
        self.popupView.custom(color: UIColor.Asset.white, cornerRadius: 10)
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.black
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.detailLabel.textColor = UIColor.Asset.black
        self.syncLabel.font = UIFont.asset(.bold, fontSize: .small)
        self.syncLabel.textColor = UIColor.Asset.black
        self.closeButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .h4)
        self.closeButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.closeButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.closeButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        self.updateCheckBox()
    }
    
    private func updateCheckBox() {
        if self.viewModel.isSync {
            self.checkImage.image = UIImage.init(icon: .castcle(.checkmark), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue)
            self.checkImage.custom(cornerRadius: 2, borderWidth: 1, borderColor: UIColor.Asset.gray)
        } else {
            self.checkImage.image = UIImage()
            self.checkImage.custom(cornerRadius: 2, borderWidth: 1, borderColor: UIColor.Asset.gray)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        if self.viewModel.isSync {
            self.viewModel.syncSocial()
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func checkAction(_ sender: Any) {
        self.viewModel.isSync.toggle()
        self.updateCheckBox()
    }
}
