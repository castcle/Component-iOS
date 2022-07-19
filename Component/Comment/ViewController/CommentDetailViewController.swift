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
//  CommentDetailViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 4/5/2565 BE.
//

import UIKit
import Core
import Networking
import Defaults
import JGProgressHUD

class CommentDetailViewController: UITableViewController, UITextViewDelegate {

    var viewModel = CommentDetailViewModel()
    var customInputView: UIView!
    var sendButton: UIButton!
    var avatarImage: UIImageView!
    let commentTextField = FlexibleTextView()
    let hud = JGProgressHUD()

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var inputAccessoryView: UIView? {
        if self.customInputView == nil {
            self.customInputView = CustomView()
            self.customInputView.backgroundColor = UIColor.Asset.cellBackground
            self.commentTextField.placeholder = "Write your reply"
            self.commentTextField.font = UIFont.asset(.regular, fontSize: .overline)
            self.commentTextField.textColor = UIColor.Asset.white
            self.commentTextField.autocorrectionType = .no
            self.commentTextField.custom(color: UIColor.Asset.darkGraphiteBlue, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)

            self.customInputView.autoresizingMask = .flexibleHeight
            self.customInputView.addSubview(self.commentTextField)

            self.sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            self.sendButton.setImage(UIImage.init(icon: .castcle(.direct), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
            self.sendButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.sendButton.capsule()
            self.sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            self.sendButton.clipsToBounds = true
            self.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            self.customInputView?.addSubview(self.sendButton)

            self.avatarImage = UIImageView()
            self.avatarImage.contentMode = .scaleAspectFill
            self.avatarImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

            let url = URL(string: UserManager.shared.avatar)
            self.avatarImage.kf.setImage(with: url, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
            self.avatarImage.capsule(borderWidth: 1, borderColor: UIColor.Asset.white)
            customInputView?.addSubview(self.avatarImage)

            self.commentTextField.translatesAutoresizingMaskIntoConstraints = false
            self.sendButton.translatesAutoresizingMaskIntoConstraints = false
            self.avatarImage.translatesAutoresizingMaskIntoConstraints = false
            self.sendButton.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            self.sendButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)

            self.avatarImage.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)
            self.avatarImage.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.horizontal)

            self.avatarImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
            self.avatarImage.heightAnchor.constraint(equalToConstant: 30).isActive = true

            self.commentTextField.maxHeight = 80

            self.avatarImage.leadingAnchor.constraint(equalTo: customInputView.leadingAnchor, constant: 20).isActive = true
            self.avatarImage.trailingAnchor.constraint(equalTo: self.commentTextField.leadingAnchor, constant: -15).isActive = true
            self.avatarImage.bottomAnchor.constraint(equalTo: customInputView.layoutMarginsGuide.bottomAnchor, constant: -17).isActive = true
            self.commentTextField.trailingAnchor.constraint(equalTo: self.sendButton.leadingAnchor, constant: -15).isActive = true
            self.commentTextField.topAnchor.constraint(equalTo: customInputView.topAnchor, constant: 15).isActive = true
            self.commentTextField.bottomAnchor.constraint(equalTo: customInputView.layoutMarginsGuide.bottomAnchor, constant: -15).isActive = true
            self.sendButton.trailingAnchor.constraint(equalTo: customInputView.trailingAnchor, constant: -20).isActive = true
            self.sendButton.bottomAnchor.constraint(equalTo: customInputView.layoutMarginsGuide.bottomAnchor, constant: -17).isActive = true
        }
        return self.customInputView
    }

    @objc func handleSend() {
        if !self.commentTextField.text.isEmpty {
            self.viewModel.commentRequest.message = self.commentTextField.text
            self.viewModel.commentRequest.contentId = self.viewModel.contentId
            self.hud.textLabel.text = "Replying"
            self.viewModel.replyComment()
            self.hud.show(in: self.view)
            self.commentTextField.text = ""
            self.commentTextField.resignFirstResponder()
        }
    }

    enum CommentSection: Int, CaseIterable {
        case comment = 0
        case reply
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.commentTextField.delegate = self
        self.setupNevBar()
        self.configureTableView()
        self.tableView.keyboardDismissMode = .interactive
        self.commentTextField.isEditable = false
        self.viewModel.didLoadCommentFinish = {
            self.hud.dismiss()
            self.viewModel.commentLoadState = .loaded
            self.enableTextField()
            self.tableView.isScrollEnabled = true
            if self.viewModel.meta.resultCount < self.viewModel.commentRequest.maxResults {
                self.tableView.coreRefresh.noticeNoMoreData()
            }
            UIView.transition(with: self.tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() })
        }

