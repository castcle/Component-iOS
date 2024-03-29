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
//  QuoteCastImageX2Cell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 17/8/2564 BE.
//

import UIKit
import Core
import Networking
import RealmSwift

public class QuoteCastImageX2Cell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var verifyIcon: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var lineView: UIView!
    @IBOutlet var massageLabel: AttributedLabel!
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var verifyConstraintWidth: NSLayoutConstraint!
    @IBOutlet var moreButton: UIButton!

    var viewModel: QuoteCastViewModel?
    public var content: Content? {
        didSet {
            if let content = self.content {
                guard let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) else { return }
                self.viewModel = QuoteCastViewModel(content: content)
                self.massageLabel.numberOfLines = 0
                self.massageLabel.isSelectable = true
                self.massageLabel.attributedText = (content.message.isEmpty ? "" : "\(content.message)\n")
                    .styleHashtags(AttributedContent.link)
                    .styleMentions(AttributedContent.link)
                    .styleLinks(AttributedContent.link)
                    .styleAll(AttributedContent.quote)
                if content.photo.count >= 2 {
                    let firstUrl = URL(string: content.photo[0].thumbnail)
                    self.firstImageView.kf.setImage(with: firstUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
                    let secondUrl = URL(string: content.photo[1].thumbnail)
                    self.secondImageView.kf.setImage(with: secondUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
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
                        if let page = realm.objects(PageRealm.self).filter("castcleId = '\(authorRef.castcleId)'").first {
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
        self.imageContainer.custom(cornerRadius: 12)
        self.moreButton.setImage(UIImage.init(icon: .castcle(.ellipsisV), size: CGSize(width: 22, height: 22), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func followAction(_ sender: Any) {
        guard let viewModel = self.viewModel else { return }
        viewModel.followUser()
        self.followButton.isHidden = true
    }

    @IBAction func moreAction(_ sender: Any) {
        if let content = self.content {
            if !UserHelper.shared.isMyAccount(id: content.authorId) {
                let actionSheet = CCActionSheet()
                let reportButton = CCAction(title: Localization.ContentAction.reportCast.text, image: UIImage.init(icon: .castcle(.report), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                    actionSheet.dismissActionSheet()
                    if UserManager.shared.isLogin {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            let reportDict: [String: Any] = [
                                JsonKey.castcleId.rawValue: "",
                                JsonKey.contentId.rawValue: content.id
                            ]
                            NotificationCenter.default.post(name: .openReportDelegate, object: nil, userInfo: reportDict)
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
                        }
                    }
                }
                actionSheet.addActions([reportButton])
                actionSheet.modalPresentationStyle  = .overFullScreen
                Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
            }
        }
    }
}
