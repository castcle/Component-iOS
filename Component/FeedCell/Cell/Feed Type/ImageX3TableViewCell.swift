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
//  ImageX3TableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 9/9/2564 BE.
//

import UIKit
import Core
import Networking
import ActiveLabel
import Lightbox
import Kingfisher

public class ImageX3TableViewCell: UITableViewCell {

    @IBOutlet var detailLabel: ActiveLabel! {
        didSet {
            self.detailLabel.customize { label in
                label.font = UIFont.asset(.contentLight, fontSize: .body)
                label.numberOfLines = 0
                label.enabledTypes = [.mention, .url, self.customHashtag]
                label.textColor = UIColor.Asset.white
                label.mentionColor = UIColor.Asset.lightBlue
                label.URLColor = UIColor.Asset.lightBlue
                label.customColor[self.customHashtag] = UIColor.Asset.lightBlue
                label.customSelectedColor[self.customHashtag] = UIColor.Asset.lightBlue
            }
        }
    }
    
    @IBOutlet var imageContainer: UIView!
    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!
    
    private let customHashtag = ActiveType.custom(pattern: RegexpParser.hashtagPattern)
    public var content: Content? {
        didSet {
            guard let content = self.content else { return }
            self.detailLabel.text = content.message
            
//            self.detailLabel.handleCustomTap(for: self.customHashtag) { element in
//            }
//            self.detailLabel.handleMentionTap { mention in
//            }
            self.detailLabel.handleURLTap { url in
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(url)), animated: true)
            }
            
            if content.photo.count >= 3 {
                let firstUrl = URL(string: content.photo[0].thumbnail)
                self.firstImageView.kf.setImage(with: firstUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
                
                let secondUrl = URL(string: content.photo[1].thumbnail)
                self.secondImageView.kf.setImage(with: secondUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
                
                let thirdUrl = URL(string: content.photo[2].thumbnail)
                self.thirdImageView.kf.setImage(with: thirdUrl, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
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
    
    @IBAction func viewFirstImageAction(_ sender: Any) {
        self.openImage(index: 0)
    }
    
    @IBAction func viewSecondImageAction(_ sender: Any) {
        self.openImage(index: 1)
    }
    
    @IBAction func viewThirdImageAction(_ sender: Any) {
        self.openImage(index: 2)
    }
    
    private func openImage(index: Int) {
        if let content = self.content, !content.photo.isEmpty {
            
            var images: [LightboxImage] = []
            content.photo.forEach { photo in
                images.append(LightboxImage(imageURL: URL(string: photo.fullHd)!))
            }
            
            LightboxConfig.CloseButton.textAttributes = [
                .font: UIFont.asset(.bold, fontSize: .body),
                .foregroundColor: UIColor.Asset.white
              ]
            LightboxConfig.CloseButton.text = "Close"
            
            let controller = LightboxController(images: images, startIndex: index)
            controller.pageDelegate = self
            controller.dismissalDelegate = self
            controller.dynamicBackground = true
            controller.footerView.isHidden = true

            Utility.currentViewController().present(controller, animated: true, completion: nil)
        }
    }
}

extension ImageX3TableViewCell: LightboxControllerPageDelegate {
    public func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        // MARK: - Lightbox Move Page
    }
}

extension ImageX3TableViewCell: LightboxControllerDismissalDelegate {
    public func lightboxControllerWillDismiss(_ controller: LightboxController) {
        // MARK: - Lightbox Dismiss
    }
}
