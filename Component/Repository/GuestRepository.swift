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
//  GuestRepository.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 1/8/2564 BE.
//

import Core
import Moya
import SwiftyJSON
import Defaults

protocol GuestRepository {
    func guestLogin(uuid: String, _ completion: @escaping (Bool) -> ())
}

final class GuestRepositoryImpl: GuestRepository {
    private let guestProvider = MoyaProvider<GuestApi>()
    
    func guestLogin(uuid: String, _ completion: @escaping (Bool) -> ()) {
        self.guestProvider.request(.guestLogin(uuid)) { result in
            switch result {
            case .success(let response):
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    if response.statusCode < 300 {
                        let accessToken = json[GuestApiKey.accessToken.rawValue].stringValue
                        let refreshToken = json[GuestApiKey.refreshToken.rawValue].stringValue
                        Defaults[.userRole] = "GUEST"
                        Defaults[.accessToken] = accessToken
                        Defaults[.refreshToken] = refreshToken
                        completion(true)
                    } else {
                        ApiHelper.displayError(error: "\(json[ResponseErrorKey.code.rawValue].stringValue) : \(json[ResponseErrorKey.message.rawValue].stringValue)")
                        completion(false)
                    }
                } catch {
                    ApiHelper.displayError(error: "Something Went wrong")
                    completion(false)
                }
            case .failure:
                ApiHelper.displayError(error: "Something Went wrong")
                completion(false)
            }
        }
    }
}
