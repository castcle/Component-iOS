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
//  CommentViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 2/9/2564 BE.
//

import UIKit
import Core
import Networking
import Defaults
import JGProgressHUD

class CommentViewController: UITableViewController, UITextViewDelegate {

    var viewModel = CommentViewModel()
    var customInputView: UIView!
    var sendButton: UIButton!
    var avatarImage: UIImageView!
    let commentTextField = FlexibleTextView()
    let hud = JGProgressHUD()
    var event: Event = .none

    enum Event {
        case create
        case reply
        case none
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var inputAccessoryView: UIView? {
        if self.customInputView == nil {
            self.customInputView = CustomView()
            self.customInputView.backgroundColor = UIColor.Asset.cellBackground
            self.commentTextField.placeholder = "What's on your mind?"
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
            self.viewModel.commentRequest.contentId = self.viewModel.content.id
            if self.event == .create {
                self.hud.textLabel.text = "Commenting"
                self.viewModel.createComment()
            } else if self.event == .reply {
                self.hud.textLabel.text = "Replying"
                self.viewModel.replyComment()
            }
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
        self.viewModel.didLoadCommentsFinish = {
            self.hud.dismiss()
            self.viewModel.commentLoadState = .loaded
            self.enableTextField()
            self.tableView.isScrollEnabled = true
            self.event = .create
            if self.viewModel.meta.resultCount < self.viewModel.commentRequest.maxResults {
                self.tableView.coreRefresh.noticeNoMoreData()
            }
            UIView.transition(with: self.tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() })
        }

        self.viewModel.didLoadContentFinish = {
            self.setupNevBar()
            self.viewModel.contentLoadState = .loaded
            self.enableTextField()
            UIView.transition(with: self.tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() })
        }

        self.tableView.coreRefresh.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            guard let self = self else { return }
            if self.viewModel.meta.resultCount < self.viewModel.commentRequest.maxResults {
                self.tableView.coreRefresh.noticeNoMoreData()
            } else {
                self.viewModel.commentRequest.untilId = self.viewModel.meta.oldestId
                self.viewModel.getComments()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.commentTextField.becomeFirstResponder()
    }

    private func setupNevBar() {
        if !self.viewModel.content.authorId.isEmpty, let authorRef = ContentHelper.shared.getAuthorRef(id: self.viewModel.content.authorId) {
            self.customNavigationBar(.secondary, title: "Cast of \(authorRef.displayName)")
        } else {
            self.customNavigationBar(.secondary, title: "Cast")
        }
    }

    func configureTableView() {
        self.tableView.isScrollEnabled = false
        self.tableView.registerFeedCell()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.comment, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.comment)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.reply, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.reply)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.reactionCast, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.reactionCast)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 280
    }

    private func enableTextField() {
        if self.viewModel.contentLoadState == .loaded && self.viewModel.commentLoadState == .loaded {
            self.commentTextField.isEditable = true
        }
    }
}

