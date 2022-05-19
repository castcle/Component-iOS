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
//  ReactionCastTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 13/5/2565 BE.
//

import UIKit
import Core
import Networking
import ActiveLabel

class ReactionCastTableViewCell: UITableViewCell {

    @IBOutlet var reactionLabel: ActiveLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(content: Content) {
        var reactionArray: [String] = []
        if content.metrics.likeCount != 0 {
            reactionArray.append("\(content.metrics.likeCount) Likes")
        }
        if content.metrics.recastCount != 0 {
            reactionArray.append("\(content.metrics.recastCount) Recasts")
        }
        if content.metrics.quoteCount != 0 {
            reactionArray.append("\(content.metrics.quoteCount) Quote Casts")
        }

        self.reactionLabel.text = reactionArray.joined(separator: "    ")
        self.reactionLabel.customize { label in
            label.font = UIFont.asset(.medium, fontSize: .overline)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.white
            let likesType = ActiveType.custom(pattern: "\(content.metrics.likeCount) Likes")
            let recastsType = ActiveType.custom(pattern: "\(content.metrics.recastCount) Recasts")
            let quoteCastsType = ActiveType.custom(pattern: "\(content.metrics.quoteCount) Quote Casts")
            label.enabledTypes = [likesType, recastsType, quoteCastsType]
            label.customColor[likesType] = UIColor.Asset.white
            label.customSelectedColor[likesType] = UIColor.Asset.gray
            label.customColor[recastsType] = UIColor.Asset.white
            label.customSelectedColor[recastsType] = UIColor.Asset.gray
            label.customColor[quoteCastsType] = UIColor.Asset.white
            label.customSelectedColor[quoteCastsType] = UIColor.Asset.gray
            label.handleCustomTap(for: likesType) { _ in
                let viewController = ComponentOpener.open(.reaction(content, .like)) as? ReactionViewController
                Utility.currentViewController().present(viewController ?? ReactionViewController(), animated: true)
            }
            label.handleCustomTap(for: recastsType) { _ in
                let viewController = ComponentOpener.open(.reaction(content, .recast)) as? ReactionViewController
                Utility.currentViewController().present(viewController ?? ReactionViewController(), animated: true)
            }
            label.handleCustomTap(for: quoteCastsType) { _ in
                let contentDict: [String: String] = [
                    JsonKey.contentId.rawValue: content.id
                ]
                NotificationCenter.default.post(name: .openQuoteCastListDelegate, object: nil, userInfo: contentDict)
            }
        }
    }
}
