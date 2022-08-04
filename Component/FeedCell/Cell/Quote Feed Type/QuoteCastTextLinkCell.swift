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
//  QuoteCastTextLinkCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 17/8/2564 BE.
//

import UIKit
import LinkPresentation
import Core
import Networking
import SkeletonView
import RealmSwift

public class QuoteCastTextLinkCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var verifyIcon: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var lineView: UIView!
    @IBOutlet var massageLabel: AttributedLabel!
    @IBOutlet var linkContainer: UIView!
    @IBOutlet var titleLinkView: UIView!
    @IBOutlet var linkImage: UIImageView!
    @IBOutlet var linkTitleLabel: UILabel!
    @IBOutlet var linkDescriptionLabel: UILabel!
    @IBOutlet var skeletonView: UIView!
    @IBOutlet var verifyConstraintWidth: NSLayoutConstraint!

    var viewModel: QuoteCastViewModel?

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.bold, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.dateLabel.font = UIFont.asset(.regular, fontSize: .custom(size: 10))
        self.dateLabel.textColor = UIColor.Asset.lightGray
        self.followButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .overline)
        self.followButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.verifyIcon.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.lineView.custom(color: UIColor.clear, cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.lightGray)
        self.linkContainer.custom(color: UIColor.Asset.darkGraphiteBlue, cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.black)
        self.skeletonView.custom(cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.gray)
        self.linkContainer.custom(cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.gray)
        self.titleLinkView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.linkTitleLabel.font = UIFont.asset(.contentBold, fontSize: .overline)
        self.linkTitleLabel.textColor = UIColor.Asset.white
        self.linkDescriptionLabel.font = UIFont.asset(.contentLight, fontSize: .small)
        self.linkDescriptionLabel.textColor = UIColor.Asset.lightGray
        self.skeletonView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.Asset.gray))
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func configCell(content: Content?) {
        guard let content = content else { return }
        guard let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) else { return }
        self.viewModel = QuoteCastViewModel(content: content)
        self.massageLabel.numberOfLines = 0
        self.massageLabel.isSelectable = true
        self.massageLabel.attributedText = content.message
            .styleHashtags(AttributedContent.link)
            .styleMentions(AttributedContent.link)
            .styleLinks(AttributedContent.link)
            .styleAll(AttributedContent.quote)
        self.skeletonView.isHidden = false
        self.linkContainer.isHidden = true
        if let link = content.link.first {
            var title: String = ""
            var desc: String = ""
            if link.title.isEmpty && link.desc.isEmpty {
                title = content.message
                desc = ""
            } else {
                title = link.title
                desc = link.desc
            }
            self.setDataWithContent(icon: link.type.image, title: title, desc: desc)
        }

        if authorRef.type == AuthorType.people.rawValue {
            if authorRef.castcleId == UserManager.shared.castcleId {
                let url = URL(string: UserManager.shared.avatar)
                self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
                self.followButton.isHidden = true
            } else {
                let url = URL(string: authorRef.avatar)
                self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
                if authorRef.followed {
                    self.followButton.isHidden = true
                } else {
                    self.followButton.isHidden = false
                }
            }
        } else {
            do {
                let realm = try Realm()
                if let page = realm.objects(Page.self).filter("castcleId = '\(authorRef.castcleId)'").first {
                    let url = URL(string: page.avatar)
                    self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
                    self.followButton.isHidden = true
                } else {
                    let url = URL(string: authorRef.avatar)
                    self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
                    if authorRef.followed {
                        self.followButton.isHidden = true
                    } else {
                        self.followButton.isHidden = false
                    }
                }
            } catch {}
        }

        self.displayNameLabel.text = authorRef.displayName
        self.dateLabel.text = content.postDate.timeAgoDisplay()
        if authorRef.official {
            self.verifyConstraintWidth.constant = 15.0
            self.verifyIcon.isHidden = false
        } else {
            self.verifyConstraintWidth.constant = 0.0
            self.verifyIcon.isHidden = true
        }
    }

    private func setDataWithContent(icon: UIImage, title: String, desc: String) {
        self.skeletonView.isHidden = true
        self.linkContainer.isHidden = false
        self.linkImage.image = icon
        self.linkTitleLabel.text = title
        self.linkDescriptionLabel.text = desc
    }

    @IBAction func followAction(_ sender: Any) {
        guard let viewModel = self.viewModel else { return }
        viewModel.followUser()
        self.followButton.isHidden = true
    }
}
