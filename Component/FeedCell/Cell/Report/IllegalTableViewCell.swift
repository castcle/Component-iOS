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
//  IllegalTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 9/8/2565 BE.
//

import UIKit
import Core
import Networking
import ActiveLabel

public class IllegalTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var blockImage: UIImageView!
    @IBOutlet weak var illegalTitleLabel: UILabel!
    @IBOutlet weak var illegalDetailLabel: ActiveLabel!
    @IBOutlet weak var illegalView: UIView!
    @IBOutlet weak var illegalImage: UIImageView!

    private let customTerms = ActiveType.custom(pattern: "Castcle Terms and Agreement")
    private let customContact = ActiveType.custom(pattern: "Contact Castcle")

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.illegalView.custom(cornerRadius: 12)
        self.illegalImage.custom(cornerRadius: 12)
        self.blockImage.image = UIImage.init(icon: .castcle(.blockedUsers), size: CGSize(width: 50, height: 50), textColor: UIColor.Asset.white)
        self.contentLabel.font = UIFont.asset(.contentLight, fontSize: .body)
        self.contentLabel.textColor = UIColor.Asset.textGray
        self.illegalTitleLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.illegalTitleLabel.textColor = UIColor.Asset.white
        self.illegalDetailLabel.customize { label in
            label.font = UIFont.asset(.contentLight, fontSize: .overline)
            label.numberOfLines = 0
            label.enabledTypes = [self.customTerms, self.customContact]
            label.textColor = UIColor.Asset.white
            label.customColor[self.customTerms] = UIColor.Asset.lightBlue
            label.customSelectedColor[self.customTerms] = UIColor.Asset.lightBlue
            label.customColor[self.customContact] = UIColor.Asset.lightBlue
            label.customSelectedColor[self.customContact] = UIColor.Asset.lightBlue
        }
        self.illegalDetailLabel.handleCustomTap(for: self.customTerms) { _ in
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: Environment.userAgreement)!)), animated: true)
        }
        self.illegalDetailLabel.handleCustomTap(for: self.customContact) { _ in
            if let url = URL(string: "mailto:\(CastcleSocial.email.path)") {
                UIApplication.shared.open(url)
            }
        }
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func configCell(content: Content) {
        self.contentLabel.text = (content.message.isEmpty ? "" : "\(content.message)\n")
        if content.feedDisplayType == .postImageX1 || content.feedDisplayType == .postImageX2 || content.feedDisplayType == .postImageX3 || content.feedDisplayType == .postImageXMore {
            self.illegalImage.isHidden = false
        } else {
            self.illegalImage.isHidden = true
        }
    }
}
