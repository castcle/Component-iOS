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
//  ComponentOpener.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 27/7/2564 BE.
//

import UIKit
import Core
import Networking

public enum ComponentScene {
    case internalWebView(URL)
    case splashScreen
    case datePicker
    case recast(RecastPopupViewModel)
    case comment(CommentViewModel)
    case commentDetail(CommentDetailViewModel)
    case farmingPopup(FarmingPopupViewModel)
    case farmingLimitPopup
    case syncAutoPostTwitter(SyncTwitterAutoPostViewModel)
    case acceptSyncSocialPopup(AcceptSyncSocialPopupViewModel)
    case selectCode
    case reaction(Content, ReactionType)
    case userReactionList(UserReactionListViewModel)
    case pdpaPopup
}

public struct ComponentOpener {
    public static func open(_ componentScene: ComponentScene) -> UIViewController {
        switch componentScene {
        case .internalWebView(let url):
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.internalWebView, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.internalWebView) as? InternalWebViewController
            viewController?.viewModel = InternalWebViewModel(url: url)
            return viewController ?? UIViewController()
        case .splashScreen:
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.splashScreen, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.splashScreen) as? SplashScreenViewController
            return viewController ?? UIViewController()
        case .datePicker:
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.picker, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.datePicker) as? DatePickerViewController
            return viewController ?? UIViewController()
        case .recast(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.recast, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.recastPopup) as? RecastPopupViewController
            viewController?.viewModel = viewModel
            return viewController ?? RecastPopupViewController()
        case .comment(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.comment, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.comment) as? CommentViewController
            viewController?.viewModel = viewModel
            return viewController ?? CommentViewController()
        case .commentDetail(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.comment, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.commentDetail) as? CommentDetailViewController
            viewController?.viewModel = viewModel
            return viewController ?? CommentDetailViewController()
        case .farmingPopup(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.farmingPopup, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.farmingPopup) as? FarmingPopupViewController
            viewController?.viewModel = viewModel
            return viewController ?? FarmingPopupViewController()
        case .farmingLimitPopup:
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.farmingPopup, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.farmingLimitPopup) as? FarmingLimitViewController
            return viewController ?? FarmingLimitViewController()
        case .syncAutoPostTwitter(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.publicPopup, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.syncAutoPostTwitter) as? SyncAutoPostViewController
            viewController?.viewModel = viewModel
            return viewController ?? SyncAutoPostViewController()
        case .acceptSyncSocialPopup(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.publicPopup, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.acceptSyncSocialPopup) as? AcceptSyncSocialPopupViewController
            viewController?.viewModel = viewModel
            return viewController ?? AcceptSyncSocialPopupViewController()
        case .selectCode:
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.publicPopup, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.selectCode)
            return viewController
        case .reaction(let content, let type):
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.comment, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.reaction) as? ReactionViewController
            viewController?.content = content
            viewController?.type = type
            return viewController ?? ReactionViewController()
        case .userReactionList(let viewModel):
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.comment, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.userReactionList) as? UserReactionListViewController
            viewController?.viewModel = viewModel
            return viewController ?? UserReactionListViewController()
        case .pdpaPopup:
            let storyboard: UIStoryboard = UIStoryboard(name: ComponentNibVars.Storyboard.publicPopup, bundle: ConfigBundle.component)
            let viewController = storyboard.instantiateViewController(withIdentifier: ComponentNibVars.ViewController.pdpaPopup) as? PdpaPopupViewController
            return viewController ?? PdpaPopupViewController()
        }
    }
}
