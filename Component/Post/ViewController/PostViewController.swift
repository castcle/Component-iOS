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
//  PostViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 15/8/2564 BE.
//

import UIKit
import Core
import Networking
import SwiftColor
import TLPhotoPicker
import Defaults

class PostViewController: UIViewController {

    @IBOutlet var titleView: UIView!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var blogSwitch: UISwitch!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var toolbarView: UIView!

    var viewModel = PostViewModel()

    private lazy var castKeyboardInput: CastKeyboardInput = {
        let inputView = CastKeyboardInput(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 45))
        inputView.castButton.setTitle("Cast", for: .normal)
        inputView.castButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
        inputView.castButton.setTitleColor(UIColor.Asset.gray, for: .normal)
        inputView.castButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .body)
        inputView.castButton.capsule(color: UIColor.clear, borderWidth: 1.0, borderColor: UIColor.Asset.black)
        inputView.imageButton.setImage(UIImage.init(icon: .castcle(.image), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        inputView.castButton.addTarget(self, action: #selector(self.castAction), for: .touchUpInside)
        inputView.imageButton.addTarget(self, action: #selector(self.selectPhotoAction), for: .touchUpInside)
        return inputView
    }()

    private lazy var toolbarKeyboardInput: CastKeyboardInput = {
        let inputView = CastKeyboardInput(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 45))
        inputView.castButton.setTitle("Cast", for: .normal)
        inputView.castButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
        inputView.castButton.setTitleColor(UIColor.Asset.gray, for: .normal)
        inputView.castButton.titleLabel?.font = UIFont.asset(.bold, fontSize: .body)
        inputView.castButton.capsule(color: UIColor.clear, borderWidth: 1.0, borderColor: UIColor.Asset.black)
        inputView.imageButton.setImage(UIImage.init(icon: .castcle(.image), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        inputView.castButton.addTarget(self, action: #selector(self.castAction), for: .touchUpInside)
        inputView.imageButton.addTarget(self, action: #selector(self.selectPhotoAction), for: .touchUpInside)
        return inputView
    }()

    enum PostViewControllerSection: Int, CaseIterable {
        case header = 0
        case newPost
        case image
        case quote
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.viewModel.postType.rawValue
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.titleView.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.backButton.setImage(UIImage.init(icon: .castcle(.back), size: CGSize(width: 23, height: 23), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.titleLabel.font = UIFont.asset(.regular, fontSize: .head4)
        self.titleLabel.textColor = UIColor.Asset.white
        self.blogSwitch.tintColor = UIColor.Asset.cellBackground
        self.blogSwitch.onTintColor = UIColor.Asset.gray
        self.blogSwitch.thumbTintColor = UIColor.Asset.white
        self.blogSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        if self.viewModel.postType == .newCast {
            self.castKeyboardInput.imageButton.isHidden = false
            self.toolbarKeyboardInput.imageButton.isHidden = false
        } else {
            self.castKeyboardInput.imageButton.isHidden = true
            self.toolbarKeyboardInput.imageButton.isHidden = true
        }
        self.configureTableView()
        self.toolbarView.addSubview(self.toolbarKeyboardInput)
        self.updateCastToolBarButton()
        self.viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        Defaults[.screenId] = ScreenId.newCast.rawValue
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        EngagementHelper().sendCastcleAnalytic(event: .onScreenView, screen: .newCast)
    }

    @objc func keyboardWillAppear() {
        self.toolbarView.isHidden = true
    }

    @objc func keyboardWillDisappear() {
        self.toolbarView.isHidden = false
    }

    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: PostNibVars.TableViewCell.header, bundle: ConfigBundle.component), forCellReuseIdentifier: PostNibVars.TableViewCell.header)
        self.tableView.register(UINib(nibName: PostNibVars.TableViewCell.newPost, bundle: ConfigBundle.component), forCellReuseIdentifier: PostNibVars.TableViewCell.newPost)
        self.tableView.register(UINib(nibName: PostNibVars.TableViewCell.imagePost, bundle: ConfigBundle.component), forCellReuseIdentifier: PostNibVars.TableViewCell.imagePost)
        self.tableView.registerFeedCell()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }

    @objc func switchValueDidChange(_ sender: UISwitch) {
        if sender.isOn {
            self.blogSwitch.thumbTintColor = UIColor.Asset.lightBlue
        } else {
            self.blogSwitch.thumbTintColor = UIColor.Asset.white
        }
    }

    @objc func castAction() {
        if self.viewModel.isCanPost() {
            self.view.endEditing(true)
            CCLoading.shared.show(text: "Casting")
            if self.viewModel.postType == .newCast {
                self.viewModel.createContent()
            } else {
                self.viewModel.quotecastContent()
            }
        }
    }

    @objc func selectPhotoAction() {
        let photosPickerViewController = TLPhotosPickerViewController()
        photosPickerViewController.delegate = self
        photosPickerViewController.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        photosPickerViewController.collectionView.backgroundColor = UIColor.clear
        photosPickerViewController.navigationBar.barTintColor = UIColor.Asset.darkGraphiteBlue
        photosPickerViewController.navigationBar.isTranslucent = false
        photosPickerViewController.titleLabel.font = UIFont.asset(.regular, fontSize: .overline)
        photosPickerViewController.subTitleLabel.font = UIFont.asset(.regular, fontSize: .small)
        photosPickerViewController.doneButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.bold, fontSize: .head4),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)
        photosPickerViewController.cancelButton.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.asset(.regular, fontSize: .body),
            NSAttributedString.Key.foregroundColor: UIColor.Asset.lightBlue
        ], for: .normal)

        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 4
        configure.mediaType = .image
        configure.usedCameraButton = false
        configure.allowedLivePhotos = false
        configure.allowedPhotograph = false
        configure.allowedVideo = false
        configure.autoPlay = false
        configure.allowedVideoRecording = false
        configure.selectedColor = UIColor.Asset.lightBlue
        photosPickerViewController.configure = configure
        photosPickerViewController.selectedAssets = self.viewModel.imageInsert

        Utility.currentViewController().present(photosPickerViewController, animated: true, completion: nil)
    }

    private func updateCastToolBarButton() {
        if !self.viewModel.postText.isEmpty {
            let characterCount = self.viewModel.postText.utf16.count
            if characterCount <= self.viewModel.limitCharacter {
                self.enableCaseButtom()
            } else {
                self.disableCaseButtom()
            }
        } else {
            if self.viewModel.imageInsert.count > 0 {
                self.enableCaseButtom()
            } else {
                self.disableCaseButtom()
            }
        }
    }

    private func disableCaseButtom() {
        self.castKeyboardInput.castButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
        self.castKeyboardInput.castButton.setTitleColor(UIColor.Asset.gray, for: .normal)
        self.castKeyboardInput.castButton.capsule(color: UIColor.clear, borderWidth: 1.0, borderColor: UIColor.Asset.black)
        self.toolbarKeyboardInput.castButton.setBackgroundImage(UIColor.Asset.darkGraphiteBlue.toImage(), for: .normal)
        self.toolbarKeyboardInput.castButton.setTitleColor(UIColor.Asset.gray, for: .normal)
        self.toolbarKeyboardInput.castButton.capsule(color: UIColor.clear, borderWidth: 1.0, borderColor: UIColor.Asset.black)
    }

    private func enableCaseButtom() {
        self.castKeyboardInput.castButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.castKeyboardInput.castButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.castKeyboardInput.castButton.capsule(color: UIColor.clear, borderWidth: 1.0, borderColor: UIColor.Asset.lightBlue)
        self.toolbarKeyboardInput.castButton.setBackgroundImage(UIColor.Asset.lightBlue.toImage(), for: .normal)
        self.toolbarKeyboardInput.castButton.setTitleColor(UIColor.Asset.white, for: .normal)
        self.toolbarKeyboardInput.castButton.capsule(color: UIColor.clear, borderWidth: 1.0, borderColor: UIColor.Asset.lightBlue)
    }

    private func updateImageToolBarButton() {
        if self.viewModel.imageInsert.isEmpty {
            self.disableImageButtom()
        } else {
            self.enableImageButtom()
        }
    }

    private func disableImageButtom() {
        self.castKeyboardInput.imageButton.setImage(UIImage.init(icon: .castcle(.image), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
        self.toolbarKeyboardInput.imageButton.setImage(UIImage.init(icon: .castcle(.image), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.white).withRenderingMode(.alwaysOriginal), for: .normal)
    }

    private func enableImageButtom() {
        self.castKeyboardInput.imageButton.setImage(UIImage.init(icon: .castcle(.image), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue).withRenderingMode(.alwaysOriginal), for: .normal)
        self.toolbarKeyboardInput.imageButton.setImage(UIImage.init(icon: .castcle(.image), size: CGSize(width: 25, height: 25), textColor: UIColor.Asset.lightBlue).withRenderingMode(.alwaysOriginal), for: .normal)
    }

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PostViewControllerSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case PostViewControllerSection.image.rawValue:
            return (self.viewModel.postType == .newCast ? 1 : 0)
        case PostViewControllerSection.quote.rawValue:
            return (self.viewModel.postType == .quoteCast ? 1 : 0)
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case PostViewControllerSection.header.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostNibVars.TableViewCell.header, for: indexPath as IndexPath) as? HeaderPostTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.configCell(page: self.viewModel.page)
            return cell ?? HeaderPostTableViewCell()
        case PostViewControllerSection.newPost.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostNibVars.TableViewCell.newPost, for: indexPath as IndexPath) as? PostTextTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            cell?.postView.inputAccessoryView = self.castKeyboardInput
            return cell ?? PostTextTableViewCell()
        case PostViewControllerSection.image.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostNibVars.TableViewCell.imagePost, for: indexPath as IndexPath) as? ImagePostTableViewCell
            cell?.backgroundColor = UIColor.clear
            cell?.delegate = self
            cell?.configCell(image: self.viewModel.imageInsert)
            return cell ?? ImagePostTableViewCell()
        case PostViewControllerSection.quote.rawValue:
            guard let content = self.viewModel.content else { return UITableViewCell() }
            return FeedCellHelper().renderQuoteCastCell(content: content, tableView: self.tableView, indexPath: indexPath, isRenderForFeed: false)
        default:
            return UITableViewCell()
        }
    }
}

