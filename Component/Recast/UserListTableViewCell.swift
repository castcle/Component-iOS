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
//  UserListTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 18/8/2564 BE.
//

import UIKit
import Core

class UserListTableViewCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var checkImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.nameLabel.font = UIFont.asset(.bold, fontSize: .overline)
        self.nameLabel.textColor = UIColor.Asset.white
        self.checkImage.image = UIImage.init(icon: .castcle(.checkmark), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.lightBlue)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(isUser: Bool, page: PageRealm?, isSelect: Bool) {
        if isUser {
            let url = URL(string: UserManager.shared.avatar)
            self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.nameLabel.text = UserManager.shared.displayName
        } else {
            guard let page = page else { return }
            let url = URL(string: page.avatar)
            self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.nameLabel.text = page.displayName
        }

        if isSelect {
            self.checkImage.isHidden = false
            self.backgroundColor = UIColor.Asset.cellBackground
        } else {
            self.checkImage.isHidden = true
            self.backgroundColor = UIColor.Asset.darkGraphiteBlue
        }
    }
}
