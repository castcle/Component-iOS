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
import Networking
import Kingfisher

public protocol AdsPageTableViewCellDelegate: AnyObject {
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
    var isPreview: Bool = false

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

        self.avatarImageView.circle(color: UIColor.Asset.white)
        self.verifyIcon.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.coverImageView.custom(cornerRadius: 10)
        self.coverImageView.image = UIImage.Asset.placeholder
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

    public func configAdsPreViewCell(page: Page, adsRequest: AdsRequest) {
        self.isPreview = true
        self.followButton.isHidden = false
        if !adsRequest.campaignMessage.isEmpty {
            self.detailLabel.text = "\(adsRequest.campaignMessage)\n"
        } else {
            self.detailLabel.text = adsRequest.campaignMessage
        }
        let avatar = URL(string: page.avatar)
        let cover = URL(string: page.cover)
        self.avatarImageView.kf.setImage(with: avatar, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.coverImageView.kf.setImage(with: cover, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
        self.displayNameLabel.text = page.displayName
        self.overviewLabel.text = page.overview
        if page.official {
            self.verifyIcon.isHidden = false
        } else {
            self.verifyIcon.isHidden = true
        }
    }

    private func enableActiveLabel() {
        self.detailLabel.handleMentionTap { mention in
            let userDict: [String: String] = [
                JsonKey.castcleId.rawValue: mention.toCastcleId
            ]
            NotificationCenter.default.post(name: .openProfileDelegate, object: nil, userInfo: userDict)
        }
        self.detailLabel.handleURLTap { url in
            if self.isPreview {
                return
            }
            var urlString = url.absoluteString
            urlString = urlString.replacingOccurrences(of: UrlProtocol.https.value, with: "")
            urlString = urlString.replacingOccurrences(of: UrlProtocol.http.value, with: "")
            if let newUrl = URL(string: "\(UrlProtocol.https.value)\(urlString)") {
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(newUrl)), animated: true)
            }
        }
        self.detailLabel.handleCustomTap(for: self.customHashtag) { element in
            let hashtagDict: [String: String] = [
                JsonKey.hashtag.rawValue: element
            ]
            NotificationCenter.default.post(name: .openSearchDelegate, object: nil, userInfo: hashtagDict)
        }
    }

    @IBAction func followAction(_ sender: Any) {
        if self.isPreview {
            return
        }
        if UserManager.shared.isLogin {
            let alert = UIAlertController(title: "Error", message: "Waiting for implementation", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            Utility.currentViewController().present(alert, animated: true, completion: nil)
        } else {
            self.delegate?.didAuthen(self)
        }
    }
}
