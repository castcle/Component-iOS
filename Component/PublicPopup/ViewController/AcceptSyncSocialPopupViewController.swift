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
//  AcceptSyncSocialPopupViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 7/4/2565 BE.
//

import UIKit
import Core

class AcceptSyncSocialPopupViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var popupView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var socialAvatarImage: UIImageView!
    @IBOutlet var castcleAvatarImage: UIImageView!
    @IBOutlet var socialNameLabel: UILabel!
    @IBOutlet var socialIdLabel: UILabel!
    @IBOutlet var castcleNameLabel: UILabel!
    @IBOutlet var castcleIdLabel: UILabel!
    @IBOutlet var sicialIconView: UIView!
    @IBOutlet var socialIcon: UIImageView!
    @IBOutlet var castcleIconView: UIView!
    @IBOutlet var castcleIcon: UIImageView!
    @IBOutlet var nextIcon: UIImageView!

    var viewModel = AcceptSyncSocialPopupViewModel(socialType: .unknow)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.backgroundColor = UIColor.Asset.black
        self.popupView.custom(color: UIColor.Asset.white, cornerRadius: 10)
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.black
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.detailLabel.textColor = UIColor.Asset.black
        self.closeButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .head4)
        self.closeButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.closeButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.closeButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        self.socialNameLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.socialNameLabel.textColor = UIColor.Asset.black
        self.socialIdLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.socialIdLabel.textColor = UIColor.Asset.lightGray
        self.castcleNameLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.castcleNameLabel.textColor = UIColor.Asset.black
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.castcleIdLabel.textColor = UIColor.Asset.lightGray
        self.socialAvatarImage.circle(color: UIColor.Asset.white)
        self.socialAvatarImage.image = UIImage.Asset.userPlaceholder
        self.castcleAvatarImage.circle(color: UIColor.Asset.white)
        self.castcleAvatarImage.image = UIImage.Asset.userPlaceholder

        let socialUsername: String = (self.viewModel.pageSocial.userName.isEmpty ? "" : self.viewModel.pageSocial.userName)
        self.sicialIconView.capsule(color: self.viewModel.socialType.color, borderWidth: 2, borderColor: UIColor.Asset.white)
        self.castcleIconView.capsule(color: UIColor.Asset.black, borderWidth: 2, borderColor: UIColor.Asset.white)
        self.socialIcon.image = self.viewModel.socialType.icon
        self.castcleIcon.image = UIImage.init(icon: .castcle(.logo), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white)
        self.nextIcon.image = UIImage.init(icon: .castcle(.bindLink), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.black)

        let castcleAvatarUrl = URL(string: self.viewModel.userInfo.images.avatar.thumbnail)
        self.castcleAvatarImage.kf.setImage(with: castcleAvatarUrl, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.castcleNameLabel.text = self.viewModel.userInfo.displayName
        self.castcleIdLabel.text = "@\(self.viewModel.userInfo.castcleId)"

        let socialAvatarUrl = URL(string: self.viewModel.pageSocial.avatar)
        self.socialAvatarImage.kf.setImage(with: socialAvatarUrl, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.socialNameLabel.text = self.viewModel.pageSocial.displayName
        self.socialIdLabel.text = (socialUsername.isEmpty ? "" : "@\(self.viewModel.pageSocial.userName)")

        let displaySocialName: String = (socialUsername.isEmpty ? self.viewModel.pageSocial.displayName : "@\(self.viewModel.pageSocial.userName)")
        self.detailLabel.text = "Your \(self.viewModel.socialType.display) account (\(displaySocialName)) is linked to your Castcle Profile (@\(self.viewModel.userInfo.castcleId)). By continuing, your Twitter will no longer auto-post to (@\(self.viewModel.userInfo.castcleId)) and will now auto-post to your new Page."
    }

    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
