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
//  ReactionViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 19/5/2565 BE.
//

import UIKit
import Core
import Networking
import XLPagerTabStrip
import Defaults

class ReactionViewController: ButtonBarPagerTabStripViewController {

    var content: Content = Content()
    var type: ReactionType = .none

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupButtonBar()
    }

    private func setupButtonBar() {
        settings.style.buttonBarBackgroundColor = UIColor.Asset.darkGraphiteBlue
        settings.style.buttonBarItemBackgroundColor = UIColor.Asset.darkGraphiteBlue
        settings.style.selectedBarBackgroundColor = UIColor.Asset.lightBlue
        settings.style.buttonBarItemTitleColor = UIColor.Asset.white
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarItemFont = UIFont.asset(.bold, fontSize: .body)
        settings.style.buttonBarHeight = 60.0

        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _, _, _) -> Void in
            oldCell?.label.textColor = UIColor.Asset.white
            newCell?.label.textColor = UIColor.Asset.lightBlue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
        if self.content.metrics.likeCount > 0 && self.content.metrics.recastCount > 0 && self.type == .recast {
            self.moveToViewController(at: 1, animated: false)
        }
    }

    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc1 = ComponentOpener.open(.userReactionList(UserReactionListViewModel(content: self.content, type: .like))) as? UserReactionListViewController
        vc1?.pageIndex = 0
        vc1?.pageTitle = "Likes"
        let likeViewController = vc1 ?? UserReactionListViewController()

        let vc2 = ComponentOpener.open(.userReactionList(UserReactionListViewModel(content: self.content, type: .recast))) as? UserReactionListViewController
        vc2?.pageIndex = 1
        vc2?.pageTitle = "Recasts"
        let recastViewController = vc2 ?? UserReactionListViewController()

        var section: [UIViewController] = []
        if self.content.metrics.likeCount > 0 {
            section.append(likeViewController)
        }
        if self.content.metrics.recastCount > 0 {
            section.append(recastViewController)
        }
        return section
    }
}
