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
//  HeaderTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 7/9/2564 BE.
//

import UIKit
import Core
import Networking
import SnackBar
import Kingfisher
import RealmSwift

public protocol HeaderTableViewCellDelegate: AnyObject {
    func didRemoveSuccess(_ headerTableViewCell: HeaderTableViewCell)
    func didReport(_ headerTableViewCell: HeaderTableViewCell, contentId: String)
}

public class HeaderTableViewCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var globalIcon: UIImageView!
    @IBOutlet var verifyIcon: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var verifyConstraintWidth: NSLayoutConstraint!

    public var delegate: HeaderTableViewCellDelegate?
    private var userRepository: UserRepository = UserRepositoryImpl()
    private var contentRepository: ContentRepository = ContentRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    private var state: State = .none
    private var userRequest: UserRequest = UserRequest()
    var isPreview: Bool = false
    private var content: Content?

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.tokenHelper.delegate = self
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.bold, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.dateLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.dateLabel.textColor = UIColor.Asset.lightGray
        self.followButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .overline)
        self.followButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.verifyIcon.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.globalIcon.image = UIImage.init(icon: .castcle(.global), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightGray)
        self.moreButton.setImage(UIImage.init(icon: .castcle(.ellipsisV), size: CGSize(width: 22, height: 22), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func configCell(type: FeedType, content: Content, isDefaultContent: Bool) {
        self.isPreview = false
        self.content = content
        if let content = self.content {
            self.followButton.setTitle(Localization.ContentDetail.follow.text, for: .normal)
            if let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
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
                        if let page = realm.objects(Page.self).filter("id = '\(content.authorId)'").first {
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
                if isDefaultContent {
                    self.dateLabel.text = "Introduction"
                } else if type == .ads {
                    self.dateLabel.text = "Advertised"
                } else {
                    self.dateLabel.text = content.postDate.timeAgoDisplay()
                }

                if authorRef.official {
                    self.verifyConstraintWidth.constant = 15.0
                    self.verifyIcon.isHidden = false
                } else {
                    self.verifyConstraintWidth.constant = 0.0
                    self.verifyIcon.isHidden = true
                }
            } else {
                self.avatarImage.image = UIImage.Asset.userPlaceholder
                if isDefaultContent {
                    self.dateLabel.text = "Introduction"
                } else if type == .ads {
                    self.dateLabel.text = "Advertised"
                }
                self.displayNameLabel.text = "Castcle"
            }
        } else {
            self.avatarImage.image = UIImage.Asset.userPlaceholder
            if isDefaultContent {
                self.dateLabel.text = "Introduction"
            } else if type == .ads {
                self.dateLabel.text = "Advertised"
            }
            self.displayNameLabel.text = "Castcle"
        }
    }

    public func configAdsPreViewCell(page: Page) {
        self.isPreview = true
        self.followButton.setTitle(Localization.ContentDetail.follow.text, for: .normal)
        let url = URL(string: page.avatar)
        self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        self.followButton.isHidden = true
        self.displayNameLabel.text = page.displayName
        self.dateLabel.text = "Advertised"
        if page.official {
            self.verifyConstraintWidth.constant = 15.0
            self.verifyIcon.isHidden = false
        } else {
            self.verifyConstraintWidth.constant = 0.0
            self.verifyIcon.isHidden = true
        }
    }

    @IBAction func followAction(_ sender: Any) {
        if self.isPreview {
            return
        }
        if !UserManager.shared.isLogin {
            NotificationCenter.default.post(name: .openSignInDelegate, object: nil, userInfo: nil)
        } else if !UserManager.shared.isVerified {
            NotificationCenter.default.post(name: .openVerifyDelegate, object: nil, userInfo: nil)
        } else {
            guard let content = self.content else { return }
            if let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
                self.followButton.isHidden = true
                self.followUser()
                HeaderSnackBar.make(in: Utility.currentViewController().view, message: "\(Localization.ContentAction.followed.text) \(authorRef.castcleId)", duration: .lengthLong).setAction(with: Localization.ContentAction.undo.text, action: {
                    self.followButton.isHidden = false
                    self.unfollowUser()
                }).show()
            }
        }
    }

    @IBAction func viewProfileAction(_ sender: Any) {
        if self.isPreview {
            return
        }
        if let content = self.content, let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
            let userDict: [String: String] = [
                JsonKey.castcleId.rawValue: authorRef.castcleId,
                JsonKey.displayName.rawValue: authorRef.displayName
            ]
            NotificationCenter.default.post(name: .openProfileDelegate, object: nil, userInfo: userDict)
        }
    }

    @IBAction func moreAction(_ sender: Any) {
        if self.isPreview {
            return
        }
        if let content = self.content {
            if UserHelper.shared.isMyAccount(id: content.authorId) {
                let actionSheet = CCActionSheet()
                let deleteButton = CCAction(title: Localization.ContentAction.delete.text, image: UIImage.init(icon: .castcle(.delete), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                    actionSheet.dismissActionSheet()
                    self.deleteContent()
                }
                actionSheet.addActions([deleteButton])
                actionSheet.modalPresentationStyle  = .overFullScreen
                Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
            } else {
                let actionSheet = CCActionSheet()
                let reportButton = CCAction(title: Localization.ContentAction.reportCast.text, image: UIImage.init(icon: .castcle(.report), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .normal) {
                    actionSheet.dismissActionSheet()
                    if UserManager.shared.isLogin {
                        self.delegate?.didReport(self, contentId: content.id)
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

    private func deleteContent() {
        self.state = .deleteContent
        guard let content = self.content else { return }
        self.delegate?.didRemoveSuccess(self)
        self.contentRepository.deleteContent(contentId: content.id) { (success, _, isRefreshToken) in
            if !success && isRefreshToken {
                self.tokenHelper.refreshToken()
            }
        }
    }

    private func followUser() {
        self.state = .followUser
        guard let content = self.content else { return }
        if let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
            if content.referencedCasts.type == .recasted {
                if let tempContent = ContentHelper.shared.getContentRef(id: content.referencedCasts.id) {
                    self.userRequest.targetCastcleId = tempContent.authorId
                }
            } else {
                self.userRequest.targetCastcleId = authorRef.castcleId
            }
            do {
                let realm = try Realm()
                try realm.write {
                    authorRef.followed = true
                    realm.add(authorRef, update: .modified)
                    NotificationCenter.default.post(name: .feedReloadContent, object: nil)
                }
            } catch {}
            self.userRepository.follow(userRequest: self.userRequest) { (success, _, isRefreshToken) in
                if !success && isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    private func unfollowUser() {
        self.state = .unfollowUser
        guard let content = self.content else { return }
        if let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
            if content.participate.recasted {
                if let tempContent = ContentHelper.shared.getContentRef(id: content.referencedCasts.id) {
                    self.userRequest.targetCastcleId = tempContent.authorId
                }
            } else {
                self.userRequest.targetCastcleId = authorRef.castcleId
            }
            do {
                let realm = try Realm()
                try realm.write {
                    authorRef.followed = false
                    realm.add(authorRef, update: .modified)
                    NotificationCenter.default.post(name: .feedReloadContent, object: nil)
                }
            } catch {}
            self.userRepository.unfollow(targetCastcleId: self.userRequest.targetCastcleId) { (success, _, isRefreshToken) in
                if !success && isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
}

extension HeaderTableViewCell: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .deleteContent {
            self.deleteContent()
        } else if self.state == .followUser {
            self.followUser()
        } else if self.state == .unfollowUser {
            self.unfollowUser()
        }
    }
}

class HeaderSnackBar: SnackBar {
    override var style: SnackBarStyle {
        var customStyle = SnackBarStyle()
        customStyle.background = UIColor.Asset.cellBackground
        customStyle.textColor = UIColor.Asset.white
        customStyle.font = UIFont.asset(.bold, fontSize: .overline)
        customStyle.actionTextColor = UIColor.Asset.lightBlue
        customStyle.actionFont = UIFont.asset(.bold, fontSize: .body)
        customStyle.actionTextColorAlpha = 1.0
        return customStyle
    }
}
