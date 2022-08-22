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
//  FarmingPopupViewModel.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 29/3/2565 BE.
//

import Core
import Networking
import SwiftyJSON

final public class FarmingPopupViewModel {

    private var farmingRepository: FarmingRepository = FarmingRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var contentId: String = ""
    var farming: Farming = Farming()
    var state: State = .none

    public init(contentId: String) {
        self.contentId = contentId
        self.tokenHelper.delegate = self
        if !self.contentId.isEmpty {
            self.farmingLookup()
        }
    }

    func farmingLookup() {
        self.state = .farmingLookup
        self.farmingRepository.farmingLookup(userId: UserManager.shared.id, contentId: self.contentId) { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.farming =  Farming(json: json)
                    let includes = JSON(json[JsonKey.includes.rawValue].dictionaryValue)
                    let users = includes[JsonKey.users.rawValue].arrayValue
                    UserHelper.shared.updateAuthorRef(users: users)
                    self.didLookupFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    func farmingCast() {
        self.state = .farmingCast
        self.farmingRepository.farmingCast(userId: UserManager.shared.id, contentId: self.contentId) { (success, _, isRefreshToken)  in
            if success {
                self.didFarmingFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    func unfarmingCast() {
        self.state = .unfarmingCast
        self.farmingRepository.unfarmingCast(userId: UserManager.shared.id, farmId: self.farming.id) { (success, _, isRefreshToken)  in
            if success {
                self.didUnfarmingFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didError?()
                }
            }
        }
    }

    var didLookupFinish: (() -> Void)?
    var didFarmingFinish: (() -> Void)?
    var didUnfarmingFinish: (() -> Void)?
    var didError: (() -> Void)?
}

extension FarmingPopupViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .farmingLookup {
            self.farmingLookup()
        } else if self.state == .farmingCast {
            self.farmingCast()
        }
    }
}
