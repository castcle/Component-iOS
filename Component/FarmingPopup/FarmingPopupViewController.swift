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

public protocol FarmingPopupViewControllerDelegate: AnyObject {
    func farmingPopupViewController(didAction view: FarmingPopupViewController)
}

public class FarmingPopupViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var farmBalanceTitleLabel: UILabel!
    @IBOutlet var avalidBalanceTitleLabel: UILabel!
    @IBOutlet var totalBalanceTitleLabel: UILabel!
    @IBOutlet var farmBalanceLabel: UILabel!
    @IBOutlet var avalidBalanceLabel: UILabel!
    @IBOutlet var totalBalanceLabel: UILabel!
    @IBOutlet var buttonLabel: UILabel!
    @IBOutlet var buttonCashLabel: UILabel!
    @IBOutlet var noteLabel: ActiveLabel!
    @IBOutlet var buttonView: UIView!
    @IBOutlet var iconImage: UIImageView!

    var delegate: FarmingPopupViewControllerDelegate?
    var maxHeight = (UIScreen.main.bounds.height - 400)
    var viewModel = FarmingPopupViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()
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
        self.farmBalanceLabel.font = UIFont.asset(.medium, fontSize: .head4)
        self.farmBalanceLabel.textColor = UIColor.Asset.white
        self.avalidBalanceLabel.font = UIFont.asset(.medium, fontSize: .head4)
        self.avalidBalanceLabel.textColor = UIColor.Asset.white
        self.totalBalanceLabel.font = UIFont.asset(.medium, fontSize: .head4)
        self.totalBalanceLabel.textColor = UIColor.Asset.white
        self.buttonLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.buttonLabel.textColor = UIColor.Asset.white
        self.buttonCashLabel.font = UIFont.asset(.medium, fontSize: .head4)
        self.buttonCashLabel.textColor = UIColor.Asset.white
        self.iconImage.image = UIImage.init(icon: .castcle(.farm), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
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

        if self.viewModel.farmingType == .unfarn {
            self.titleLabel.text = "Undo farm this cast "
            self.buttonLabel.text = "Undo farming"
            self.buttonView.custom(color: UIColor.Asset.denger, cornerRadius: 10)
        } else {
            self.titleLabel.text = "Farm this cast "
            self.buttonLabel.text = "Farm this cast "
            self.buttonView.custom(color: UIColor.Asset.lightBlue, cornerRadius: 10)
        }
    }

    @IBAction func buttonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.farmingPopupViewController(didAction: self)
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
