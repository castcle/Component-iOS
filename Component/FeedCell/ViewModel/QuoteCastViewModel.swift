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
    private var state: State = .none
    private var userRequest: UserRequest = UserRequest()
    var content: Content?

    public init(content: Content) {
        self.content = content
        self.tokenHelper.delegate = self
    }

    func followUser() {
        self.state = .followUser
        guard let content = self.content else { return }
        if let authorRef = ContentHelper.shared.getAuthorRef(id: content.authorId) {
            self.userRequest.targetCastcleId = authorRef.castcleId
            self.userRepository.follow(userRequest: self.userRequest) { (success, _, isRefreshToken) in
                if !success && isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
}

extension QuoteCastViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .followUser {
            self.followUser()
        }
    }
}
