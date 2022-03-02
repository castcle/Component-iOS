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
//  AdsPageTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 4/2/2565 BE.
//

import UIKit
import Core
import ActiveLabel

public protocol AdsPageTableViewCellDelegate {
    func didAuthen(_ adsPageTableViewCell: AdsPageTableViewCell)
}

public class AdsPageTableViewCell: UITableViewCell {

    @IBOutlet var detailLabel: ActiveLabel!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var verifyIcon: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    
    public var delegate: AdsPageTableViewCellDelegate?
    private let customHashtag = ActiveType.custom(pattern: RegexpParser.hashtagPattern)
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.detailLabel.customize { label in
            label.font = UIFont.asset(.contentLight, fontSize: .body)
            label.numberOfLines = 0
            label.enabledTypes = [.mention, .url, self.customHashtag]
            label.textColor = UIColor.Asset.white
            label.mentionColor = UIColor.Asset.lightBlue
            label.URLColor = UIColor.Asset.lightBlue
            label.customColor[self.customHashtag] = UIColor.Asset.lightBlue
            label.customSelectedColor[self.customHashtag] = UIColor.Asset.lightBlue
        }
        
        self.verifyIcon.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.coverImageView.custom(cornerRadius: 10)
        self.coverImageView.image = UIImage.Asset.placeholder
        self.avatarImageView.circle()
        self.avatarImageView.image = UIImage.Asset.userPlaceholder
        self.displayNameLabel.font = UIFont.asset(.bold, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.overviewLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.overviewLabel.textColor = UIColor.Asset.white
        self.followButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.followButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.followButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.followButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        self.enableActiveLabel()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
    
    @IBAction func followAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            let alert = UIAlertController(title: "Error", message: "Waiting for implementation", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            Utility.currentViewController().present(alert, animated: true, completion: nil)
        } else {
            self.delegate?.didAuthen(self)
        }
    }
}
