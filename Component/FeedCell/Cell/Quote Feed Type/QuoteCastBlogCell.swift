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
//  QuoteCastBlogCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 17/8/2564 BE.
//

import UIKit
import Core
import Networking
import Nantes
import RealmSwift

public class QuoteCastBlogCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var verifyIcon: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var lineView: UIView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var detailLabel: NantesLabel!
    @IBOutlet var blogImageView: UIImageView!
    @IBOutlet var verifyConstraintWidth: NSLayoutConstraint!

    var viewModel: QuoteCastViewModel?
    public var content: Content? {
        didSet {
            if let content = self.content {
                let attributes = [NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue,
                                  NSAttributedString.Key.font: UIFont.asset(.contentLight, fontSize: .overline)]
                self.detailLabel.attributedTruncationToken = NSAttributedString(string: " \(Localization.ContentDetail.readMore.text)", attributes: attributes)
                self.detailLabel.numberOfLines = 2
                guard let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) else { return }
                self.viewModel = QuoteCastViewModel(content: content)
                self.detailLabel.text = content.message
                self.headerLabel.font = UIFont.asset(.contentBold, fontSize: .head4)
                self.headerLabel.textColor = UIColor.Asset.white
                self.detailLabel.font = UIFont.asset(.contentLight, fontSize: .overline)
                self.detailLabel.textColor = UIColor.Asset.lightGray
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
            } else {
                return
            }
        }
    }

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
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func followAction(_ sender: Any) {
        guard let viewModel = self.viewModel else { return }
        viewModel.followUser()
        self.followButton.isHidden = true
    }
}
