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
//  LongTextLinkTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 9/9/2564 BE.
//

import UIKit
import Core
import Networking
import Nantes
import SkeletonView

public class LongTextLinkTableViewCell: UITableViewCell {

    @IBOutlet var detailLabel: NantesLabel!
    @IBOutlet var linkContainer: UIView!
    @IBOutlet var titleLinkView: UIView!
    @IBOutlet var linkImage: UIImageView!
    @IBOutlet var linkTitleLabel: UILabel!
    @IBOutlet var linkDescriptionLabel: UILabel!
    @IBOutlet var skeletonView: UIView!

    private var content: Content?

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.skeletonView.custom(cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.gray)
        self.linkContainer.custom(cornerRadius: 12, borderWidth: 1, borderColor: UIColor.Asset.gray)
        self.linkContainer.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.titleLinkView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.linkTitleLabel.font = UIFont.asset(.contentBold, fontSize: .overline)
        self.linkTitleLabel.textColor = UIColor.Asset.white
        self.linkDescriptionLabel.font = UIFont.asset(.contentLight, fontSize: .small)
        self.linkDescriptionLabel.textColor = UIColor.Asset.lightGray
        self.skeletonView.showAnimatedGradientSkeleton(usingGradient: SkeletonGradient(baseColor: UIColor.Asset.gray))
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(content: Content?) {
        guard let content = content else { return }
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue,
                          NSAttributedString.Key.font: UIFont.asset(.contentLight, fontSize: .body)]
        self.detailLabel.attributedTruncationToken = NSAttributedString(string: " \(Localization.ContentDetail.readMore.text)", attributes: attributes)
        self.detailLabel.numberOfLines = 2
        self.detailLabel.font = UIFont.asset(.contentLight, fontSize: .body)
        self.detailLabel.textColor = UIColor.Asset.white
        self.detailLabel.text = content.message
        self.content = content
        self.skeletonView.isHidden = false
        self.linkContainer.isHidden = true

        if let link = content.link.first {
            var title: String = ""
            var desc: String = ""
            if link.title.isEmpty && link.desc.isEmpty {
                title = content.message
                desc = ""
            } else {
                title = link.title
                desc = link.desc
            }
            self.setDataWithContent(icon: link.type.image, title: title, desc: desc)
        }
    }

    private func setDataWithContent(icon: UIImage, title: String, desc: String) {
        self.skeletonView.isHidden = true
        self.linkContainer.isHidden = false
        self.linkImage.image = icon
        self.linkTitleLabel.text = title
        self.linkDescriptionLabel.text = desc
    }

    @IBAction func openWebViewAction(_ sender: Any) {
        guard let content = self.content else { return }
        if let link = content.link.first, let linkUrl = URL(string: link.url) {
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(linkUrl)), animated: true)
        }
    }
}
