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
//  ActivityHeaderTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 19/11/2564 BE.
//

import UIKit
import Core
import Networking

public class ActivityHeaderTableViewCell: UITableViewCell {

    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.detailLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.detailLabel.textColor = UIColor.Asset.lightGray
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func cellConfig(content: Content) {
        if content.isRecast {
            if content.author.castcleId == UserManager.shared.rawCastcleId {
                self.detailLabel.text = "You Recasted"
            } else {
                self.detailLabel.text = "\(content.author.displayName) Recasted"
            }
            
            self.iconImage.image = UIImage.init(icon: .castcle(.recast), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray)
        } else {
            self.iconImage.image = UIImage.init(icon: .castcle(.quoteCast), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray)
        }
    }
}
