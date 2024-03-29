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
//  TextLinkPreviewTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 9/9/2564 BE.
//

import UIKit
import Core
import Networking
import SkeletonView

public class TextLinkPreviewTableViewCell: UITableViewCell {

    @IBOutlet var massageLabel: AttributedLabel!
    @IBOutlet var linkContainer: UIView!
    @IBOutlet var titleLinkView: UIView!
    @IBOutlet var linkImage: UIImageView!
    @IBOutlet var linkTitleLabel: UILabel!
    @IBOutlet var linkDescriptionLabel: UILabel!
    @IBOutlet var skeletonView: UIView!
    @IBOutlet weak var defualtImage: UIImageView!

    public var content: Content? {
        didSet {
            guard let content = self.content else { return }
            self.massageLabel.numberOfLines = 0
            self.massageLabel.isSelectable = true
            self.massageLabel.attributedText = content.message
                .styleHashtags(AttributedContent.link)
                .styleMentions(AttributedContent.link)
                .styleLinks(AttributedContent.link)
                .styleAll(AttributedContent.all)
            self.enableActiveLabel()
            self.skeletonView.isHidden = false
            self.linkContainer.isHidden = true
            if let link = content.link.first {
                self.setData(content: content, link: link)
            }
        }
    }

    private func enableActiveLabel() {
        self.massageLabel.onClick = { _, detection in
            switch detection.type {
            case .hashtag(let tag):
                let hashtagDict: [String: String] = [
                    JsonKey.hashtag.rawValue: "#\(tag)"
                ]
                NotificationCenter.default.post(name: .openSearchDelegate, object: nil, userInfo: hashtagDict)
            case .mention(let name):
                let userDict: [String: String] = [
                    JsonKey.castcleId.rawValue: name.toCastcleId
                ]
                NotificationCenter.default.post(name: .openProfileDelegate, object: nil, userInfo: userDict)
            case .link(let url):
                var urlString = url.absoluteString
                urlString = urlString.replacingOccurrences(of: UrlProtocol.https.value, with: "")
                urlString = urlString.replacingOccurrences(of: UrlProtocol.http.value, with: "")
                if let newUrl = URL(string: "\(UrlProtocol.https.value)\(urlString)") {
                    Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(newUrl)), animated: true)
                } else {
                    return
                }
            default:
                return
            }
        }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.skeletonView.custom(cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.lineGray)
        self.linkContainer.custom(cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.lineGray)
        self.linkContainer.backgroundColor = UIColor.Asset.cellBackground
        self.titleLinkView.backgroundColor = UIColor.Asset.cellBackground
        self.linkTitleLabel.font = UIFont.asset(.contentLight, fontSize: .small)
        self.linkTitleLabel.textColor = UIColor.Asset.white
        self.linkDescriptionLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.linkDescriptionLabel.textColor = UIColor.Asset.white
        self.skeletonView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.Asset.gray))
        self.defualtImage.image = UIImage.Asset.placeholder
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setData(content: Content, link: Link) {
        UIView.transition(with: self, duration: 0.35, options: .transitionCrossDissolve, animations: {
            self.skeletonView.isHidden = true
            self.linkContainer.isHidden = false
        })

        // MARK: - Image
        let url = URL(string: link.imagePreview)
        self.linkImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])

        // MARK: - Title
        if link.title.isEmpty {
            self.linkTitleLabel.text = ""
        } else {
            self.linkTitleLabel.text = link.title
        }

        // MARK: - Description
        if link.desc.isEmpty {
            self.linkDescriptionLabel.text = content.message
        } else {
            self.linkDescriptionLabel.text = link.desc
        }
    }

    @IBAction func openWebViewAction(_ sender: Any) {
        guard let content = self.content else { return }
        if let link = content.link.first, let linkUrl = URL(string: link.url) {
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(linkUrl)), animated: true)
        }
    }
}
