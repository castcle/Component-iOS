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
//  FarmingPopupViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 29/3/2565 BE.
//

import UIKit
import Core
import ActiveLabel
import PanModal
import Networking
import Kingfisher
import SkeletonView

public protocol FarmingPopupViewControllerDelegate: AnyObject {
    func farmingPopupViewController(didAction view: FarmingPopupViewController, farmingStatus: FarmingStatus)
    func farmingPopupViewControllerDidViewHistory(_ view: FarmingPopupViewController)
}

public class FarmingPopupViewController: UIViewController {

    @IBOutlet var skeletonView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var farmBalanceTitleLabel: UILabel!
    @IBOutlet var avalidBalanceTitleLabel: UILabel!
    @IBOutlet var totalBalanceTitleLabel: UILabel!
    @IBOutlet var farmBalanceLabel: UILabel!
    @IBOutlet var avalidBalanceLabel: UILabel!
    @IBOutlet var totalBalanceLabel: UILabel!
    @IBOutlet var buttonLabel: UILabel!
    @IBOutlet weak var buttonHistoryLabel: UILabel!
    @IBOutlet var buttonCashLabel: UILabel!
    @IBOutlet var noteLabel: ActiveLabel!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var castcleIdLabel: UILabel!
    @IBOutlet var contentImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!