        self.viewModel.didDeleteCommentFinish = {
            Utility.currentViewController().navigationController?.popViewController(animated: true)
            ApiHelper.displayMessage(title: "Success", message: "Delete comment success")
        }

        self.tableView.coreRefresh.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            guard let self = self else { return }
            if self.viewModel.meta.resultCount < self.viewModel.commentRequest.maxResults {
                self.tableView.coreRefresh.noticeNoMoreData()
            } else {
                self.viewModel.commentRequest.untilId = self.viewModel.meta.oldestId
                self.viewModel.getCommentDetail()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }

    private func setupNevBar() {
        self.customNavigationBar(.secondary, title: "Comment")
    }

    func configureTableView() {
        self.tableView.isScrollEnabled = false
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.comment, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.comment)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.reply, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.reply)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.skeletonNotify, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.skeletonNotify)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.viewCast, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.viewCast)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 280
    }

    private func enableTextField() {
        if self.viewModel.commentLoadState == .loaded {
            self.commentTextField.isEditable = true
        }
    }
}

extension CommentDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.commentLoadState == .loading {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if self.viewModel.commentLoadState == .loading {
                return 1
            } else {
                return 1 + self.viewModel.replyList.count
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if self.viewModel.commentLoadState == .loading {
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.skeletonNotify, for: indexPath as IndexPath) as? SkeletonNotifyTableViewCell
                cell?.backgroundColor = UIColor.Asset.cellBackground
                cell?.configCell()
                return cell ?? SkeletonNotifyTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.viewCast, for: indexPath as IndexPath) as? ViewCastTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                cell?.configCell(contentId: self.viewModel.contentId)
                return cell ?? ViewCastTableViewCell()
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.comment, for: indexPath as IndexPath) as? CommentTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                cell?.delegate = self
                cell?.topLineView.isHidden = true
                cell?.bottomLineView.isHidden = true
                cell?.comment = self.viewModel.comment
                return cell ?? CommentTableViewCell()
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.reply, for: indexPath as IndexPath) as? ReplyTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                cell?.delegate = self
                cell?.configCell(replyCommentId: self.viewModel.replyList[indexPath.row - 1].id, originalCommentId: self.viewModel.comment.id)
                cell?.lineView.isHidden = true
                return cell ?? ReplyTableViewCell()
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 5))
            footerView.backgroundColor = UIColor.clear
            return footerView
        } else {
            return UIView()
        }
    }
}

extension CommentDetailViewController: CommentTableViewCellDelegate {
    func didReply(_ commentTableViewCell: CommentTableViewCell, comment: Comment, castcleId: String) {
        if !castcleId.isEmpty {
            self.commentTextField.text = "@\(castcleId) "
        }
        self.commentTextField.becomeFirstResponder()
    }

    func didEdit(_ commentTableViewCell: CommentTableViewCell, comment: Comment) {
        self.commentTextField.text = "\(comment.message)"
        self.commentTextField.becomeFirstResponder()
    }

    func didDelete(_ commentTableViewCell: CommentTableViewCell, comment: Comment) {
        self.hud.textLabel.text = "Deleting"
        self.hud.show(in: self.view)
        self.viewModel.deleteComment()
    }

    func didLiked(_ commentTableViewCell: CommentTableViewCell, comment: Comment) {
        self.viewModel.likeComment(isComment: true)
    }

    func didUnliked(_ commentTableViewCell: CommentTableViewCell, comment: Comment) {
        self.viewModel.unlikeComment(isComment: true)
    }
}

extension CommentDetailViewController: ReplyTableViewCellDelegate {
    func didEdit(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef) {
        self.commentTextField.text = "\(replyComment.message)"
        self.commentTextField.becomeFirstResponder()
    }

    func didDelete(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef, originalCommentId: String) {
        self.hud.textLabel.text = "Deleting"
        self.hud.show(in: self.view)
        self.viewModel.deleteReplyComment(replyId: replyComment.id)
    }

    func didLiked(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef) {
        self.viewModel.replyCommentId = replyComment.id
        self.viewModel.likeComment(isComment: false)
    }

    func didUnliked(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef) {
        self.viewModel.replyCommentId = replyComment.id
        self.viewModel.unlikeComment(isComment: false)
    }
}
