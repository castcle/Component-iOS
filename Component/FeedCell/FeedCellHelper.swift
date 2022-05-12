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
//  Created by Castcle Co., Ltd. on 23/9/2564 BE.
//

import UIKit
import Networking

public class FeedCellHelper {
    public init() {
        // Init FeedCellHelper
    }

    public func renderFeedCell(content: Content, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if content.feedDisplayType == .postText {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.postText, for: indexPath as IndexPath) as? TextTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? TextTableViewCell()
        } else if content.feedDisplayType == .postLinkPreview {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.postLinkPreview, for: indexPath as IndexPath) as? TextLinkPreviewTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? TextLinkPreviewTableViewCell()
        } else if content.feedDisplayType == .postLink {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.postLink, for: indexPath as IndexPath) as? TextLinkTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.configCell(content: content)
            return cell ?? TextLinkTableViewCell()
        } else if content.feedDisplayType == .postImageX1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.imageX1, for: indexPath as IndexPath) as? ImageX1TableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? ImageX1TableViewCell()
        } else if content.feedDisplayType == .postImageX2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.imageX2, for: indexPath as IndexPath) as? ImageX2TableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? ImageX2TableViewCell()
        } else if content.feedDisplayType == .postImageX3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.imageX3, for: indexPath as IndexPath) as? ImageX3TableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? ImageX3TableViewCell()
        } else if content.feedDisplayType == .postImageXMore {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.imageXMore, for: indexPath as IndexPath) as? ImageXMoreTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? ImageXMoreTableViewCell()
        } else if content.feedDisplayType == .blogImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.blog, for: indexPath as IndexPath) as? BlogTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? BlogTableViewCell()
        } else if content.feedDisplayType == .blogNoImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.blogNoImage, for: indexPath as IndexPath) as? BlogNoImageTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? BlogNoImageTableViewCell()
        } else {
            return UITableViewCell()
        }
    }

    public func renderQuoteCastCell(content: Content, tableView: UITableView, indexPath: IndexPath, isRenderForFeed: Bool) -> UITableViewCell {
        if content.feedDisplayType == .postText {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.quoteText, for: indexPath as IndexPath) as? QuoteCastTextCell
            if isRenderForFeed {
                cell?.backgroundColor = UIColor.Asset.darkGray
            } else {
                cell?.backgroundColor = UIColor.clear
            }
            cell?.content = content
            return cell ?? QuoteCastTextCell()
        } else if content.feedDisplayType == .postLink {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.quoteLink, for: indexPath as IndexPath) as? QuoteCastTextLinkCell
            if isRenderForFeed {
                cell?.backgroundColor = UIColor.Asset.darkGray
            } else {
                cell?.backgroundColor = UIColor.clear
            }
            cell?.configCell(content: content)
            return cell ?? QuoteCastTextLinkCell()
        } else if content.feedDisplayType == .postLinkPreview {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.quoteLinkPreview, for: indexPath as IndexPath) as? QuoteCastTextLinkPreviewCell
            if isRenderForFeed {
                cell?.backgroundColor = UIColor.Asset.darkGray
            } else {
                cell?.backgroundColor = UIColor.clear
            }
            cell?.content = content
            return cell ?? QuoteCastTextLinkPreviewCell()
        } else if content.feedDisplayType == .postImageX1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.quoteImageX1, for: indexPath as IndexPath) as? QuoteCastImageX1Cell
            if isRenderForFeed {
                cell?.backgroundColor = UIColor.Asset.darkGray
            } else {
                cell?.backgroundColor = UIColor.clear
            }
            cell?.content = content
            return cell ?? QuoteCastImageX1Cell()
        } else if content.feedDisplayType == .postImageX2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.quoteImageX2, for: indexPath as IndexPath) as? QuoteCastImageX2Cell
            if isRenderForFeed {
                cell?.backgroundColor = UIColor.Asset.darkGray
            } else {
                cell?.backgroundColor = UIColor.clear
            }
            cell?.content = content
            return cell ?? QuoteCastImageX2Cell()
        } else if content.feedDisplayType == .postImageX3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.quoteImageX3, for: indexPath as IndexPath) as? QuoteCastImageX3Cell
            if isRenderForFeed {
                cell?.backgroundColor = UIColor.Asset.darkGray
            } else {
                cell?.backgroundColor = UIColor.clear
            }
            cell?.content = content
            return cell ?? QuoteCastImageX3Cell()
        } else if content.feedDisplayType == .postImageXMore {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.quoteImageXMore, for: indexPath as IndexPath) as? QuoteCastImageXMoreCell
            if isRenderForFeed {
                cell?.backgroundColor = UIColor.Asset.darkGray
            } else {
                cell?.backgroundColor = UIColor.clear
            }
            cell?.content = content
            return cell ?? QuoteCastImageXMoreCell()
        } else if content.feedDisplayType == .blogImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.quoteBlog, for: indexPath as IndexPath) as? QuoteCastBlogCell
            if isRenderForFeed {
                cell?.backgroundColor = UIColor.Asset.darkGray
            } else {
                cell?.backgroundColor = UIColor.clear
            }
            cell?.content = content
            return cell ?? QuoteCastBlogCell()
        } else if content.feedDisplayType == .blogNoImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.quoteBlogNoImage, for: indexPath as IndexPath) as? QuoteCastBlogNoImageCell
            if isRenderForFeed {
                cell?.backgroundColor = UIColor.Asset.darkGray
            } else {
                cell?.backgroundColor = UIColor.clear
            }
            cell?.content = content
            return cell ?? QuoteCastBlogNoImageCell()
        } else {
            return UITableViewCell()
        }
    }

    public func renderLongCastCell(content: Content, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if content.feedDisplayType == .postText {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.longText, for: indexPath as IndexPath) as? LongTextTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? LongTextTableViewCell()
        } else if content.feedDisplayType == .postLink {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.longTextLink, for: indexPath as IndexPath) as? LongTextLinkTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.configCell(content: content)
            return cell ?? LongTextLinkTableViewCell()
        } else if content.feedDisplayType == .postLinkPreview {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.longTextLinkPreview, for: indexPath as IndexPath) as? LongTextLinkPreviewTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? LongTextLinkPreviewTableViewCell()
        } else if content.feedDisplayType == .postImageX1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.longImageX1, for: indexPath as IndexPath) as? LongImageX1TableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? LongImageX1TableViewCell()
        } else if content.feedDisplayType == .postImageX2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.longImageX2, for: indexPath as IndexPath) as? LongImageX2TableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? LongImageX2TableViewCell()
        } else if content.feedDisplayType == .postImageX3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.longImageX3, for: indexPath as IndexPath) as? LongImageX3TableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? LongImageX3TableViewCell()
        } else if content.feedDisplayType == .postImageXMore {
            let cell = tableView.dequeueReusableCell(withIdentifier: ComponentNibVars.TableViewCell.longImageXMore, for: indexPath as IndexPath) as? LongImageXMoreTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            cell?.content = content
            return cell ?? LongImageXMoreTableViewCell()
        } else {
            return UITableViewCell()
        }
    }
}
