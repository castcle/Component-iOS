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
//  Created by Tanakorn Phoochaliaw on 2/9/2564 BE.
//

import UIKit
import Core
import Networking

class CommentViewController: UITableViewController {
    
    var viewModel = CommentViewModel()
    
    var customInputView: UIView!
    var sendButton: UIButton!
    var avatarImage: UIImageView!
    let commentTextField = FlexibleTextView()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        
        if customInputView == nil {
            customInputView = CustomView()
            customInputView.backgroundColor = UIColor.Asset.darkGray
            self.commentTextField.placeholder = "What's in your mind?"
            self.commentTextField.font = UIFont.asset(.regular, fontSize: .overline)
            self.commentTextField.textColor = UIColor.Asset.white
            self.commentTextField.autocorrectionType = .no
            self.commentTextField.custom(color: UIColor.Asset.darkGraphiteBlue, cornerRadius: 10, borderWidth: 1, borderColor: UIColor.Asset.black)
            
            customInputView.autoresizingMask = .flexibleHeight
            customInputView.addSubview(self.commentTextField)
            
            
            self.sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            self.sendButton.setImage(UIImage.init(icon: .castcle(.direct), size: CGSize(width: 20, height: 20), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
            self.sendButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
            self.sendButton.capsule()
            self.sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            self.sendButton.clipsToBounds = true
            self.sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
            customInputView?.addSubview(self.sendButton)
            
            self.avatarImage = UIImageView()
            self.avatarImage.contentMode = .scaleAspectFill
            self.avatarImage.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

            let url = URL(string: UserState.shared.avatar)
            self.avatarImage.kf.setImage(with: url)
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
        return customInputView
    }
    
    @objc func handleSend() {
        print("works")
        self.commentTextField.text = ""
        self.commentTextField.resignFirstResponder()
    }
    
    enum FeedSection: Int, CaseIterable {
        case header = 0
        case content
        case footer
    }
    
    enum CommentSection: Int, CaseIterable {
        case comment = 0
        case replay
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNevBar()
        self.configureTableView()
        self.tableView.keyboardDismissMode = .interactive
        self.viewModel.didLoadCommentsFinish = {
            UIView.transition(with: self.tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() })
        }
    }
    
    private func setupNevBar() {
        self.customNavigationBar(.primary, title: "Post of \(self.viewModel.feed?.feedPayload.author.displayName ?? "")", textColor: UIColor.Asset.white)
        
        let leftIcon = NavBarButtonType.back.barButton
        leftIcon.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftIcon)
    }
    
    func configureTableView() {
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.headerFeed, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.headerFeed)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.footerFeed, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.footerFeed)
        
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.comment, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.comment)
        self.tableView.register(UINib(nibName: ComponentNibVars.TableViewCell.reply, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.reply)
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
    
    @objc private func leftButtonAction() {
        Utility.currentViewController().dismiss(animated: true)
    }
}

extension CommentViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (1 + self.viewModel.comments.count)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.viewModel.feed != nil {
                return FeedSection.allCases.count
            } else {
                return 0
            }
        } else {
            return 1 + self.viewModel.comments[section - 1].reply.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case FeedSection.header.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.headerFeed, for: indexPath as IndexPath) as? HeaderTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.delegate = self
                cell?.feed = self.viewModel.feed
                return cell ?? HeaderTableViewCell()
            case FeedSection.footer.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.footerFeed, for: indexPath as IndexPath) as? FooterTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGray
                cell?.delegate = self
                cell?.feed = self.viewModel.feed
                return cell ?? FooterTableViewCell()
            default:
                return UITableViewCell()
            }
        } else {
            let comment = self.viewModel.comments[indexPath.section - 1]
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.comment, for: indexPath as IndexPath) as? CommentTableViewCell
                cell?.backgroundColor = UIColor.Asset.darkGraphiteBlue
                cell?.delegate = self
                if comment.isFirst {
                    cell?.topLineView.isHidden = true
                    cell?.bottomLineView.isHidden = false
                } else if comment.isLast {
                    cell?.topLineView.isHidden = false
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
                if comment.isFirst {
                    cell?.lineView.isHidden = false
                } else {
                    cell?.lineView.isHidden = true
                }
                cell?.replyComment = comment.reply[indexPath.row - 1]
                return cell ?? ReplyTableViewCell()
            }
        }
    }
}

extension CommentViewController: HeaderTableViewCellDelegate {
    func didTabProfile(_ headerTableViewCell: HeaderTableViewCell) {
        //
    }
    
    func didAuthen(_ headerTableViewCell: HeaderTableViewCell) {
//        Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
    }
}

extension CommentViewController: FooterTableViewCellDelegate {
    func didTabComment(_ footerTableViewCell: FooterTableViewCell, feed: Feed) {
        //
    }
    
    func didTabQuoteCast(_ footerTableViewCell: FooterTableViewCell, feed: Feed, page: Page) {
        //
    }
    
    func didAuthen(_ footerTableViewCell: FooterTableViewCell) {
//        Utility.currentViewController().presentPanModal(AuthenOpener.open(.signUpMethod) as! SignUpMethodViewController)
    }
}

extension CommentViewController: CommentTableViewCellDelegate {
    func didReplay(_ commentTableViewCell: CommentTableViewCell, comment: Comment) {
        self.commentTextField.text = "\(comment.author.castcleId) "
        self.commentTextField.becomeFirstResponder()
    }
}

class CustomView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize.zero
    }
}
