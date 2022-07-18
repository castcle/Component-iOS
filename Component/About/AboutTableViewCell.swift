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
//  AboutTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 18/7/2565 BE.
//

import UIKit
import Core
import ActiveLabel
import Defaults

public class AboutTableViewCell: UITableViewCell {

    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var otherLabel: ActiveLabel!
    @IBOutlet var termLabel: ActiveLabel!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var twitterButton: UIButton!
    @IBOutlet var mediumButton: UIButton!
    @IBOutlet var telegramButton: UIButton!
    @IBOutlet var githubButton: UIButton!
    @IBOutlet var discordButton: UIButton!

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.versionLabel.font = UIFont.asset(.light, fontSize: .overline)
        self.versionLabel.textColor = UIColor.Asset.white
        self.facebookButton.setImage(UIImage.init(icon: .castcle(.facebook), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.twitterButton.setImage(UIImage.init(icon: .castcle(.twitter), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.mediumButton.setImage(UIImage.init(icon: .castcle(.medium), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.telegramButton.setImage(UIImage.init(icon: .castcle(.direct), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.githubButton.setImage(UIImage.init(icon: .castcle(.github), size: CGSize(width: 27, height: 27), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
        self.discordButton.setImage(UIImage.init(icon: .castcle(.discord), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightGray).withRenderingMode(.alwaysOriginal), for: .normal)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func configCell() {
        self.otherLabel.text = "\(Localization.CastcleAbout.joinUs.text) | \(Localization.CastcleAbout.docs.text) | \(Localization.CastcleAbout.whitepaper.text)"
        self.versionLabel.text = "\(Localization.CastcleAbout.version.text) \(Defaults[.appVersion]) (\(Defaults[.appBuild]))"
        self.termLabel.text = "\(Localization.CastcleAbout.termOfService.text) | \(Localization.CastcleAbout.privacy.text)"
        self.otherLabel.customize { label in
            label.font = UIFont.asset(.light, fontSize: .overline)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.gray
            let joinUsType = ActiveType.custom(pattern: Localization.CastcleAbout.joinUs.text)
            let docsType = ActiveType.custom(pattern: Localization.CastcleAbout.docs.text)
            let whitepaperType = ActiveType.custom(pattern: Localization.CastcleAbout.whitepaper.text)
            label.enabledTypes = [joinUsType, docsType, whitepaperType]
            label.customColor[joinUsType] = UIColor.Asset.lightBlue
            label.customSelectedColor[joinUsType] = UIColor.Asset.gray
            label.customColor[docsType] = UIColor.Asset.lightBlue
            label.customSelectedColor[docsType] = UIColor.Asset.gray
            label.customColor[whitepaperType] = UIColor.Asset.lightBlue
            label.customSelectedColor[whitepaperType] = UIColor.Asset.gray
            label.handleCustomTap(for: joinUsType) { _ in
                self.openWebView(urlString: Environment.joinUs)
            }
            label.handleCustomTap(for: docsType) { _ in
                self.openWebView(urlString: Environment.docs)
            }
            label.handleCustomTap(for: whitepaperType) { _ in
                self.openWebView(urlString: Environment.whitepaper)
            }
        }

        self.termLabel.customize { label in
            label.font = UIFont.asset(.light, fontSize: .overline)
            label.numberOfLines = 1
            label.textColor = UIColor.Asset.gray
            let termType = ActiveType.custom(pattern: Localization.CastcleAbout.termOfService.text)
            let privacyType = ActiveType.custom(pattern: Localization.CastcleAbout.privacy.text)
            label.enabledTypes = [termType, privacyType]
            label.customColor[termType] = UIColor.Asset.lightBlue
            label.customSelectedColor[termType] = UIColor.Asset.gray
            label.customColor[privacyType] = UIColor.Asset.lightBlue
            label.customSelectedColor[privacyType] = UIColor.Asset.gray
            label.handleCustomTap(for: termType) { _ in
                self.openWebView(urlString: Environment.userAgreement)
            }
            label.handleCustomTap(for: privacyType) { _ in
                self.openWebView(urlString: Environment.privacyPolicy)
            }
        }
    }

    @IBAction func facebookAction(_ sender: Any) {
        self.openWebView(urlString: CastcleSocial.facebook.path)
    }

    @IBAction func twitterAction(_ sender: Any) {
        self.openWebView(urlString: CastcleSocial.twitter.path)
    }

    @IBAction func mediumAction(_ sender: Any) {
        self.openWebView(urlString: CastcleSocial.medium.path)
    }

    @IBAction func telegramAction(_ sender: Any) {
        self.openWebView(urlString: CastcleSocial.telegram.path)
    }

    @IBAction func githubAction(_ sender: Any) {
        self.openWebView(urlString: CastcleSocial.github.path)
    }

    @IBAction func discordAction(_ sender: Any) {
        self.openWebView(urlString: CastcleSocial.discord.path)
    }

    private func openWebView(urlString: String) {
        Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: urlString)!)), animated: true)
    }
}
