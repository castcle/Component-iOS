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
//  ReplyTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 8/9/2564 BE.
//

import UIKit
import Core
import Networking
import ActiveLabel
import RealmSwift

protocol ReplyTableViewCellDelegate: AnyObject {
    func didEdit(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef)
    func didDelete(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef, originalCommentId: String)
    func didLiked(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef)
    func didUnliked(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef)
}

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var lineView: UIView!
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

    var delegate: ReplyTableViewCellDelegate?
    private let customHashtag = ActiveType.custom(pattern: RegexpParser.hashtagPattern)
    private var commentRef = CommentRef()
    private var isShowActionSheet: Bool = false
    private var originalCommentId: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImage.circle(color: UIColor.Asset.white)
        self.displayNameLabel.font = UIFont.asset(.bold, fontSize: .overline)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.dateLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.dateLabel.textColor = UIColor.Asset.lightGray
        self.lineView.backgroundColor = UIColor.Asset.gray
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.commentLabel.addGestureRecognizer(longPressRecognizer)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(replyCommentId: String, originalCommentId: String) {
        self.originalCommentId = originalCommentId
        if let commentRef = CommentHelper.shared.getCommentRef(id: replyCommentId) {
            self.commentRef = commentRef
            self.commentLabel.text =  self.commentRef.message

            if let authorRef = ContentHelper.shared.getAuthorRef(id: self.commentRef.authorId) {
                let url = URL(string: authorRef.avatar)
                self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
                self.displayNameLabel.text = authorRef.displayName
            } else {
                self.avatarImage.image = UIImage.Asset.userPlaceholder
                self.displayNameLabel.text = "Castcle"
            }

            self.dateLabel.text = self.commentRef.commentDate.timeAgoDisplay()
            self.commentLabel.customColor[self.customHashtag] = UIColor.Asset.lightBlue
            self.commentLabel.customSelectedColor[self.customHashtag] = UIColor.Asset.lightBlue

            self.commentLabel.handleCustomTap(for: self.customHashtag) { element in
                let hashtagDict: [String: String] = [
                    JsonKey.hashtag.rawValue: element
                ]
                NotificationCenter.default.post(name: .openSearchDelegate, object: nil, userInfo: hashtagDict)
            }
            self.commentLabel.handleMentionTap { mention in
                let userDict: [String: String] = [
                    JsonKey.castcleId.rawValue: mention
                ]
                NotificationCenter.default.post(name: .openProfileDelegate, object: nil, userInfo: userDict)
            }
            self.commentLabel.handleURLTap { url in
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(url)), animated: true)
            }
            self.updateUi(isAction: false)
        } else {
            return
        }
    }

    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if UserHelper.shared.isMyAccount(id: self.commentRef.authorId) {
            if !self.isShowActionSheet {
                self.isShowActionSheet = true
                self.showActionSheet()
            }
        }
    }

    private func showActionSheet() {
        let actionSheet = CCActionSheet(isGestureDismiss: false)
        let cancelButton = CCAction(title: "Cancel", image: UIImage.init(icon: .castcle(.incorrect), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
            actionSheet.dismissActionSheet()
            self.isShowActionSheet = false
        }
        actionSheet.addActions([cancelButton])
        let deleteButton = CCAction(title: "Delete", image: UIImage.init(icon: .castcle(.deleteOne), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white), style: .default) {
            actionSheet.dismissActionSheet()
            self.isShowActionSheet = false
            self.delegate?.didDelete(self, replyComment: self.commentRef, originalCommentId: self.originalCommentId)
        }
        actionSheet.addActions([deleteButton])
        Utility.currentViewController().present(actionSheet, animated: true)
    }

    @IBAction func likeAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            if self.commentRef.liked {
                self.delegate?.didUnliked(self, replyComment: self.commentRef)
            } else {
                self.delegate?.didLiked(self, replyComment: self.commentRef)
            }
            do {
                let realm = try Realm()
                try realm.write {
                    self.commentRef.liked.toggle()
                }
            } catch {}
            self.updateUi(isAction: true)

            if self.commentRef.liked {
                let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                impliesAnimation.values = [1.0, 1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
                impliesAnimation.duration = 0.3 * 2
                impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
                self.likeLabel.layer.add(impliesAnimation, forKey: nil)
            }
        }
    }

    private func updateUi(isAction: Bool) {
        self.likeLabel.font = UIFont.asset(.regular, fontSize: .small)
        var likeCount = self.commentRef.likeCount
        if self.commentRef.liked {
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
