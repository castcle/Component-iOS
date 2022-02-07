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
//  TextTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 9/9/2564 BE.
//

import UIKit
import Core
import Networking
import ActiveLabel

public class TextTableViewCell: UITableViewCell {

    @IBOutlet var detailLabel: ActiveLabel!
    
    private let customHashtag = ActiveType.custom(pattern: RegexpParser.hashtagPattern)
    public var content: Content? {
        didSet {
            guard let content = self.content else { return }
            
            self.detailLabel.customize { label in
                let readMoreType = ActiveType.custom(pattern: "\(Localization.contentDetail.readMore.text)")
                label.font = UIFont.asset(.contentLight, fontSize: .body)
                label.numberOfLines = 0
                label.enabledTypes = [.mention, .url, self.customHashtag, readMoreType]
                label.textColor = UIColor.Asset.white
                label.mentionColor = UIColor.Asset.lightBlue
                label.URLColor = UIColor.Asset.lightBlue
                label.customColor[self.customHashtag] = UIColor.Asset.lightBlue
                label.customSelectedColor[self.customHashtag] = UIColor.Asset.lightBlue
                label.customColor[readMoreType] = UIColor.Asset.lightBlue
                label.customSelectedColor[readMoreType] = UIColor.Asset.lightBlue
            }
            
            self.detailLabel.text = content.message
            self.enableActiveLabel()
        }
    }
    
    private func enableActiveLabel() {
        self.detailLabel.handleHashtagTap { hashtag in
        }
        self.detailLabel.handleMentionTap { mention in
        }
        self.detailLabel.handleURLTap { url in
            var urlString = url.absoluteString
            urlString = urlString.replacingOccurrences(of: "https://", with: "")
            urlString = urlString.replacingOccurrences(of: "http://", with: "")
            if let newUrl = URL(string: "https://\(urlString)") {
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(newUrl)), animated: true)
            } else {
                return
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
