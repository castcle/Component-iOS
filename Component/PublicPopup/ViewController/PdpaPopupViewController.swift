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
//  PdpaPopupViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 27/6/2565 BE.
//

import UIKit
import Core
import ActiveLabel

class PdpaPopupViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var popupView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: ActiveLabel!
    @IBOutlet var closeButton: UIButton!

    var viewModel = PdpaPopupViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.backgroundColor = UIColor.Asset.black
        self.popupView.custom(color: UIColor.Asset.white, cornerRadius: 10)
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.black
        self.closeButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        self.closeButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.closeButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.closeButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        self.detailLabel.customize { label in
            label.font = UIFont.asset(.regular, fontSize: .overline)
            label.numberOfLines = 0
            label.textColor = UIColor.Asset.black
            let policyType = ActiveType.custom(pattern: "Privacy Policy")
            let contactType = ActiveType.custom(pattern: "Contact Castcle")
            label.enabledTypes = [contactType, policyType]
            label.customColor[contactType] = UIColor.Asset.lightBlue
            label.customColor[policyType] = UIColor.Asset.lightBlue
            label.customSelectedColor[contactType] = UIColor.Asset.lightGray
            label.customSelectedColor[policyType] = UIColor.Asset.lightGray
            label.handleCustomTap(for: contactType) { _ in
                if let url = URL(string: "mailto:\(CastcleSocial.email.path)") {
                    UIApplication.shared.open(url)
                }
            }
            label.handleCustomTap(for: policyType) { _ in
                self.dismiss(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: Environment.privacyPolicy)!)), animated: true)
                }
            }
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        self.viewModel.acceptPdpa()
        self.dismiss(animated: true)
    }
}
