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
//  BlogTableViewCell.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 9/9/2564 BE.
//

import UIKit
import Core
import Networking
import Kingfisher
import Nantes

class BlogTableViewCell: UITableViewCell {

    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var detailLabel: NantesLabel! {
        didSet {
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue,
                              NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body)]
            self.detailLabel.attributedTruncationToken = NSAttributedString(string: " Read More...", attributes: attributes)
            self.detailLabel.numberOfLines = 2
        }
    }
    @IBOutlet var blogImageView: UIImageView!
    var feed: Feed? {
        didSet {
            guard let feed = self.feed else { return }
            self.headerLabel.font = UIFont.asset(.medium, fontSize: .h3)
            self.headerLabel.textColor = UIColor.Asset.white
            self.detailLabel.font = UIFont.asset(.regular, fontSize: .body)
            self.detailLabel.textColor = UIColor.Asset.lightGray
            
            self.headerLabel.text = feed.feedPayload.contentPayload.header
            self.detailLabel.text = feed.feedPayload.contentPayload.content
            
            let imageUrl = URL(string: feed.feedPayload.contentPayload.cover)
            self.blogImageView.kf.setImage(with: imageUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.5))])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