extension CommentViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.viewModel.commentLoadState == .loading {
            return 2
        } else {
            return (2 + self.viewModel.comments.count)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.viewModel.contentLoadState == .loading {
                return 1
            } else {
                if self.viewModel.content.referencedCasts.type == .quoted {
                    return 4
                } else {
                    return 3
                }
            }
        } else if section == 1 {
            if self.viewModel.commentLoadState == .loading {
                return 0
            } else {
                if self.viewModel.content.metrics.likeCount == 0 && self.viewModel.content.metrics.recastCount == 0 && self.viewModel.content.metrics.quoteCount == 0 {
                    return 0
                } else {
                    return 1
                }
            }
        } else {
            if self.viewModel.commentLoadState == .loading {
                return 1
            } else {
                return 1 + self.viewModel.comments[section - 2].reply.count
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if self.viewModel.contentLoadState == .loading {
                return FeedCellHelper().renderSkeletonCell(tableView: tableView, indexPath: indexPath)
            } else {
                if self.viewModel.content.referencedCasts.type == .quoted {
                    if indexPath.row == 0 {
                        return self.renderFeedCell(content: self.viewModel.content, cellType: .header, tableView: tableView, indexPath: indexPath)
                    } else if indexPath.row == 1 {
                        return self.renderFeedCell(content: self.viewModel.content, cellType: .content, tableView: tableView, indexPath: indexPath)
                    } else if indexPath.row == 2 {
                        return self.renderFeedCell(content: self.viewModel.content, cellType: .quote, tableView: tableView, indexPath: indexPath)
                    } else {
                        return self.renderFeedCell(content: self.viewModel.content, cellType: .footer, tableView: tableView, indexPath: indexPath)
                    }
                } else {
                    if indexPath.row == 0 {
                        return self.renderFeedCell(content: self.viewModel.content, cellType: .header, tableView: tableView, indexPath: indexPath)
                    } else if indexPath.row == 1 {
                        return self.renderFeedCell(content: self.viewModel.content, cellType: .content, tableView: tableView, indexPath: indexPath)
                    } else {
                        return self.renderFeedCell(content: self.viewModel.content, cellType: .footer, tableView: tableView, indexPath: indexPath)
                    }
                }
            }
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.reactionCast, for: indexPath as IndexPath) as? ReactionCastTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(content: self.viewModel.content)
            return cell ?? ReactionCastTableViewCell()
        } else {
            if self.viewModel.commentLoadState == .loading {
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.skeletonNotify, for: indexPath as IndexPath) as? SkeletonNotifyTableViewCell
                cell?.backgroundColor = UIColor.Asset.cellBackground
                cell?.configCell()
                return cell ?? SkeletonNotifyTableViewCell()
            } else {
                let comment = self.viewModel.comments[indexPath.section - 2]
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.comment, for: indexPath as IndexPath) as? CommentTableViewCell
                    cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                    cell?.delegate = self
                    if comment.isFirst {
                        cell?.topLineView.isHidden = true
                        cell?.bottomLineView.isHidden = false
                    } else if comment.isLast {
                        if (indexPath.section - 2) == 0 {
                            cell?.topLineView.isHidden = true
                        } else {
                            cell?.topLineView.isHidden = false
                        }
                        cell?.bottomLineView.isHidden = true
                    } else {
                        cell?.topLineView.isHidden = false
                        cell?.bottomLineView.isHidden = false
                    }
                    cell?.comment = comment
                    return cell ?? CommentTableViewCell()
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.reply, for: indexPath as IndexPath) as? ReplyTableViewCell
                    cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                    cell?.delegate = self
                    cell?.configCell(replyCommentId: comment.reply[indexPath.row - 1], originalCommentId: comment.id)
                    if comment.isFirst {
                        cell?.lineView.isHidden = false
                    } else if comment.isLast {
                        cell?.lineView.isHidden = true
                    } else {
                        cell?.lineView.isHidden = false
                    }
                    return cell ?? ReplyTableViewCell()
                }
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && self.viewModel.contentLoadState == .loaded && self.viewModel.content.type == .long && indexPath.row == 1 {
            self.viewModel.content.isExpand.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

    func renderFeedCell(content: Content, cellType: FeedCellType, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var originalContent = Content()
        if (content.referencedCasts.type == .recasted || content.referencedCasts.type == .quoted), let tempContent = ContentHelper.shared.getContentRef(id: content.referencedCasts.id) {
            originalContent = tempContent
        }
        switch cellType {
        case .activity:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.activityHeader, for: indexPath as IndexPath) as? ActivityHeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.cellBackground
            cell?.cellConfig(content: content)
            return cell ?? ActivityHeaderTableViewCell()
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.headerFeed, for: indexPath as IndexPath) as? HeaderTableViewCell
            cell?.backgroundColor = UIColor.Asset.cellBackground
            cell?.delegate = self
            if content.referencedCasts.type == .recasted {
                cell?.configCell(type: .content, content: originalContent, isDefaultContent: false)
            } else {
                cell?.configCell(type: .content, content: content, isDefaultContent: false)
            }
            return cell ?? HeaderTableViewCell()
        case .footer:
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.footerFeed, for: indexPath as IndexPath) as? FooterTableViewCell
            cell?.backgroundColor = UIColor.Asset.cellBackground
            cell?.delegate = self
            if content.referencedCasts.type == .recasted {
                cell?.configCell(content: originalContent, isCommentView: true)
            } else {
                cell?.configCell(content: content, isCommentView: true)
            }
            return cell ?? FooterTableViewCell()
        case .quote:
            return FeedCellHelper().renderQuoteCastCell(content: originalContent, tableView: self.tableView, indexPath: indexPath, isRenderForFeed: true)
        default:
            if content.referencedCasts.type == .recasted {
                if originalContent.type == .long && !content.isOriginalExpand {
                    return FeedCellHelper().renderLongCastCell(content: originalContent, tableView: self.tableView, indexPath: indexPath)
                } else {
                    return FeedCellHelper().renderFeedCell(content: originalContent, tableView: self.tableView, indexPath: indexPath)
                }
            } else {
                if content.type == .long && !content.isExpand {
                    return FeedCellHelper().renderLongCastCell(content: content, tableView: self.tableView, indexPath: indexPath)
                } else {
                    return FeedCellHelper().renderFeedCell(content: content, tableView: self.tableView, indexPath: indexPath)
                }
            }
        }
    }
}

