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
//  ViewCastTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 4/5/2565 BE.
//

import UIKit
import Core

class ViewCastTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var viewButton: UIButton!
    
    private var contentId: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.titleLabel.textColor = UIColor.Asset.white
        self.viewButton.titleLabel?.font = UIFont.asset(.regular, fontSize: .overline)
        self.viewButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.viewButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.viewButton.custom(cornerRadius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configCell(contentId: String) {
        self.titleLabel.text = "View Original Cast"
        self.contentId = contentId
    }
    
    @IBAction func viewAction(_ sender: Any) {
        let castDict: [String: String] = [
            JsonKey.contentId.rawValue: contentId
        ]
        NotificationCenter.default.post(name: .openCastDelegate, object: nil, userInfo: castDict)
    }
}
