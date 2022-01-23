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
import Kingfisher
import Networking

public protocol SuggestionUserTableViewCellDelegate {
    func didSeeMore(_ suggestionUserTableViewCell: SuggestionUserTableViewCell, user: [Author])
    func didTabProfile(_ suggestionUserTableViewCell: SuggestionUserTableViewCell, user: Author)
    func didAuthen(_ suggestionUserTableViewCell: SuggestionUserTableViewCell)
    func didMockViewProfile(_ suggestionUserTableViewCell: SuggestionUserTableViewCell)
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
    private var isMock: Bool = true
    private var isFollowFirst: Bool = false
    private var isFollowSecond: Bool = false
    let tokenHelper: TokenHelper = TokenHelper()
    private var stage: Stage = .none
    private var userRequest: UserRequest = UserRequest()
    
    enum Stage {
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
    
    public func configCell(user: [Author], isMock: Bool) {
        self.isMock = isMock
        self.updateFirstUserFollow()
        self.updateSecondUserFollow()
        if isMock {
            let url = URL(string: UserManager.shared.avatar)
            self.firstUserAvatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.secondUserAvatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            
            self.firstUserNoticeLabel.text = "Chutima Kotxgapan and 21 others follow"
            self.firstUserDisplayNameLabel.text = UserManager.shared.displayName
            self.firstUserIdLabel.text = "@\(UserManager.shared.rawCastcleId)"
            
            self.secondUserNoticeLabel.text = "Chutima Kotxgapan and 21 others follow"
            self.secondUserDisplayNameLabel.text = UserManager.shared.displayName
            self.secondUserIdLabel.text = "@\(UserManager.shared.rawCastcleId)"
        } else {
            self.user = user
        }
    }
    
    private func updateFirstUserFollow() {
        if !self.isMock && self.user.count > 0 {
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
        } else {
            if self.isFollowFirst {
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
        if !self.isMock && self.user.count > 1 {
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
        } else {
            if self.isFollowSecond {
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
        self.stage = .followUser
        let userId: String = UserManager.shared.rawCastcleId
        self.userRepository.follow(userId: userId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    private func unfollowUser() {
        self.stage = .unfollowUser
        let userId: String = UserManager.shared.rawCastcleId
        self.userRepository.unfollow(userId: userId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    @IBAction func firstUserFollowAction(_ sender: Any) {
        if !self.isMock && self.user.count > 0 {
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
        } else {
            self.isFollowFirst.toggle()
            self.updateFirstUserFollow()
        }
    }
    
    @IBAction func firstUserProfileAction(_ sender: Any) {
        if !self.isMock && self.user.count > 0 {
            self.delegate?.didTabProfile(self, user: self.user[0])
        } else {
            self.delegate?.didMockViewProfile(self)
        }
    }
    
    @IBAction func secondUserFollowAction(_ sender: Any) {
        if !self.isMock && self.user.count > 1 {
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
        } else {
            self.isFollowSecond.toggle()
            self.updateSecondUserFollow()
        }
    }
    
    @IBAction func secondUserProfileAction(_ sender: Any) {
        if !self.isMock && self.user.count > 1 {
            self.delegate?.didTabProfile(self, user: self.user[1])
        } else {
            self.delegate?.didMockViewProfile(self)
        }
    }
    
    @IBAction func showMoreAction(_ sender: Any) {
        self.delegate?.didSeeMore(self, user: self.user)
    }
}

extension SuggestionUserTableViewCell: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .followUser {
            self.followUser()
        } else if self.stage == .unfollowUser {
            self.unfollowUser()
        }
    }
}
