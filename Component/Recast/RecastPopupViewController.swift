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
//  Created by Tanakorn Phoochaliaw on 22/7/2564 BE.
//

import UIKit
import Core
import PanModal
import Kingfisher

public protocol RecastPopupViewControllerDelegate {
    func recastPopupViewController(_ view: RecastPopupViewController, didSelectRecastAction recastAction: RecastAction)
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
    
    var delegate: RecastPopupViewControllerDelegate?
    var maxHeight = (UIScreen.main.bounds.height - 320)
    var viewModel = RecastPopupViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        
        let url = URL(string: UserState.shared.avatar)
        self.avatarImage.kf.setImage(with: url)
        self.recastImage.image = UIImage.init(icon: .castcle(.recast), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white)
        self.quoteCastImage.image = UIImage.init(icon: .castcle(.pencil), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white)
        
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.subTitleLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.subTitleLabel.textColor = UIColor.Asset.lightGray
        self.recastLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.recastLabel.textColor = UIColor.Asset.white
        self.quoteCastLabel.font = UIFont.asset(.medium, fontSize: .body)
        self.quoteCastLabel.textColor = UIColor.Asset.white
        
        if self.viewModel.isRecasted {
            self.recastLabel.text = "Unrecasted"
        } else {
            self.recastLabel.text = "Recasted"
        }
    }
    
    @IBAction func recastAction(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.recastPopupViewController(self, didSelectRecastAction: .recast)
    }
    
    @IBAction func quoteCastAction(_ sender: Any) {
        self.dismiss(animated: true)
        self.delegate?.recastPopupViewController(self, didSelectRecastAction: .quoteCast)
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
