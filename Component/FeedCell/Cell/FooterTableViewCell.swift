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
//  FooterTableViewCell.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 7/9/2564 BE.
//

import UIKit
import Core
import Networking
import PanModal

public protocol FooterTableViewCellDelegate {
    func didTabComment(_ footerTableViewCell: FooterTableViewCell, content: Content)
    func didTabQuoteCast(_ footerTableViewCell: FooterTableViewCell, content: Content, page: Page)
    func didAuthen(_ footerTableViewCell: FooterTableViewCell)
}

public class FooterTableViewCell: UITableViewCell {

    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var recastLabel: UILabel!
    @IBOutlet var farmLabel: UILabel!
    
    public var content: Content? {
        didSet {
            guard let content = self.content else { return }
            self.updateUi(content: content)
        }
    }
    
    public var delegate: FooterTableViewCellDelegate?
    
    //MARK: Private
    private var contentRepository: ContentRepository = ContentRepositoryImpl()
    let tokenHelper: TokenHelper = TokenHelper()
    var contentRequest: ContentRequest = ContentRequest()
    var stateType: StateType = .none
    enum StateType {
        case like
        case recast
        case none
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.tokenHelper.delegate = self
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateUi(content: Content) {
        self.likeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.commentLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.recastLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.farmLabel.font = UIFont.asset(.regular, fontSize: .overline)
        
        let displayLike: String = (content.metrics.likeCount > 0 ? "  \(String.displayCount(count: content.metrics.likeCount))" : "")
        let displayComment: String = (content.metrics.commentCount > 0 ? "  \(String.displayCount(count: content.metrics.commentCount))" : "")
        let displayRecast: String = ((content.metrics.recastCount > 0 || content.metrics.quoteCount > 0) ? "  \(String.displayCount(count: content.metrics.recastCount + content.metrics.quoteCount))" : "")
        let displayFarming: String = (content.metrics.farmCount > 0 ? "  \(String.displayCount(count: content.metrics.farmCount))" : "")
        
        if content.participate.liked {
            self.likeLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.like), iconColor: UIColor.Asset.lightBlue, postfixText: displayLike, postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 18)
        } else {
            self.likeLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.like), iconColor: UIColor.Asset.white, postfixText: displayLike, postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 18)
        }
        
        if content.participate.commented {
            self.commentLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.comment), iconColor: UIColor.Asset.lightBlue, postfixText: displayComment, postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 15)
        } else {
            self.commentLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.comment), iconColor: UIColor.Asset.white, postfixText: displayComment, postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 15)
        }
        
        if content.participate.recasted || content.participate.quoted {
            self.recastLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.recast), iconColor: UIColor.Asset.lightBlue, postfixText: displayRecast, postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 18)
        } else {
            self.recastLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.recast), iconColor: UIColor.Asset.white, postfixText: displayRecast, postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 18)
        }
        
        if content.participate.farming {
            self.farmLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.farm), iconColor: UIColor.Asset.lightBlue, postfixText: displayFarming, postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 15)
        } else {
            self.farmLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.farm), iconColor: UIColor.Asset.white, postfixText: displayFarming, postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 15)
        }
    }
    
    private func likeContent(content: Content) {
        if content.participate.liked {
            content.metrics.likeCount -= 1
            content.participate.liked.toggle()
            self.updateUi(content: content)
            self.contentRepository.unlikeContent(contentId: content.id) { (success, response, isRefreshToken) in
                if !success {
                    if isRefreshToken {
                        self.tokenHelper.refreshToken()
                    } else {
                        content.metrics.likeCount += 1
                        content.participate.liked.toggle()
                        self.updateUi(content: content)
                    }
                }
            }
        } else {
            content.metrics.likeCount += 1
            content.participate.liked.toggle()
            self.updateUi(content: content)
            self.contentRepository.likeContent(contentId: content.id) { (success, response, isRefreshToken) in
                if !success {
                    if isRefreshToken {
                        self.tokenHelper.refreshToken()
                    } else {
                        content.metrics.likeCount -= 1
                        content.participate.liked.toggle()
                        self.updateUi(content: content)
                    }
                }
            }
        }

        if content.participate.liked {
            let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
            impliesAnimation.duration = 0.3 * 2
            impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
            self.likeLabel.layer.add(impliesAnimation, forKey: nil)
        }
    }
    
    private func recastContent(content: Content, castcleId: String) {
        if content.participate.recasted {
            content.metrics.recastCount -= 1
            content.participate.recasted.toggle()
            self.updateUi(content: content)
            self.contentRequest.castcleId = castcleId
            self.contentRequest.contentId = content.id
            self.contentRepository.unrecastContent(contentRequest: self.contentRequest) { (success, response, isRefreshToken) in
                if !success {
                    if isRefreshToken {
                        self.tokenHelper.refreshToken()
                    } else {
                        content.metrics.recastCount += 1
                        content.participate.recasted.toggle()
                        self.updateUi(content: content)
                    }
                }
            }
        } else {
            content.metrics.recastCount += 1
            content.participate.recasted.toggle()
            self.updateUi(content: content)
            self.contentRequest.castcleId = castcleId
            self.contentRequest.contentId = content.id
            self.contentRepository.recastContent(contentRequest: self.contentRequest) { (success, response, isRefreshToken) in
                if !success {
                    if isRefreshToken {
                        self.tokenHelper.refreshToken()
                    } else {
                        content.metrics.recastCount -= 1
                        content.participate.recasted.toggle()
                        self.updateUi(content: content)
                    }
                }
            }
        }
    }
    
    private func farmingContent(content: Content) {
        if content.participate.farming {
            content.metrics.farmCount -= 1
            content.participate.farming.toggle()
            self.updateUi(content: content)
        } else {
            content.metrics.farmCount += 1
            content.participate.farming.toggle()
            self.updateUi(content: content)
        }
    }
    
    @IBAction func likeAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            guard let content = self.content else { return }
            self.stateType = .like
            self.likeContent(content: content)
        } else {
            self.delegate?.didAuthen(self)
        }
    }
    
    @IBAction func commentAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            guard let content = self.content else { return }
            self.stateType = .none
            self.delegate?.didTabComment(self, content: content)
        } else {
            self.delegate?.didAuthen(self)
        }
    }
    
    @IBAction func recastAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            guard let content = self.content else { return }
            let vc = ComponentOpener.open(.recast(RecastPopupViewModel(isRecasted: content.participate.recasted))) as? RecastPopupViewController
            vc?.delegate = self
            Utility.currentViewController().presentPanModal(vc ?? RecastPopupViewController())
        } else {
            self.delegate?.didAuthen(self)
        }
    }
    
    @IBAction func farmingAction(_ sender: Any) {
        if UserManager.shared.isLogin {
            guard let content = self.content else { return }
            if content.participate.farming {
                let vc = ComponentOpener.open(.farmingPopup(FarmingPopupViewModel(type: .unfarn))) as? FarmingPopupViewController
                vc?.delegate = self
                Utility.currentViewController().presentPanModal(vc ?? FarmingPopupViewController())
            } else {
                if self.randomBool() {
                    let vc = ComponentOpener.open(.farmingPopup(FarmingPopupViewModel(type: .farm))) as? FarmingPopupViewController
                    vc?.delegate = self
                    Utility.currentViewController().presentPanModal(vc ?? FarmingPopupViewController())
                } else {
                    let vc = ComponentOpener.open(.farmingLimitPopup) as? FarmingLimitViewController
                    vc?.delegate = self
                    Utility.currentViewController().presentPanModal(vc ?? FarmingLimitViewController())
                }
            }
        } else {
            self.delegate?.didAuthen(self)
        }
    }
    
    // MARK: - Remove when production
    private func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
}

extension FooterTableViewCell: RecastPopupViewControllerDelegate {
    public func recastPopupViewController(_ view: RecastPopupViewController, didSelectRecastAction recastAction: RecastAction, page: Page?, castcleId: String) {
        guard let content = self.content else { return }
        if recastAction == .recast {
            self.recastContent(content: content, castcleId: castcleId)
        } else if recastAction == .quoteCast {
            guard let page = page else { return }
            self.delegate?.didTabQuoteCast(self, content: content, page: page)
        }
    }
}

extension FooterTableViewCell: FarmingPopupViewControllerDelegate {
    public func farmingPopupViewController(didAction view: FarmingPopupViewController) {
        guard let content = self.content else { return }
        self.farmingContent(content: content)
    }
}

extension FooterTableViewCell: FarmingLimitViewControllerDelegate {
    public func farmingLimitViewController(didAction view: FarmingLimitViewController) {
        guard let content = self.content else { return }
        self.farmingContent(content: content)
    }
}

extension FooterTableViewCell: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        guard let content = self.content else { return }
        if self.stateType == .like {
            self.likeContent(content: content)
        } else if self.stateType == .recast {
            self.recastContent(content: content, castcleId: self.contentRequest.castcleId)
        }
    }
}
