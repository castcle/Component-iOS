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
//  CommentTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 8/9/2564 BE.
//

import UIKit
import Core
import Networking
import ActiveLabel

protocol CommentTableViewCellDelegate {
    func didReply(_ commentTableViewCell: CommentTableViewCell, comment: Comment, castcleId: String)
    func didEdit(_ commentTableViewCell: CommentTableViewCell, comment: Comment)
    func didLiked(_ commentTableViewCell: CommentTableViewCell, comment: Comment)
    func didUnliked(_ commentTableViewCell: CommentTableViewCell, comment: Comment)
}

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var replyButton: UIButton!
    @IBOutlet var topLineView: UIView!
    @IBOutlet var bottomLineView: UIView!
    @IBOutlet var commentLabel: ActiveLabel! {
        didSet {
            self.commentLabel.customize { label in
                label.font = UIFont.asset(.regular, fontSize: .overline)
                label.numberOfLines = 0
                label.enabledTypes = [.mention, .url, self.customHashtag]
                label.textColor = UIColor.Asset.white
                label.mentionColor = UIColor.Asset.lightBlue
                label.URLColor = UIColor.Asset.lightBlue
            }
        }
    }
    
    private let customHashtag = ActiveType.custom(pattern: RegexpParser.hashtagPattern)
    var comment: Comment? {
        didSet {
            guard let comment = self.comment else { return }
            self.commentLabel.text = comment.message
            if let authorRef = ContentHelper.shared.getAuthorRef(id: comment.authorId) {
                let url = URL(string: authorRef.avatar)
                self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
                self.displayNameLabel.text = authorRef.displayName
                
            } else {
                self.avatarImage.image = UIImage.Asset.userPlaceholder
                self.displayNameLabel.text = "Castcle"
            }

            self.dateLabel.text = comment.commentDate.timeAgoDisplay()
            self.commentLabel.customColor[self.customHashtag] = UIColor.Asset.lightBlue
            self.commentLabel.customSelectedColor[self.customHashtag] = UIColor.Asset.lightBlue
            
            self.commentLabel.handleCustomTap(for: self.customHashtag) { element in
                let hashtagDict: [String: String] = [
                    "hashtag":  element
                ]
                NotificationCenter.default.post(name: .openSearchDelegate, object: nil, userInfo: hashtagDict)
            }
            self.commentLabel.handleMentionTap { mention in
                let userDict: [String: String] = [
                    "castcleId":  mention
                ]
                NotificationCenter.default.post(name: .openProfileDelegate, object: nil, userInfo: userDict)
            }
            self.commentLabel.handleURLTap { url in
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(url)), animated: true)
            }
            
            self.updateUi(isAction: false)
        }
    }
    
    var delegate: CommentTableViewCellDelegate?
    private var isShowActionSheet: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.bold, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.dateLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.dateLabel.textColor = UIColor.Asset.lightGray
        self.replyButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .small)
        self.replyButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.topLineView.backgroundColor = UIColor.Asset.gray
        self.bottomLineView.backgroundColor = UIColor.Asset.gray
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.commentLabel.addGestureRecognizer(longPressRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if !self.isShowActionSheet {
            self.isShowActionSheet = true
            self.showActionSheet()
        }
    }
    
    private func showActionSheet() {
        guard let comment = self.comment else { return }
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Reply", style: .default , handler: { (UIAlertAction) in
            self.isShowActionSheet = false
            if let authorRef = ContentHelper.shared.getAuthorRef(id: comment.authorId) {
                self.delegate?.didReply(self, comment: comment, castcleId: authorRef.castcleId)
            } else {
                self.delegate?.didReply(self, comment: comment, castcleId: "")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler: { (UIAlertAction) in
            self.isShowActionSheet = false
            self.delegate?.didEdit(self, comment: comment)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler: { (UIAlertAction) in
            self.isShowActionSheet = false
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            self.isShowActionSheet = false
            print("User click Cancel button")
        }))

        // uncomment for iPad Support
        // alert.popoverPresentationController?.sourceView = self.view

        Utility.currentViewController().present(alert, animated: true)
    }
    @IBAction func replyAction(_ sender: Any) {
        guard let comment = self.comment else { return }
        if let authorRef = ContentHelper.shared.getAuthorRef(id: comment.authorId) {
            self.delegate?.didReply(self, comment: comment, castcleId: authorRef.castcleId)
        } else {
            self.delegate?.didReply(self, comment: comment, castcleId: "")
        }
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            guard let comment = self.comment else { return }

            if comment.participate.liked {
                self.delegate?.didUnliked(self, comment: comment)
            } else {
                self.delegate?.didLiked(self, comment: comment)
            }

            comment.participate.liked.toggle()
            self.updateUi(isAction: true)
            
            if comment.participate.liked {
                let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
                impliesAnimation.duration = 0.3 * 2
                impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
                self.likeLabel.layer.add(impliesAnimation, forKey: nil)
            }
        }
    }
    
    private func updateUi(isAction: Bool) {
        guard let comment = self.comment else { return }
        
        self.likeLabel.font = UIFont.asset(.regular, fontSize: .small)
        var likeCount = comment.metrics.likeCount
        if comment.participate.liked {
            if isAction {
                likeCount += 1
            }
            let displayLike: String = (likeCount > 0 ? "  \(String.displayCount(count: likeCount))" : "")
            self.likeLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.like), iconColor: UIColor.Asset.lightBlue, postfixText: displayLike, postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 14)
        } else {
            if isAction {
                likeCount -= 1
            }
            let displayLike: String = (likeCount > 0 ? "  \(String.displayCount(count: likeCount))" : "")
            self.likeLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.like), iconColor: UIColor.Asset.white, postfixText: displayLike, postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 14)
        }
    }
}
