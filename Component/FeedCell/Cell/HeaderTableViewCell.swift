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
//  HeaderTableViewCell.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 7/9/2564 BE.
//

import UIKit
import Core
import Networking
import SnackBar_swift
import Kingfisher

public protocol HeaderTableViewCellDelegate {
    func didTabProfile(_ headerTableViewCell: HeaderTableViewCell)
    func didAuthen(_ headerTableViewCell: HeaderTableViewCell)
    func didRemoveSuccess(_ headerTableViewCell: HeaderTableViewCell)
}

public class HeaderTableViewCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var globalIcon: UIImageView!
    @IBOutlet var verifyIcon: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    
    public var delegate: HeaderTableViewCellDelegate?
    private var contentRepository: ContentRepository = ContentRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    
    public var content: Content? {
        didSet {
            if let content = self.content {
                let url = URL(string: content.author.avatar)
                self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.5))])
                self.displayNameLabel.text = content.author.displayName
                self.dateLabel.text = content.postDate.timeAgoDisplay()
                if UserManager.shared.rawCastcleId == content.author.castcleId {
                    self.moreButton.isHidden = false
                    self.followButton.isHidden = true
                } else {
                    self.moreButton.isHidden = true
                    if content.author.followed {
                        self.followButton.isHidden = true
                    } else {
                        self.followButton.isHidden = false
                    }
                }
            } else {
                return
            }
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.tokenHelper.delegate = self
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.medium, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.dateLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.dateLabel.textColor = UIColor.Asset.lightGray
        self.followButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .overline)
        self.followButton.setTitleColor(UIColor.Asset.lightBlue, for: .normal)
        
        self.verifyIcon.image = UIImage.init(icon: .castcle(.verify), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightBlue)
        self.globalIcon.image = UIImage.init(icon: .castcle(.global), size: CGSize(width: 15, height: 15), textColor: UIColor.Asset.lightGray)
        
        self.moreButton.setImage(UIImage.init(icon: .castcle(.ellipsisV), size: CGSize(width: 22, height: 22), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func followAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            guard let content = self.content else { return }
            self.followButton.isHidden = true
            HeaderSnackBar.make(in: Utility.currentViewController().view, message: "You've followed @\(content.author.castcleId)", duration: .lengthLong).setAction(with: "Undo", action: {
                self.followButton.isHidden = false
            }).show()
        } else {
            self.delegate?.didAuthen(self)
        }
    }
    
    @IBAction func viewProfileAction(_ sender: Any) {
        self.delegate?.didTabProfile(self)
    }
    
    @IBAction func moreAction(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler: { (UIAlertAction) in
            self.deleteContent()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
        }))

        Utility.currentViewController().present(alert, animated: true)
    }
    
    private func deleteContent() {
        guard let content = self.content else { return }
        self.contentRepository.deleteContent(contentId: content.id) { (success, response, isRefreshToken) in
            if success {
                self.delegate?.didRemoveSuccess(self)
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
}

extension HeaderTableViewCell: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        self.deleteContent()
    }
}

class HeaderSnackBar: SnackBar {
    override var style: SnackBarStyle {
        var customStyle = SnackBarStyle()
        customStyle.background = UIColor.Asset.darkGray
        customStyle.textColor = UIColor.Asset.white
        customStyle.font = UIFont.asset(.medium, fontSize: .overline)
        
        customStyle.actionTextColor = UIColor.Asset.lightBlue
        customStyle.actionFont = UIFont.asset(.medium, fontSize: .body)
        customStyle.actionTextColorAlpha = 1.0
        
        return customStyle
    }
}
