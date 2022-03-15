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
//  RemoteConfigValues.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 14/3/2565 BE.
//

import Firebase
import FirebaseRemoteConfig

class RemoteConfigValues {
    static let shared = RemoteConfigValues()
    private var remoteConfig: RemoteConfig!
    
    private init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        self.loadDefaultValues()
        self.fetchCloudValues()
    }
    
    func loadDefaultValues() {
        let appDefaults = [
            "ios": [
                "version": "9.9.9",
                "url": "https://apps.apple.com/app/castcle-decentralized-social/id1593824529"
            ],
            "android": [
                "version": "60",
                "url": "https://play.google.com/store/apps/details?id=com.castcle.android"
            ],
            "meta": [
                "title": [
                    "en": "",
                    "th": ""
                ],
                "message": [
                    "en": "",
                    "th": ""
                ],
                "button": [
                    "en": "",
                    "th": ""
                ]
            ]
        ]
        self.remoteConfig.setDefaults(appDefaults as [String: NSObject])
    }
    
    func activateDebugMode() {
        let settings = RemoteConfigSettings()
        // WARNING: Don't actually do this in production!
        settings.minimumFetchInterval = 0
        self.remoteConfig.configSettings = settings
    }
    
    func fetchCloudValues() {
        print("==========")
        // 1
        self.activateDebugMode()
        
        self.remoteConfig.fetch(withExpirationDuration: 0) { status, error in
            print(status)
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate { changed, error in
                    print(changed)
                    print(error)
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
        
        // 2
//        RemoteConfig.remoteConfig().fetch { _, error in
//            if let error = error {
//                print("Uh-oh. Got an error fetching remote values \(error)")
//                // In a real app, you would probably want to call the loading
//                // done callback anyway, and just proceed with the default values.
//                // I won't do that here, so we can call attention
//                // to the fact that Remote Config isn't loading.
//                return
//            }
//
//            // 3
//            RemoteConfig.remoteConfig().activate { _, _ in
//                print("Retrieved values from the cloud!")
//                print("""
//                  Our app's primary color is \
//                  \(RemoteConfig.remoteConfig().configValue(forKey: "ios"))
//                  """)
//            }
//        }
        print("==========")
    }
}
