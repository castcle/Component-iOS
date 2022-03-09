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
//  SuggestionUserTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 21/1/2565 BE.
//

import UIKit
import Core
import Networking
import Kingfisher
import RealmSwift

public protocol SuggestionUserTableViewCellDelegate {
    func didSeeMore(_ suggestionUserTableViewCell: SuggestionUserTableViewCell, user: [Author])
    func didTabProfile(_ suggestionUserTableViewCell: SuggestionUserTableViewCell, user: Author)
    func didAuthen(_ suggestionUserTableViewCell: SuggestionUserTableViewCell)
}

public class SuggestionUserTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var firstUserView: UIView!
    @IBOutlet weak var firstUserNoticeLabel: UILabel!
    @IBOutlet weak var firstUserAvatarImage: UIImageView!
    @IBOutlet weak var firstUserDisplayNameLabel: UILabel!
    @IBOutlet weak var firstUserIdLabel: UILabel!
    @IBOutlet weak var firstUserDescLabel: UILabel!
    @IBOutlet weak var fitstUserFollowButton: UIButton!
    @IBOutlet weak var firstUserVerifyImage: UIImageView!
    
    @IBOutlet weak var secondUserView: UIView!
    @IBOutlet weak var secondUserNoticeLabel: UILabel!
    @IBOutlet weak var secondUserAvatarImage: UIImageView!
    @IBOutlet weak var secondUserDisplayNameLabel: UILabel!
    @IBOutlet weak var secondUserIdLabel: UILabel!
    @IBOutlet weak var secondUserDescLabel: UILabel!
    @IBOutlet weak var secondUserFollowButton: UIButton!
    @IBOutlet weak var secondUserVerifyImage: UIImageView!
    
    public var delegate: SuggestionUserTableViewCellDelegate?
    private var userRepository: UserRepository = UserRepositoryImpl()
    private var user: [Author] = []
    let tokenHelper: TokenHelper = TokenHelper()
    private var state: State = .none
    private var userRequest: UserRequest = UserRequest()
    private let realm = try! Realm()
    
    enum State {
        case followUser
        case unfollowUser
        case none
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.tokenHelper.delegate = self
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .h4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.showMoreButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.showMoreButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        
        self.firstUserView.custom(cornerRadius: 10, borderWidth: 1.0, borderColor: UIColor.Asset.gray)
        self.firstUserAvatarImage.circle(color: UIColor.Asset.white)
        self.firstUserDisplayNameLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.firstUserDisplayNameLabel.textColor = UIColor.Asset.white
        self.firstUserNoticeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.firstUserNoticeLabel.textColor = UIColor.Asset.white
        self.firstUserIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.firstUserIdLabel.textColor = UIColor.Asset.white
        self.firstUserDescLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.firstUserDescLabel.textColor = UIColor.Asset.white
        self.firstUserVerifyImage.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.fitstUserFollowButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .small)
        
        self.secondUserView.custom(cornerRadius: 10, borderWidth: 1.0, borderColor: UIColor.Asset.gray)
        self.secondUserAvatarImage.circle(color: UIColor.Asset.white)
        self.secondUserDisplayNameLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.secondUserDisplayNameLabel.textColor = UIColor.Asset.white
        self.secondUserNoticeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.secondUserNoticeLabel.textColor = UIColor.Asset.white
        self.secondUserIdLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.secondUserIdLabel.textColor = UIColor.Asset.white
        self.secondUserDescLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.secondUserDescLabel.textColor = UIColor.Asset.white
        self.secondUserVerifyImage.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.secondUserFollowButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .small)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configCell(user: [Author]) {
        self.user = user
        self.updateFirstUserFollow()
        self.updateSecondUserFollow()
        
        if self.user.count >= 2 {
            let firstUser = self.user[0]
            let firstUserAvatar = URL(string: firstUser.avatar.thumbnail)
            self.firstUserAvatarImage.kf.setImage(with: firstUserAvatar, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.firstUserNoticeLabel.text = firstUser.aggregator.message
            self.firstUserDisplayNameLabel.text = firstUser.displayName
            self.firstUserIdLabel.text = "@\(firstUser.castcleId)"
            self.firstUserDescLabel.text = firstUser.overview
            if firstUser.verified.official {
                self.firstUserVerifyImage.isHidden = false
            } else {
                self.firstUserVerifyImage.isHidden = true
            }
            
            let secondUser = self.user[1]
            let secondUserAvatar = URL(string: secondUser.avatar.thumbnail)
            self.secondUserAvatarImage.kf.setImage(with: secondUserAvatar, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.secondUserNoticeLabel.text = secondUser.aggregator.message
            self.secondUserDisplayNameLabel.text = secondUser.displayName
            self.secondUserIdLabel.text = "@\(secondUser.castcleId)"
            self.secondUserDescLabel.text = secondUser.overview
            if secondUser.verified.official {
                self.secondUserVerifyImage.isHidden = false
            } else {
                self.secondUserVerifyImage.isHidden = true
            }
        }
    }
    
    private func updateFirstUserFollow() {
        if self.user.count > 0 {
            let user = self.user[0]
            if user.followed {
                self.fitstUserFollowButton.setTitle("Following", for: .normal)
                self.fitstUserFollowButton.setTitleColor(UIColor.Asset.white, for: .normal)
                self.fitstUserFollowButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1.0, borderColor: UIColor.Asset.lightBlue)
            } else {
                self.fitstUserFollowButton.setTitle("Follow", for: .normal)
                self.fitstUserFollowButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
                self.fitstUserFollowButton.capsule(color: .clear, borderWidth: 1.0, borderColor: UIColor.Asset.lightBlue)
            }
        }
    }
    
    private func updateSecondUserFollow() {
        if self.user.count > 1 {
            let user = self.user[1]
            if user.followed {
                self.secondUserFollowButton.setTitle("Following", for: .normal)
                self.secondUserFollowButton.setTitleColor(UIColor.Asset.white, for: .normal)
                self.secondUserFollowButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1.0, borderColor: UIColor.Asset.lightBlue)
            } else {
                self.secondUserFollowButton.setTitle("Follow", for: .normal)
                self.secondUserFollowButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
                self.secondUserFollowButton.capsule(color: .clear, borderWidth: 1.0, borderColor: UIColor.Asset.lightBlue)
            }
        }
    }
    
    private func followUser() {
        self.state = .followUser
        let userId: String = UserManager.shared.rawCastcleId
        if let authorRef = ContentHelper.shared.getAuthorRef(castcleId: self.userRequest.targetCastcleId) {
            try! self.realm.write {
                authorRef.followed = true
                self.realm.add(authorRef, update: .modified)
                NotificationCenter.default.post(name: .feedReloadContent, object: nil)
            }
        }
        self.userRepository.follow(userId: userId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    private func unfollowUser() {
        self.state = .unfollowUser
        let userId: String = UserManager.shared.rawCastcleId
        if let authorRef = ContentHelper.shared.getAuthorRef(castcleId: self.userRequest.targetCastcleId) {
            try! self.realm.write {
                authorRef.followed = false
                self.realm.add(authorRef, update: .modified)
                NotificationCenter.default.post(name: .feedReloadContent, object: nil)
            }
        }
        self.userRepository.unfollow(userId: userId, targetCastcleId: self.userRequest.targetCastcleId) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    @IBAction func firstUserFollowAction(_ sender: Any) {
        if self.user.count > 0 {
            if UserManager.shared.isLogin {
                self.userRequest.targetCastcleId = self.user[0].castcleId
                if self.user[0].followed {
                    self.unfollowUser()
                } else {
                    self.followUser()
                }
                self.user[0].followed.toggle()
                self.updateFirstUserFollow()
            } else {
                self.delegate?.didAuthen(self)
            }
        }
    }
    
    @IBAction func firstUserProfileAction(_ sender: Any) {
        if self.user.count > 0 {
            self.delegate?.didTabProfile(self, user: self.user[0])
        }
    }
    
    @IBAction func secondUserFollowAction(_ sender: Any) {
        if self.user.count > 1 {
            if UserManager.shared.isLogin {
                self.userRequest.targetCastcleId = self.user[1].castcleId
                if self.user[1].followed {
                    self.unfollowUser()
                } else {
                    self.followUser()
                }
                self.user[1].followed.toggle()
                self.updateFirstUserFollow()
            } else {
                self.delegate?.didAuthen(self)
            }
        }
    }
    
    @IBAction func secondUserProfileAction(_ sender: Any) {
        if self.user.count > 1 {
            self.delegate?.didTabProfile(self, user: self.user[1])
        }
    }
    
    @IBAction func showMoreAction(_ sender: Any) {
        self.delegate?.didSeeMore(self, user: self.user)
    }
}

extension SuggestionUserTableViewCell: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .followUser {
            self.followUser()
        } else if self.state == .unfollowUser {
            self.unfollowUser()
        }
    }
}
