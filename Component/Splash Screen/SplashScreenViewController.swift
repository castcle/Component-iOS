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
//  SplashScreenViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 1/8/2564 BE.
//

import UIKit
import Core
import Networking
import Defaults
import FirebaseRemoteConfig
import SwiftyJSON

public protocol SplashScreenViewControllerDelegate: AnyObject {
    func didLoadFinish(_ view: SplashScreenViewController)
}

public class SplashScreenViewController: UIViewController {

    @IBOutlet var logoImage: UIImageView!
    @IBOutlet var backgroundImage: UIImageView!

    public var delegate: SplashScreenViewControllerDelegate?
    var viewModel = SplashScreenViewModel()
    private let remoteConfig = RemoteConfig.remoteConfig()

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundImage.image = UIImage.Asset.launchScreen
        self.logoImage.image = UIImage.Asset.castcleLogo
        self.fetchRemoteConfig()
        self.viewModel.tokenHandle()
        self.viewModel.didGuestLoginFinish = {
            self.delegate?.didLoadFinish(self)
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ScreenId.splashScreen.rawValue
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !UserManager.shared.accessToken.isEmpty {
            EngagementHelper().sendCastcleAnalytic(event: .onScreenView, screen: .splashScreen)
        }
    }

    private func fetchRemoteConfig() {
        Defaults[.isForceUpdate] = false
        Defaults[.isSoftUpdate] = false
        let duration: Double = (Environment.appEnv == .prod ? 3600 : 0)
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = duration
        RemoteConfig.remoteConfig().configSettings = setting

        let defualt: [String: NSObject] = [
            "version_ios": "9.9.9" as NSObject
        ]
        RemoteConfig.remoteConfig().setDefaults(defualt)
        RemoteConfig.remoteConfig().fetch(withExpirationDuration: duration) { ststus, error in
            if ststus == .success, error == nil {
                RemoteConfig.remoteConfig().activate {_, error in
                    if error == nil {
                        let json = RemoteConfig.remoteConfig().configValue(forKey: "force_version").jsonValue
                        if let jsonForceVersion = json {
                            let data = JSON(jsonForceVersion)
                            let remoteConfig = RemoteConfig(json: data)
                            Defaults[.updateUrl] = remoteConfig.ios.url
                            Defaults[.updateTitle] = remoteConfig.meta.title.eng
                            Defaults[.updateMessage] = remoteConfig.meta.message.eng
                            Defaults[.updateButton] = remoteConfig.meta.button.eng

                            if CheckUpdate.shared.isUpdateApp(version: remoteConfig.ios.version) {
                                Defaults[.isForceUpdate] = true
                                Defaults[.isSoftUpdate] = false
                            } else {
                                _ = CheckUpdate.shared.getAppInfo { (info, error) in
                                    if let appStoreAppVersion = info?.version {
                                        if error != nil {
                                            print("Error")
                                        } else if !CheckUpdate.shared.isUpdateApp(version: appStoreAppVersion) {
                                            print("App not update")
                                        } else {
                                            Defaults[.isForceUpdate] = false
                                            Defaults[.isSoftUpdate] = true
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        print("Error")
                    }
                }
            } else {
                print("Error")
            }
        }
        Defaults[.isFarmingEnable] = RemoteConfig.remoteConfig().configValue(forKey: "farming_enable").boolValue
    }
}
