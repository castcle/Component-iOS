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

public protocol SplashScreenViewControllerDelegate {
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
    
//    private func fetchRemoteConfig() {
//        let appDefaults: [String: NSObject] = [
//            "version_ios": "9.9.9" as NSObject
//        ]
//        self.remoteConfig.setDefaults(appDefaults)
//
//        let setting = RemoteConfigSettings()
//        setting.minimumFetchInterval = 0
//        self.remoteConfig.configSettings = setting
//
//        self.remoteConfig.fetch(withExpirationDuration: 0) { status, error in
//            if status == .success, error == nil {
//                self.remoteConfig.activate() { success, error  in
//                    guard error == nil else { return }
//                    let value = self.remoteConfig.configValue(forKey: "version_ios").stringValue
//                    print(value)
//                }
//            } else {
//                print("Something went wrong")
//            }
//        }
//    }
}
