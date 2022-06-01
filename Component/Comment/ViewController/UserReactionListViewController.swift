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
//  UserReactionListViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 19/5/2565 BE.
//

import UIKit
import Core
import XLPagerTabStrip

class UserReactionListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    var viewModel = UserReactionListViewModel()
    var pageIndex: Int = 0
    var pageTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()

        self.tableView.coreRefresh.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            guard let self = self else { return }
            if self.viewModel.meta.resultCount < self.viewModel.contentRequest.maxResults {
                self.tableView.coreRefresh.noticeNoMoreData()
            } else {
                self.viewModel.contentRequest.untilId = self.viewModel.meta.oldestId
                if self.viewModel.type == .like {
                    self.viewModel.getUserLike()
                } else {
                    self.viewModel.getUserRecast()
                }
            }
        }

        self.viewModel.didLoadUsersFinish = {
            self.viewModel.loadState = .loaded
            self.tableView.isScrollEnabled = true
            self.tableView.coreRefresh.endHeaderRefresh()
            self.tableView.coreRefresh.endLoadingMore()
            if self.viewModel.meta.resultCount < self.viewModel.contentRequest.maxResults {
                self.tableView.coreRefresh.noticeNoMoreData()
            }
            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            })
        }
    }

    func configureTableView() {
        self.tableView.isScrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.userReaction, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.userReaction)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.skeletonUser, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.skeletonUser)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension UserReactionListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.loadState == .loading {
            return 5
        } else {
            return self.viewModel.users.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.loadState == .loading {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.skeletonUser, for: indexPath as IndexPath) as? SkeletonUserTableViewCell
            cell?.configCell()
            cell?.backgroundColor = UIColor.Asset.darkGray
            return cell ?? SkeletonUserTableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.userReaction, for: indexPath as IndexPath) as? UserReactionTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(user: self.viewModel.users[indexPath.row])
            return cell ?? UserReactionTableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewModel.loadState == .loaded {
            Utility.currentViewController().dismiss(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                let user = self.viewModel.users[indexPath.row]
                let userDict: [String: String] = [
                    JsonKey.castcleId.rawValue: user.castcleId,
                    JsonKey.displayName.rawValue: user.displayName
                ]
                NotificationCenter.default.post(name: .openProfileDelegate, object: nil, userInfo: userDict)
            }
        }
    }
}

extension UserReactionListViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
    }
}
