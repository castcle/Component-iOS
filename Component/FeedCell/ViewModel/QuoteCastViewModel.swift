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
//  QuoteCastViewModel.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 22/11/2564 BE.
//

import Core
import Networking

public final class QuoteCastViewModel {
   
    private var userRepository: UserRepository = UserRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    private var stage: Stage = .none
    private var userRequest: UserRequest = UserRequest()
    private var content: Content?
    
    enum Stage {
        case followUser
        case none
    }
    
    public init(content: Content) {
        self.content = content
        self.tokenHelper.delegate = self
    }
    
    func followUser() {
        self.stage = .followUser
        guard let content = self.content else { return }
        let userId: String = UserManager.shared.rawCastcleId
        self.userRequest.targetCastcleId = content.author.castcleId
        self.userRepository.follow(userId: userId, userRequest: self.userRequest) { (success, response, isRefreshToken) in
            if !success {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
}

extension QuoteCastViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .followUser {
            self.followUser()
        }
    }
}