extension CommentViewController: HeaderTableViewCellDelegate {
    func didRemoveSuccess(_ headerTableViewCell: HeaderTableViewCell) {
        Utility.currentViewController().dismiss(animated: true)
    }

    func didReportSuccess(_ headerTableViewCell: HeaderTableViewCell) {
        Utility.currentViewController().dismiss(animated: true)
    }
}

extension CommentViewController: FooterTableViewCellDelegate {
    func didTabQuoteCast(_ footerTableViewCell: FooterTableViewCell, content: Content, page: Page) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let viewController = PostOpener.open(.post(PostViewModel(postType: .quoteCast, content: content, page: page)))
            viewController.modalPresentationStyle = .fullScreen
            Utility.currentViewController().present(viewController, animated: true, completion: nil)
        }
    }
}

extension CommentViewController: CommentTableViewCellDelegate {
    func didReply(_ commentTableViewCell: CommentTableViewCell, comment: Comment, castcleId: String) {
        self.event = .reply
        self.viewModel.commentId = comment.id
        if !castcleId.isEmpty {
            self.commentTextField.text = "\(castcleId.toCastcleId) "
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
        self.viewModel.deleteComment(commentId: comment.id)
    }

    func didLiked(_ commentTableViewCell: CommentTableViewCell, comment: Comment) {
        self.viewModel.commentId = comment.id
        self.viewModel.likeComment()
    }

    func didUnliked(_ commentTableViewCell: CommentTableViewCell, comment: Comment) {
        self.viewModel.commentId = comment.id
        self.viewModel.unlikeComment()
    }
}

extension CommentViewController: ReplyTableViewCellDelegate {
    func didEdit(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef) {
        self.commentTextField.text = "\(replyComment.message)"
        self.commentTextField.becomeFirstResponder()
    }

    func didDelete(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef, originalCommentId: String) {
        self.hud.textLabel.text = "Deleting"
        self.hud.show(in: self.view)
        self.viewModel.deleteReplyComment(commentId: originalCommentId, replyId: replyComment.id)
    }

    func didLiked(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef) {
        self.viewModel.commentId = replyComment.id
        self.viewModel.likeComment()
    }

    func didUnliked(_ replyTableViewCell: ReplyTableViewCell, replyComment: CommentRef) {
        self.viewModel.commentId = replyComment.id
        self.viewModel.unlikeComment()
    }
}

class CustomView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
}
