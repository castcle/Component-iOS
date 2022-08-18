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
//  IllegalActionTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 9/8/2565 BE.
//

import UIKit
import Core
import Networking
import ActiveLabel
import JGProgressHUD

public protocol IllegalActionTableViewCellDelegate: AnyObject {
    func didAppeal(_ illegalActionTableViewCell: IllegalActionTableViewCell)
    func didRemove(_ illegalActionTableViewCell: IllegalActionTableViewCell)
}

public class IllegalActionTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var blockImage: UIImageView!
    @IBOutlet weak var illegalTitleLabel: UILabel!
    @IBOutlet weak var illegalDetailLabel: ActiveLabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var illegalView: UIView!

    public var delegate: IllegalActionTableViewCellDelegate?
    private let customTerms = ActiveType.custom(pattern: "Castcle Terms and Agreement")
    private var reportRepository: ReportRepository = ReportRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    private var content: Content = Content()
    private var state: State = .none
    private let hud = JGProgressHUD()

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.hud.textLabel.text = "Sending"
        self.illegalView.custom(color: UIColor.Asset.black, cornerRadius: 12)
        self.blockImage.image = UIImage.init(icon: .castcle(.blockedUsers), size: CGSize(width: 50, height: 50), textColor: UIColor.Asset.white)
        self.contentLabel.font = UIFont.asset(.contentLight, fontSize: .body)
        self.contentLabel.textColor = UIColor.Asset.textGray
        self.illegalTitleLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.illegalTitleLabel.textColor = UIColor.Asset.white
        self.yesButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .overline)
        self.yesButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.yesButton.capsule(color: UIColor.Asset.lightBlue, borderWidth: 1, borderColor: UIColor.clear)
        self.noButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .overline)
        self.noButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        self.noButton.capsule(color: UIColor.clear, borderWidth: 1, borderColor: UIColor.Asset.lightBlue)
        self.illegalDetailLabel.customize { label in
            label.font = UIFont.asset(.contentLight, fontSize: .overline)
            label.numberOfLines = 0
            label.enabledTypes = [self.customTerms]
            label.textColor = UIColor.Asset.white
            label.customColor[self.customTerms] = UIColor.Asset.lightBlue
            label.customSelectedColor[self.customTerms] = UIColor.Asset.lightBlue
        }
        self.illegalDetailLabel.handleCustomTap(for: self.customTerms) { _ in
            Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: Environment.userAgreement)!)), animated: true)
        }
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    public func configCell(content: Content) {
        self.tokenHelper.delegate = self
        self.contentLabel.text = (content.message.isEmpty ? "" : "\(content.message)\n")
        self.content = content
        if content.feedDisplayType == .postImageX1 || content.feedDisplayType == .postImageX2 || content.feedDisplayType == .postImageX3 || content.feedDisplayType == .postImageXMore {
            self.illegalView.backgroundColor = UIColor.Asset.black
        } else {
            self.illegalView.backgroundColor = UIColor.clear
        }
    }

    @IBAction func yesAction(_ sender: Any) {
        let alert = UIAlertController(title: "Thank you", message: "We will notify you once this Cast is reviewed.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.hud.show(in: Utility.currentViewController().view)
            self.appealCast()
        }
        alert.addAction(okAction)
        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }

    @IBAction func noAction(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "This Cast will be permanently deleted from your timeline.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.hud.show(in: Utility.currentViewController().view)
            self.notAppealCast()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        Utility.currentViewController().present(alert, animated: true, completion: nil)
    }

    private func notAppealCast() {
        self.state = .notAppealCast
        self.reportRepository.notAppealCast(contentId: self.content.id) { (success, _, isRefreshToken) in
            if success {
                self.hud.dismiss()
                self.delegate?.didRemove(self)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.hud.dismiss()
                }
            }
        }
    }

    private func appealCast() {
        self.state = .appealCast
        self.reportRepository.appealCast(contentId: self.content.id) { (success, _, isRefreshToken) in
            if success {
                self.hud.dismiss()
                self.delegate?.didAppeal(self)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                } else {
                    self.hud.dismiss()
                }
            }
        }
    }
}

extension IllegalActionTableViewCell: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .notAppealCast {
            self.notAppealCast()
        } else if self.state == .appealCast {
            self.appealCast()
        }
    }
}
