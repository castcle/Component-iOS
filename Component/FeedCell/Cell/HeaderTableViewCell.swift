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

public protocol HeaderTableViewCellDelegate {
    func didTabProfile(_ headerTableViewCell: HeaderTableViewCell, author: Author)
    func didAuthen(_ headerTableViewCell: HeaderTableViewCell)
    func didRemoveSuccess(_ headerTableViewCell: HeaderTableViewCell)
    func didReportSuccess(_ headerTableViewCell: HeaderTableViewCell)
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
    private var reportRepository: ReportRepository = ReportRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    private var stage: Stage = .none
    private var userRequest: UserRequest = UserRequest()
    private var reportRequest: ReportRequest = ReportRequest()
    private let realm = try! Realm()
    
    enum Stage {
        case deleteContent
        case followUser
        case unfollowUser
        case reportContent
        case none
    }
    
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
    
    public func configCell(feedType: FeedType, content: Content) {
        self.content = content
        if let content = self.content {
            self.followButton.setTitle(Localization.contentDetail.follow.text, for: .normal)
            if let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
                if authorRef.type == AuthorType.people.rawValue {
                    if authorRef.castcleId == UserManager.shared.rawCastcleId {
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
                    if let page = self.realm.objects(Page.self).filter("id = '\(content.authorId)'").first {
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
                }

                self.displayNameLabel.text = authorRef.displayName
                if feedType == .ads {
                    self.dateLabel.text = "Advertised"
                } else {
                    self.dateLabel.text = content.postDate.timeAgoDisplay()
                }
                self.dateLabel.text = content.postDate.timeAgoDisplay()
                
                if authorRef.official {
                    self.verifyConstraintWidth.constant = 15.0
                    self.verifyIcon.isHidden = false
                } else {
                    self.verifyConstraintWidth.constant = 0.0
                    self.verifyIcon.isHidden = true
                }
            } else {
                self.avatarImage.image = UIImage.Asset.userPlaceholder
                if feedType == .ads {
                    self.dateLabel.text = "Advertised"
                }
            }
        } else {
            self.avatarImage.image = UIImage.Asset.userPlaceholder
            if feedType == .ads {
                self.dateLabel.text = "Advertised"
            }
        }
    }
    
    @IBAction func followAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            guard let content = self.content else { return }
            if let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
                self.followButton.isHidden = true
                self.followUser()
                HeaderSnackBar.make(in: Utility.currentViewController().view, message: "\(Localization.contentAction.followed.text) @\(authorRef.castcleId)", duration: .lengthLong).setAction(with: Localization.contentAction.undo.text, action: {
                    self.followButton.isHidden = false
                    self.unfollowUser()
                }).show()
            } else {
                return
            }
            
        } else {
            self.delegate?.didAuthen(self)
        }
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        if let content = self.content {
            if let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
                self.delegate?.didTabProfile(self, author: Author(authorRef: authorRef))
            }
        }
    }
    
    @IBAction func moreAction(_ sender: Any) {
        if let content = self.content {
            if ContentHelper.shared.isMyAccount(id: content.authorId) {
                let actionSheet = CCActionSheet()
                let deleteButton = CCAction(title: Localization.contentAction.delete.text, image: UIImage.init(icon: .castcle(.delete), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
                    actionSheet.dismissActionSheet()
                    self.deleteContent()
                }
                
                actionSheet.addActions([deleteButton])
                actionSheet.modalPresentationStyle  = .overFullScreen
                Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
            } else {
                let actionSheet = CCActionSheet()
                let reportButton = CCAction(title: Localization.contentAction.reportCast.text, image: UIImage.init(icon: .castcle(.report), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
                    actionSheet.dismissActionSheet()
                    if UserManager.shared.isLogin {
                        self.reportContent()
                    } else {
                        self.delegate?.didAuthen(self)
                    }
                }
                
                actionSheet.addActions([reportButton])
                actionSheet.modalPresentationStyle  = .overFullScreen
                Utility.currentViewController().present(actionSheet, animated: true, completion: nil)
            }
        }
        
        
    }
    
    private func deleteContent() {
        self.stage = .deleteContent
        guard let content = self.content else { return }
        self.delegate?.didRemoveSuccess(self)
        self.contentRepository.deleteContent(contentId: content.id) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    private func reportContent() {
        self.stage = .reportContent
        guard let content = self.content else { return }
        self.reportRequest.targetContentId = content.id
        self.reportRepository.reportContent(userId: UserManager.shared.rawCastcleId, reportRequest: self.reportRequest) { (success, response, isRefreshToken) in
            if success {
                self.delegate?.didReportSuccess(self)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    private func followUser() {
        self.stage = .followUser
        guard let content = self.content else { return }
        if let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
            let userId: String = UserManager.shared.rawCastcleId
            if content.referencedCasts.type == .recasted {
                if let tempContent = ContentHelper.shared.getContentRef(id: content.referencedCasts.id) {
                    self.userRequest.targetCastcleId = tempContent.authorId
                }
            } else {
                self.userRequest.targetCastcleId = authorRef.castcleId
            }
            
            try! self.realm.write {
                authorRef.followed = true
                self.realm.add(authorRef, update: .modified)
                NotificationCenter.default.post(name: .feedReloadContent, object: nil)
            }
            
            self.userRepository.follow(userId: userId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
                if !success {
                    if isRefreshToken {
                        self.tokenHelper.refreshToken()
                    }
                }
            }
        } else {
            return
        }
    }
    
    private func unfollowUser() {
        self.stage = .unfollowUser
        guard let content = self.content else { return }
        if let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
            let userId: String = UserManager.shared.rawCastcleId
            if content.participate.recasted {
                if let tempContent = ContentHelper.shared.getContentRef(id: content.referencedCasts.id) {
                    self.userRequest.targetCastcleId = tempContent.authorId
                }
            } else {
                self.userRequest.targetCastcleId = authorRef.castcleId
            }
            
            try! self.realm.write {
                authorRef.followed = false
                self.realm.add(authorRef, update: .modified)
                NotificationCenter.default.post(name: .feedReloadContent, object: nil)
            }
            
            self.userRepository.unfollow(userId: userId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
                if !success {
                    if isRefreshToken {
                        self.tokenHelper.refreshToken()
                    }
                }
            }
        } else {
            return
        }
    }
}

extension HeaderTableViewCell: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .deleteContent {
            self.deleteContent()
        } else if self.stage == .followUser {
            self.followUser()
        } else if self.stage == .unfollowUser {
            self.unfollowUser()
        } else if self.stage == .reportContent {
            self.reportContent()
        }
    }
}

class HeaderSnackBar: SnackBar {
    override var style: SnackBarStyle {
        var customStyle = SnackBarStyle()
        customStyle.background = UIColor.Asset.darkGray
        customStyle.textColor = UIColor.Asset.white
        customStyle.font = UIFont.asset(.bold, fontSize: .overline)
        
        customStyle.actionTextColor = UIColor.Asset.lightBlue
        customStyle.actionFont = UIFont.asset(.bold, fontSize: .body)
        customStyle.actionTextColorAlpha = 1.0
        
        return customStyle
    }
}
