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
//  FeedCellHelper.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 23/9/2564 BE.
//

import UIKit
import Networking

public class FeedCellHelper {
    public init() {
        // Init FeedCellHelper
    }
    
    public func renderFeedCell(feed: Feed, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if feed.feedPayload.feedDisplayType == .postText {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.postText, for: indexPath as IndexPath) as? TextTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.feed = feed
            return cell ?? TextTableViewCell()
        } else if feed.feedPayload.feedDisplayType == .postLink || feed.feedPayload.feedDisplayType == .postYoutube {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.postTextLink, for: indexPath as IndexPath) as? TextLinkTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.feed = feed
            return cell ?? TextLinkTableViewCell()
        } else if feed.feedPayload.feedDisplayType == .postImageX1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.imageX1, for: indexPath as IndexPath) as? ImageX1TableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.feed = feed
            return cell ?? ImageX1TableViewCell()
        } else if feed.feedPayload.feedDisplayType == .postImageX2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.imageX2, for: indexPath as IndexPath) as? ImageX2TableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.feed = feed
            return cell ?? ImageX2TableViewCell()
        } else if feed.feedPayload.feedDisplayType == .postImageX3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.imageX3, for: indexPath as IndexPath) as? ImageX3TableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.feed = feed
            return cell ?? ImageX3TableViewCell()
        } else if feed.feedPayload.feedDisplayType == .postImageXMore {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.imageXMore, for: indexPath as IndexPath) as? ImageXMoreTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.feed = feed
            return cell ?? ImageXMoreTableViewCell()
        } else if feed.feedPayload.feedDisplayType == .blogImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.blog, for: indexPath as IndexPath) as? BlogTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.feed = feed
            return cell ?? BlogTableViewCell()
        } else if feed.feedPayload.feedDisplayType == .blogNoImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.blogNoImage, for: indexPath as IndexPath) as? BlogNoImageTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.feed = feed
            return cell ?? BlogNoImageTableViewCell()
        } else {
            return UITableViewCell()
        }
    }
}
