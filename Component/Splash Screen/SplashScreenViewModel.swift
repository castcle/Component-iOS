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
//  SplashScreenViewModel.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 1/8/2564 BE.
//

import UIKit
import Foundation
import Core
import Networking
import Defaults
import SwiftyJSON
import RealmSwift

final class SplashScreenViewModel {
   
    //MARK: Private
    private var authenticationRepository: AuthenticationRepository = AuthenticationRepositoryImpl()
    private var notificationRepository: NotificationRepository = NotificationRepositoryImpl()
    private var masterDataRepository: MasterDataRepository = MasterDataRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var state: State = .none

    public func guestLogin() {
        self.state = .guestLogin
        self.authenticationRepository.guestLogin(uuid: Defaults[.deviceUuid]) { (success) in
            if success {
                self.getCountryCode()
            }
        }
    }
    
    private func getCountryCode() {
        self.state = .getCountryCode
        self.masterDataRepository.getCountry() { (success, response, isRefreshToken) in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let payload = json[JsonKey.payload.rawValue].arrayValue
                    let realm = try! Realm()
                    payload.forEach { item in
                        try! realm.write {
                            let countryCode = CountryCode().initWithJson(json: item)
                            realm.add(countryCode, update: .modified)
                        }
                    }
                    self.didGuestLoginFinish?()
                } catch {
                    self.didGuestLoginFinish?()
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.didGuestLoginFinish?()
                }
            }
        }
    }
    
    public func getBadges() {
        self.state = .getBadges
        self.notificationRepository.getBadges() { (success, response, isRefreshToken) in
            if success {
                UIApplication.shared.applicationIconBadgeNumber = UserManager.shared.badgeCount
                self.getCountryCode()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.getCountryCode()
                }
            }
        }
    }
    
    //MARK: Output
    var didGuestLoginFinish: (() -> ())?
    
    public init() {
        self.tokenHelper.delegate = self
    }
    
    public func tokenHandle() {
        if UserManager.shared.accessToken.isEmpty || UserManager.shared.userRole == .guest {
            UIApplication.shared.applicationIconBadgeNumber = UserManager.shared.badgeCount
            self.guestLogin()
        } else {
            self.state = .refreshToken
            self.tokenHelper.refreshToken()
        }
    }
}

extension SplashScreenViewModel: TokenHelperDelegate {
    func didRefreshTokenFinish() {
        if self.state == .getBadges {
            self.getBadges()
        } else if self.state == .getCountryCode {
            self.getCountryCode()
        } else {
            if UserManager.shared.isLogin {
                self.getBadges()
            } else {
                self.didGuestLoginFinish?()
            }
        }
    }
}
