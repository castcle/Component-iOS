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
//  FooterFeedCell.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 15/7/2564 BE.
//

import UIKit
import Core
import Networking
import PanModal

protocol FooterFeedCellDelegate {
    func didTabComment()
    func didTabQuoteCast(feed: Feed, page: Page)
    func didAuthen()
}

class FooterFeedCell: UICollectionViewCell {

    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var recastLabel: UILabel!
    
    var feed: Feed? {
        didSet {
            self.updateUi()
        }
    }
    
    var delegate: FooterFeedCellDelegate?
    
    //MARK: Private
    private var likeRepository: LikeRepository = LikeRepositoryImpl()
    private var recastRepository: RecastRepository = RecastRepositoryImpl()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public static func cellSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 55)
    }
    
    private func updateUi() {
        guard let feed = self.feed else { return }
        self.likeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.commentLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.recastLabel.font = UIFont.asset(.regular, fontSize: .overline)
        
        if feed.feedPayload.liked.isLike {
            self.likeLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.like), iconColor: UIColor.Asset.lightBlue, postfixText: "  \(String.displayCount(count: feed.feedPayload.liked.count))", postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 18)
        } else {
            self.likeLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.like), iconColor: UIColor.Asset.white, postfixText: "  \(String.displayCount(count: feed.feedPayload.liked.count))", postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 18)
        }
        
        if feed.feedPayload.commented.isComment {
            self.commentLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.comment), iconColor: UIColor.Asset.lightBlue, postfixText: "  \(String.displayCount(count: feed.feedPayload.commented.count))", postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 15)
        } else {
            self.commentLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.comment), iconColor: UIColor.Asset.white, postfixText: "  \(String.displayCount(count: feed.feedPayload.commented.count))", postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 15)
        }
        
        if feed.feedPayload.recasted.isRecast {
            self.recastLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.recast), iconColor: UIColor.Asset.lightBlue, postfixText: "  \(String.displayCount(count: feed.feedPayload.recasted.count))", postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 18)
        } else {
            self.recastLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.recast), iconColor: UIColor.Asset.white, postfixText: "  \(String.displayCount(count: feed.feedPayload.recasted.count))", postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 18)
        }
    }
    
    @IBAction func likeAction(_ sender: Any) {
        
        if UserState.shared.isLogin {
            guard let feed = self.feed else { return }

            if feed.feedPayload.liked.isLike {
                self.likeRepository.unliked(feedUuid: feed.feedPayload.id) { success in
                    print("Unliked : \(success)")
                }
            } else {
                self.likeRepository.liked(feedUuid: feed.feedPayload.id) { success in
                    print("Liked : \(success)")
                }
            }

            feed.feedPayload.liked.isLike.toggle()
            self.updateUi()

            if feed.feedPayload.liked.isLike {
                let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
                impliesAnimation.duration = 0.3 * 2
                impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
                self.likeLabel.layer.add(impliesAnimation, forKey: nil)
            }
        } else {
            self.delegate?.didAuthen()
        }
    }
    
    @IBAction func commentAction(_ sender: Any) {
        if UserState.shared.isLogin {
            self.delegate?.didTabComment()
        } else {
            self.delegate?.didAuthen()
        }
    }
    
    @IBAction func recastAction(_ sender: Any) {
        if UserState.shared.isLogin {
            guard let feed = self.feed else { return }
            let vc = ComponentOpener.open(.recast(RecastPopupViewModel(isRecasted: feed.feedPayload.recasted.isRecast))) as? RecastPopupViewController
            vc?.delegate = self
            Utility.currentViewController().presentPanModal(vc ?? RecastPopupViewController())
        } else {
            self.delegate?.didAuthen()
        }
    }
}

extension FooterFeedCell: RecastPopupViewControllerDelegate {
    func recastPopupViewController(_ view: RecastPopupViewController, didSelectRecastAction recastAction: RecastAction, page: Page?) {
        guard let feed = self.feed else { return }

        if recastAction == .recast {
            if feed.feedPayload.recasted.isRecast {
                self.recastRepository.unrecasted(feedUuid: feed.feedPayload.id) { success in
                    print("Unrecasted : \(success)")
                }
            } else {
                self.recastRepository.recasted(feedUuid: feed.feedPayload.id) { success in
                    print("Recasted : \(success)")
                }
            }

            feed.feedPayload.recasted.isRecast.toggle()
            self.updateUi()
        } else if recastAction == .quoteCast {
            guard let page = page else { return }
            self.delegate?.didTabQuoteCast(feed: feed, page: page)
        }
    }
}
