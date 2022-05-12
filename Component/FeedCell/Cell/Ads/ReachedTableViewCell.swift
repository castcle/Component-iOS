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
//  ReachedTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 6/2/2565 BE.
//

import UIKit
import Core
import GTProgressBar

public class ReachedTableViewCell: UITableViewCell {

    @IBOutlet weak var bootButton: UIButton!
    @IBOutlet weak var reachedLabel: UILabel!
    @IBOutlet weak var barView: GTProgressBar!

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.reachedLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.reachedLabel.textColor = UIColor.Asset.white
        self.bootButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.bootButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.bootButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.bootButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.clear)
        self.barView.progress = 0.65
        self.barView.barBorderColor = UIColor.clear
        self.barView.barFillColor = UIColor.Asset.lightBlue
        self.barView.barBackgroundColor = UIColor.Asset.lightGray
        self.barView.barBorderWidth = 0
        self.barView.barFillInset = 0
        self.barView.displayLabel = false
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func bootAction(_ sender: Any) {
        let alert = UIAlertController(title: "Error", message: "Waiting for implementation", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }
}
