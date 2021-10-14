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
//  TextLinkPreviewTableViewCell.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 9/9/2564 BE.
//

import UIKit
import Core
import Networking
import ActiveLabel
import SwiftLinkPreview

public class TextLinkPreviewTableViewCell: UITableViewCell {

    @IBOutlet var detailLabel: ActiveLabel! {
        didSet {
            self.detailLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .body)
                label.numberOfLines = 0
                label.enabledTypes = [.mention, .hashtag, .url]
                label.textColor = UIColor.Asset.white
                label.hashtagColor = UIColor.Asset.lightBlue
                label.mentionColor = UIColor.Asset.lightBlue
                label.URLColor = UIColor.Asset.lightBlue
            }
        }
    }
    
    @IBOutlet var linkContainer: UIView!
    @IBOutlet var titleLinkView: UIView!
    @IBOutlet var linkImage: UIImageView!
    @IBOutlet var linkTitleLabel: UILabel!
    @IBOutlet var linkDescriptionLabel: UILabel!
    @IBOutlet var initImage: UIImageView!
    
    private var result = Response()
    private let slp = SwiftLinkPreview(cache: InMemoryCache())
    
    public var content: Content? {
        didSet {
            guard let content = self.content else { return }
            self.detailLabel.text = content.contentPayload.message
            self.detailLabel.handleHashtagTap { hashtag in
                let alert = UIAlertController(title: nil, message: "Go to hastag view", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                Utility.currentViewController().present(alert, animated: true, completion: nil)
            }
            self.detailLabel.handleMentionTap { mention in
                let alert = UIAlertController(title: nil, message: "Go to mention view", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                Utility.currentViewController().present(alert, animated: true, completion: nil)
            }
            self.detailLabel.handleURLTap { url in
                var urlString = url.absoluteString
                urlString = urlString.replacingOccurrences(of: "https://", with: "")
                urlString = urlString.replacingOccurrences(of: "http://", with: "")
                if let newUrl = URL(string: "https://\(urlString)") {
                    Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(newUrl)), animated: true)
                } else {
                    return
                }
            }
            
            self.initImage.image = UIImage.Asset.placeholder
            self.initImage.isHidden = false
            self.linkContainer.isHidden = true
            if let link = content.contentPayload.link.first {
                self.loadLink(link: link.url)
            } else if let link = content.contentPayload.message.detectedFirstLink {
                self.loadLink(link: link)
            } else {
                self.setData()
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.initImage.custom(cornerRadius: 12)
        self.linkContainer.custom(cornerRadius: 12)
        self.linkContainer.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.titleLinkView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.linkTitleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.linkTitleLabel.textColor = UIColor.Asset.white
        self.linkDescriptionLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.linkDescriptionLabel.textColor = UIColor.Asset.lightGray
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func loadLink(link: String) {
        if let cached = self.slp.cache.slp_getCachedResponse(url: link) {
            self.result = cached
            self.setData()
        } else {
            self.slp.preview(link, onSuccess: { result in
                self.result = result
                self.setData()
            }, onError: { error in
                self.setData()
            })
        }
    }
    
    private func setData() {
        UIView.transition(with: self, duration: 0.35, options: .transitionCrossDissolve, animations: {
            self.initImage.isHidden = true
            self.linkContainer.isHidden = false
        })
        
        // MARK: - Image
        if let value = self.result.image {
            let url = URL(string: value)
            self.linkImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.5))])
        } else {
            self.linkImage.image = UIImage.Asset.placeholder
        }
        
        // MARK: - Title
        if let value: String = self.result.title {
            self.linkTitleLabel.text = value.isEmpty ? "" : value
        } else {
            self.linkTitleLabel.text = ""
        }
        
        // MARK: - Description
        if let value: String = self.result.description {
            self.linkDescriptionLabel.text = value.isEmpty ? "" : value
        } else {
            self.linkDescriptionLabel.text = ""
        }
    }
    
    @IBAction func openWebViewAction(_ sender: Any) {
        if let value = self.result.url {
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(value)), animated: true)
        }
    }
}