    var delegate: FarmingPopupViewControllerDelegate?
    var maxHeight = (UIScreen.main.bounds.height - 630)
    var viewModel = FarmingPopupViewModel(contentId: "")

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.skeletonView.isHidden = false
        self.skeletonView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.white
        self.countLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.countLabel.textColor = UIColor.Asset.lightBlue
        self.farmBalanceTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.farmBalanceTitleLabel.textColor = UIColor.Asset.white
        self.avalidBalanceTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.avalidBalanceTitleLabel.textColor = UIColor.Asset.white
        self.totalBalanceTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.totalBalanceTitleLabel.textColor = UIColor.Asset.white
        self.farmBalanceLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.farmBalanceLabel.textColor = UIColor.Asset.white
        self.avalidBalanceLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.avalidBalanceLabel.textColor = UIColor.Asset.white
        self.totalBalanceLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.totalBalanceLabel.textColor = UIColor.Asset.white
        self.buttonLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.buttonLabel.textColor = UIColor.Asset.white
        self.buttonHistoryLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.buttonHistoryLabel.textColor = UIColor.Asset.white
        self.buttonCashLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.buttonCashLabel.textColor = UIColor.Asset.white
        self.cancelButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .overline)
        self.cancelButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.contentView.custom(borderWidth: 1, borderColor: UIColor.Asset.lineGray)
        self.avatarImage.circle()
        self.avatarImage.image = UIImage.Asset.userPlaceholder
        self.contentImage.image = UIImage.Asset.placeholder
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.balanceTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.balanceTitleLabel.textColor = UIColor.Asset.white
        self.balanceLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.balanceLabel.textColor = UIColor.Asset.lightBlue
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.castcleIdLabel.textColor = UIColor.Asset.white
        self.messageLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.messageLabel.textColor = UIColor.Asset.white
        self.noteLabel.customize { label in
            label.font = UIFont.asset(.regular, fontSize: .overline)
            label.numberOfLines = 0
            label.textColor = UIColor.Asset.white
            let learnMore = ActiveType.custom(pattern: "Learn more")
            label.enabledTypes = [learnMore]
            label.customColor[learnMore] = UIColor.Asset.lightBlue
            label.customSelectedColor[learnMore] = UIColor.Asset.gray
            label.handleCustomTap(for: learnMore) { _ in
                // MARK: - Add action
            }
        }

        DispatchQueue.main.async {
            self.skeletonView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.Asset.gray))
        }
        self.viewModel.didLookupFinish = {
            self.updateUI()
            UIView.transition(with: self.view, duration: 0.35, options: .transitionCrossDissolve, animations: {
                self.skeletonView.isHidden = true
            })
        }
        self.viewModel.didFarmingFinish = {
            CCLoading.shared.dismiss()
            self.dismiss(animated: true, completion: nil)
            self.delegate?.farmingPopupViewController(didAction: self, farmingStatus: .farming)
        }
        self.viewModel.didUnfarmingFinish = {
            CCLoading.shared.dismiss()
            self.dismiss(animated: true, completion: nil)
            self.delegate?.farmingPopupViewController(didAction: self, farmingStatus: .available)
        }
        self.viewModel.didError = {
            CCLoading.shared.dismiss()
        }
    }

    private func updateUI() {
        self.countLabel.text = "\(self.viewModel.farming.number)/20"
        self.farmBalanceLabel.text = "\(self.viewModel.farming.balance.farmed) CAST"
        self.avalidBalanceLabel.text = "\(self.viewModel.farming.balance.available) CAST"
        self.totalBalanceLabel.text = "\(self.viewModel.farming.balance.total) CAST"
        self.balanceLabel.text = "\(self.viewModel.farming.balance.farming) CAST"
        self.buttonCashLabel.text = "\(self.viewModel.farming.balance.farming) CAST"
        let author = ContentHelper.shared.getAuthorRef(id: self.viewModel.farming.content.authorId)
        self.displayNameLabel.text = author?.displayName ?? "Castcle"
        self.castcleIdLabel.text = author?.castcleId ?? "@castcle"
        self.messageLabel.text = (self.viewModel.farming.content.message.isEmpty ? "N/A" : self.viewModel.farming.content.message)
        let authorAvatarUrl = URL(string: author?.avatar ?? "")
        self.avatarImage.kf.setImage(with: authorAvatarUrl, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])

        if let imageUrl = self.viewModel.farming.content.photo.first {
            let url = URL(string: imageUrl.thumbnail)
            self.contentImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
        } else {
            self.contentImage.image = UIImage.Asset.placeholder
        }

        if self.viewModel.farming.status == .farming {
            self.countLabel.textColor = UIColor.Asset.lightBlue
            self.titleLabel.text = "Undo farm this cast"
            self.buttonLabel.text = "Undo farming"
            self.buttonView.custom(color: UIColor.Asset.denger, cornerRadius: 10)
            self.buttonLabel.isHidden = false
            self.buttonCashLabel.isHidden = false
            self.buttonHistoryLabel.isHidden = true
        } else if self.viewModel.farming.status == .limit {
            self.countLabel.textColor = UIColor.Asset.denger
            self.titleLabel.text = "Your farm limit is reached"
            self.buttonView.custom(color: UIColor.Asset.warning, cornerRadius: 10)
            self.buttonLabel.isHidden = true
            self.buttonCashLabel.isHidden = true
            self.buttonHistoryLabel.isHidden = false
        } else {
            self.countLabel.textColor = UIColor.Asset.lightBlue
            self.titleLabel.text = "Farm this cast"
            self.buttonLabel.text = "Farm this cast"
            self.buttonLabel.isHidden = false
            self.buttonCashLabel.isHidden = false
            self.buttonHistoryLabel.isHidden = true
            let farmingNumber: Double = Double(self.viewModel.farming.balance.farming) ?? 0
            if farmingNumber == 0 {
                self.buttonView.custom(color: UIColor.Asset.lineGray, cornerRadius: 10)
            } else {
                self.buttonView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 10)
            }
        }
    }

    @IBAction func buttonAction(_ sender: Any) {
        if self.viewModel.farming.status == .available {
            let farmingNumber: Double = Double(self.viewModel.farming.balance.farming) ?? 0
            if farmingNumber != 0 {
                CCLoading.shared.show()
                self.viewModel.farmingCast()
            }
        } else if self.viewModel.farming.status == .farming {
            CCLoading.shared.show()
            self.viewModel.unfarmingCast()
        } else if self.viewModel.farming.status == .limit {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.farmingPopupViewControllerDidViewHistory(self)
        }
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FarmingPopupViewController: PanModalPresentable {
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