extension PostViewController: PostTextTableViewCellDelegate {
    func updateHeightOfRow(_ cell: PostTextTableViewCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = self.tableView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            self.tableView?.beginUpdates()
            self.tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let indexPath = self.tableView.indexPath(for: cell) {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
        self.viewModel.postText = textView.text
        self.updateCastToolBarButton()
    }
}

extension PostViewController: ImagePostTableViewCellDelegate {
    func imagePostTableViewCell(_ cell: ImagePostTableViewCell, didRemoveAt index: Int) {
        if self.viewModel.imageInsert.count > index {
            self.viewModel.imageInsert.remove(at: index)
            let index = IndexPath(row: 0, section: 2)
            self.tableView.reloadRows(at: [index], with: .automatic)
            self.updateImageToolBarButton()
            self.updateCastToolBarButton()
        }
    }
}

extension PostViewController: TLPhotosPickerViewControllerDelegate {
    func shouldDismissPhotoPicker(withTLPHAssets: [TLPHAsset]) -> Bool {
        self.viewModel.imageInsert = withTLPHAssets
        self.updateImageToolBarButton()
        self.updateCastToolBarButton()
        let index = IndexPath(row: 0, section: 2)
        self.tableView.reloadRows(at: [index], with: .automatic)
        return true
    }
}

extension PostViewController: PostViewModelDelegate {
    func didCreateContentFinish(success: Bool) {
        CCLoading.shared.dismiss()
        if success {
            NotificationCenter.default.post(name: .getMyContent, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }

    func didQuotecastContentFinish(success: Bool) {
        CCLoading.shared.dismiss()
        if success {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
