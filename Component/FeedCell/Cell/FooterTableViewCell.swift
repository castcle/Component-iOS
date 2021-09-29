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
//  Created by Tanakorn Phoochaliaw on 7/9/2564 BE.
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
    
    public var content: Content? {
        didSet {
            self.updateUi()
        }
    }
    
    public var delegate: FooterTableViewCellDelegate?
    
    //MARK: Private
    private var likeRepository: LikeRepository = LikeRepositoryImpl()
    private var recastRepository: RecastRepository = RecastRepositoryImpl()
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func updateUi() {
        guard let content = self.content else { return }
        self.likeLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.commentLabel.font = UIFont.asset(.regular, fontSize: .overline)
        self.recastLabel.font = UIFont.asset(.regular, fontSize: .overline)
        
        let displayLike: String = (content.liked.count > 0 ? "  \(String.displayCount(count: content.liked.count))" : "")
        let displayComment: String = (content.commented.count > 0 ? "  \(String.displayCount(count: content.commented.count))" : "")
        let displayRecast: String = (content.recasted.count > 0 ? "  \(String.displayCount(count: content.recasted.count))" : "")
        
        if content.liked.isLike {
            
            self.likeLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.like), iconColor: UIColor.Asset.lightBlue, postfixText: displayLike, postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 18)
        } else {
            self.likeLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.like), iconColor: UIColor.Asset.white, postfixText: displayLike, postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 18)
        }
        
        if content.commented.isComment {
            self.commentLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.comment), iconColor: UIColor.Asset.lightBlue, postfixText: displayComment, postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 15)
        } else {
            self.commentLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.comment), iconColor: UIColor.Asset.white, postfixText: displayComment, postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 15)
        }
        
        if content.recasted.isRecast {
            self.recastLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.recast), iconColor: UIColor.Asset.lightBlue, postfixText: displayRecast, postfixTextColor: UIColor.Asset.lightBlue, size: nil, iconSize: 18)
        } else {
            self.recastLabel.setIcon(prefixText: "", prefixTextColor: .clear, icon: .castcle(.recast), iconColor: UIColor.Asset.white, postfixText: displayRecast, postfixTextColor: UIColor.Asset.white, size: nil, iconSize: 18)
        }
    }
    
    @IBAction func likeAction(_ sender: Any) {
        
        if UserState.shared.isLogin {
            guard let content = self.content else { return }

            if content.liked.isLike {
                content.liked.count -= 1
                self.likeRepository.unliked(feedUuid: content.id) { success in
                    print("Unliked : \(success)")
                }
            } else {
                content.liked.count += 1
                self.likeRepository.liked(feedUuid: content.id) { success in
                    print("Liked : \(success)")
                }
            }

            content.liked.isLike.toggle()
            self.updateUi()

            if content.liked.isLike {
                let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
                impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
                impliesAnimation.duration = 0.3 * 2
                impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
                self.likeLabel.layer.add(impliesAnimation, forKey: nil)
            }
        } else {
            self.delegate?.didAuthen(self)
        }
    }
    
    @IBAction func commentAction(_ sender: Any) {
        if UserState.shared.isLogin {
            guard let content = self.content else { return }
            self.delegate?.didTabComment(self, content: content)
        } else {
            self.delegate?.didAuthen(self)
        }
    }
    
    @IBAction func recastAction(_ sender: Any) {
        if UserState.shared.isLogin {
            guard let content = self.content else { return }
            let vc = ComponentOpener.open(.recast(RecastPopupViewModel(isRecasted: content.recasted.isRecast))) as? RecastPopupViewController
            vc?.delegate = self
            Utility.currentViewController().presentPanModal(vc ?? RecastPopupViewController())
        } else {
            self.delegate?.didAuthen(self)
        }
    }
    
}

extension FooterTableViewCell: RecastPopupViewControllerDelegate {
    public func recastPopupViewController(_ view: RecastPopupViewController, didSelectRecastAction recastAction: RecastAction, page: Page?) {
        guard let content = self.content else { return }

        if recastAction == .recast {
            if content.recasted.isRecast {
                self.recastRepository.unrecasted(feedUuid: content.id) { success in
                    print("Unrecasted : \(success)")
                }
            } else {
                self.recastRepository.recasted(feedUuid: content.id) { success in
                    print("Recasted : \(success)")
                }
            }

            content.recasted.isRecast.toggle()
            self.updateUi()
        } else if recastAction == .quoteCast {
            guard let page = page else { return }
            self.delegate?.didTabQuoteCast(self, content: content, page: page)
        }
    }
}
