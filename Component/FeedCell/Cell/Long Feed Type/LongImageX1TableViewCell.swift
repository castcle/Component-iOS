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
//  LongImageX1TableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 9/9/2564 BE.
//

import UIKit
import Core
import Networking
import Nantes
import Lightbox

public class LongImageX1TableViewCell: UITableViewCell {

    @IBOutlet var detailLabel: NantesLabel!
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var displayImage: UIImageView!
    
    public var content: Content? {
        didSet {
            guard let content = self.content else { return }
            
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue,
                              NSAttributedString.Key.font: UIFont.asset(.contentLight, fontSize: .body)]
            self.detailLabel.attributedTruncationToken = NSAttributedString(string: " \(Localization.contentDetail.readMore.text)", attributes: attributes)
            self.detailLabel.numberOfLines = 2
            self.detailLabel.font = UIFont.asset(.contentLight, fontSize: .body)
            self.detailLabel.textColor = UIColor.Asset.white
            self.detailLabel.text = content.message
            
            if let imageUrl = content.photo.first {
                let url = URL(string: imageUrl.thumbnail)
                self.displayImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.imageContainer.custom(cornerRadius: 12)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func viewImageAction(_ sender: Any) {
        if let content = self.content, let image = content.photo.first {
            let images = [
                LightboxImage(imageURL: URL(string: image.fullHd)!)
            ]
            
            LightboxConfig.CloseButton.textAttributes = [
                .font: UIFont.asset(.bold, fontSize: .body),
                .foregroundColor: UIColor.Asset.white
              ]
            LightboxConfig.CloseButton.text = "Close"
            
            let controller = LightboxController(images: images)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.footerView.isHidden = true

            Utility.currentViewController().present(controller, animated: true, completion: nil)
        }
    }
}

extension LongImageX1TableViewCell: LightboxControllerPageDelegate {
    public func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        // MARK: - Lightbox Move Page
    }
}

extension LongImageX1TableViewCell: LightboxControllerDismissalDelegate {
    public func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // MARK: - Lightbox Dismiss
    }
}
