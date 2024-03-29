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
//  RecastPopupViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 22/7/2564 BE.
//

import UIKit
import Core
import PanModal
import Kingfisher
import RealmSwift

public protocol RecastPopupViewControllerDelegate: AnyObject {
    func recastPopupViewController(_ view: RecastPopupViewController, didSelectRecastAction recastAction: RecastAction, page: PageRealm?, castcleId: String)
}

public enum RecastAction {
    case recast
    case quoteCast
}

public class RecastPopupViewController: UIViewController {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var recastImage: UIImageView!
    @IBOutlet var quoteCastImage: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var recastLabel: UILabel!
    @IBOutlet var quoteCastLabel: UILabel!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var selectView: UIView!
    @IBOutlet var chooseUserHeader: UIView!
    @IBOutlet var chooseUserTitle: UILabel!
    @IBOutlet var userTableView: UITableView!
    @IBOutlet var selectViewHeight: NSLayoutConstraint!

    var delegate: RecastPopupViewControllerDelegate?
    var maxHeight = (UIScreen.main.bounds.height - 320)
    var viewModel = RecastPopupViewModel()
    var pages: Results<PageRealm>!

    enum UserListSection: Int, CaseIterable {
        case user = 0
        case page
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.recastImage.image = UIImage.init(icon: .castcle(.recast), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.quoteCastImage.image = UIImage.init(icon: .castcle(.pencil), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white)

        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.bold, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.bold, fontSize: .overline)
        self.subTitleLabel.textColor = UIColor.Asset.lightGray
        self.recastLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.recastLabel.textColor = UIColor.Asset.white
        self.quoteCastLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.quoteCastLabel.textColor = UIColor.Asset.white
        self.chooseUserTitle.font = UIFont.asset(.bold, fontSize: .overline)
        self.chooseUserTitle.textColor = UIColor.Asset.white

        do {
            let realm = try Realm()
            self.pages = realm.objects(PageRealm.self).sorted(byKeyPath: "id")
        } catch {}

        self.subTitleLabel.text = Localization.ContentAction.recastTitle.text
        self.quoteCastLabel.text = Localization.ContentAction.quoteCast.text
        self.chooseUserTitle.text = Localization.ContentAction.choosePageOrUser.text
        if self.viewModel.isRecasted {
            self.recastLabel.text = Localization.ContentAction.unrecasted.text
        } else {
            self.recastLabel.text = Localization.ContentAction.recasted.text
        }

        if self.pages.count == 0 {
            self.moreButton.isHidden = true
        } else {
            self.moreButton.isHidden = false
        }

        self.moreButton.setImage(UIImage.init(icon: .castcle(.dropDown), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.configureTableView()
        self.updateUser()
        self.selectViewHeight.constant = 250
        self.selectView.isHidden = true
    }

    private func updateUser() {
        if self.viewModel.page?.castcleId == UserManager.shared.castcleId {
            let url = URL(string: UserManager.shared.avatar)
            self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        } else {
            guard let page = self.viewModel.page else { return }
            let url = URL(string: page.avatar)
            self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        }
        self.displayNameLabel.text = self.viewModel.page?.displayName ?? ""
    }

    func configureTableView() {
        self.userTableView.delegate = self
        self.userTableView.dataSource = self
        self.userTableView.register(UINib(nibName: ComponentNibVars.TableViewCell.userList, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.userList)
        self.userTableView.rowHeight = UITableView.automaticDimension
        self.userTableView.estimatedRowHeight = 100
        self.userTableView.backgroundColor = UIColor.Asset.darkGraphiteBlue
    }

    @IBAction func recastAction(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.recastPopupViewController(self, didSelectRecastAction: .recast, page: nil, castcleId: self.viewModel.page?.castcleId ?? "")
    }

    @IBAction func quoteCastAction(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.recastPopupViewController(self, didSelectRecastAction: .quoteCast, page: self.viewModel.page, castcleId: self.viewModel.page?.castcleId ?? "")
    }

    @IBAction func moreActiom(_ sender: Any) {
        UIView.transition(with: self.view, duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.selectView.isHidden = false
                          })
    }
}

extension RecastPopupViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return UserListSection.allCases.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == UserListSection.page.rawValue {
            return self.pages.count
        } else {
            return 1
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case UserListSection.user.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.userList, for: indexPath as IndexPath) as? UserListTableViewCell
            let isSelect: Bool = (self.viewModel.page?.displayName == UserManager.shared.displayName)
            cell?.configCell(isUser: true, page: nil, isSelect: isSelect)
            return cell ?? UserListTableViewCell()
        case UserListSection.page.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.userList, for: indexPath as IndexPath) as? UserListTableViewCell
            let page: PageRealm = self.pages[indexPath.row]
            let isSelect: Bool = (self.viewModel.page?.displayName == page.displayName)
            cell?.configCell(isUser: false, page: self.pages[indexPath.row], isSelect: isSelect)
            return cell ?? UserListTableViewCell()
        default:
            return UITableViewCell()
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case UserListSection.user.rawValue:
            self.viewModel.page = PageRealm().initCustom(id: UserManager.shared.id, displayName: UserManager.shared.displayName, castcleId: UserManager.shared.castcleId, avatar: UserManager.shared.avatar, cover: UserManager.shared.cover, overview: UserManager.shared.overview, official: UserManager.shared.official)
            self.userTableView.reloadData()
            self.updateUser()
            UIView.transition(with: self.view, duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.selectView.isHidden = true
                              })
        case UserListSection.page.rawValue:
            self.viewModel.page = self.pages[indexPath.row]
            self.userTableView.reloadData()
            self.updateUser()
            UIView.transition(with: self.view, duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.selectView.isHidden = true
                              })
        default:
            return
        }
    }
}

extension RecastPopupViewController: PanModalPresentable {
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panScrollable: UIScrollView? {
        return nil
    }

    public var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(self.maxHeight)
    }

    public var anchorModalToLongForm: Bool {
        return false
    }
}
