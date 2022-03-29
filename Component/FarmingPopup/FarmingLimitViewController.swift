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
//  FarmingLimitViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 29/3/2565 BE.
//

import UIKit
import Core
import PanModal

public protocol FarmingLimitViewControllerDelegate {
    func farmingLimitViewController(didAction view: FarmingLimitViewController)
}

public class FarmingLimitViewController: UIViewController {

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
    @IBOutlet var buttonView: UIView!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var historyButton: UIButton!
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var contentImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    var delegate: FarmingLimitViewControllerDelegate?
    var maxHeight = (UIScreen.main.bounds.height - 530)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.font = UIFont.asset(.bold, fontSize: .body)
        self.titleLabel.textColor = UIColor.Asset.white
        self.countLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.countLabel.textColor = UIColor.Asset.denger
        self.farmBalanceTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.farmBalanceTitleLabel.textColor = UIColor.Asset.white
        self.avalidBalanceTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.avalidBalanceTitleLabel.textColor = UIColor.Asset.white
        self.totalBalanceTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.totalBalanceTitleLabel.textColor = UIColor.Asset.white
        self.farmBalanceLabel.font = UIFont.asset(.medium, fontSize: .h4)
        self.farmBalanceLabel.textColor = UIColor.Asset.white
        self.avalidBalanceLabel.font = UIFont.asset(.medium, fontSize: .h4)
        self.avalidBalanceLabel.textColor = UIColor.Asset.denger
        self.totalBalanceLabel.font = UIFont.asset(.medium, fontSize: .h4)
        self.totalBalanceLabel.textColor = UIColor.Asset.white
        self.buttonLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.buttonLabel.textColor = UIColor.Asset.white
        self.buttonCashLabel.font = UIFont.asset(.medium, fontSize: .h4)
        self.buttonCashLabel.textColor = UIColor.Asset.white
        self.iconImage.image = UIImage.init(icon: .castcle(.farm), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.buttonView.custom(color: UIColor.Asset.warning, cornerRadius: 10)
        self.historyButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.historyButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        
        self.contentView.custom(borderWidth: 1, borderColor: UIColor.Asset.gray)
        self.avatarImage.circle()
        self.avatarImage.image = UIImage.Asset.userPlaceholder
        self.contentImage.image = UIImage.Asset.placeholder
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.balanceTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.balanceTitleLabel.textColor = UIColor.Asset.white
        self.balanceLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.balanceLabel.textColor = UIColor.Asset.lightBlue
        self.dateLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.dateLabel.textColor = UIColor.Asset.white
        self.messageLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.messageLabel.textColor = UIColor.Asset.white
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.farmingLimitViewController(didAction: self)
    }
    
    @IBAction func historyAction(_ sender: Any) {
    }
}

extension FarmingLimitViewController: PanModalPresentable {
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
