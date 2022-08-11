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
//  CommentViewModel.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 2/9/2564 BE.
//

import Core
import Networking
import Moya
import SwiftyJSON

public final class CommentViewModel {

    private var commentRepository: CommentRepository = CommentRepositoryImpl()
    private var contentRepository: ContentRepository = ContentRepositoryImpl()
    var content: Content = Content()
    private var contentId: String = ""
    var comments: [Comment] = []
    var commentRequest: CommentRequest = CommentRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var state: State = .none
    var loadState: LoadState = .loading
    var commentId: String = ""
    var replyId: String = ""
    var meta: Meta = Meta()

    public init(contentId: String = "") {
        if !contentId.isEmpty {
            self.tokenHelper.delegate = self
            self.contentId = contentId
            self.comments = []
            self.getContentDetail()
        }
    }

    private func getContentDetail() {
        self.state = .getContentDetail
        self.contentRepository.getContentDetail(contentId: self.contentId) { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let payload = JSON(json[JsonKey.payload.rawValue].dictionaryValue)
                    let includes = JSON(json[JsonKey.includes.rawValue].dictionaryValue)
                    let users = includes[JsonKey.users.rawValue].arrayValue
                    self.content = Content(json: payload)
                    ContentHelper.shared.updateContentRef(casts: includes[JsonKey.casts.rawValue].arrayValue)
                    UserHelper.shared.updateAuthorRef(users: users)
                    self.didLoadContentFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func getComments() {
        self.state = .getComments
        self.commentRepository.getComments(contentId: self.contentId, commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let commentPayload = CommentPayload(json: json)
                    self.comments.append(contentsOf: commentPayload.payload)
                    self.meta = commentPayload.meta
                    self.modifyCommentData()
                    self.didLoadCommentsFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func createComment() {
        self.state = .createComment
        self.commentRepository.createComment(castcleId: UserManager.shared.castcleId, commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let comment = Comment(json: JSON(json[JsonKey.payload.rawValue].dictionaryValue))
                    let includes = JSON(json[JsonKey.includes.rawValue].dictionaryValue)
                    let users = includes[JsonKey.users.rawValue].arrayValue
                    UserHelper.shared.updateAuthorRef(users: users)
                    self.comments.insert(comment, at: 0)
                    self.modifyCommentData()
                    self.content.metrics.commentCount += 1
                    self.content.participate.commented = true
                    self.didLoadCommentsFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func replyComment() {
        self.state = .replyComment
        self.commentRepository.replyComment(castcleId: UserManager.shared.castcleId, commentId: self.commentId, commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let commentJson = JSON(json[JsonKey.payload.rawValue].dictionaryValue)
                    let replyIdData = commentJson[JsonKey.id.rawValue].stringValue
                    let includes = JSON(json[JsonKey.includes.rawValue].dictionaryValue)
                    let users = includes[JsonKey.users.rawValue].arrayValue
                    CommentHelper.shared.updateCommentRef(commentJson: commentJson)
                    UserHelper.shared.updateAuthorRef(users: users)
                    if let index = self.comments.firstIndex(where: { $0.id == self.commentId }) {
                        self.comments[index].reply.append(replyIdData)
                        self.modifyCommentData()
                        self.didLoadCommentsFinish?()
                    }
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func likeComment() {
        self.state = .likeComment
        self.commentRequest.commentId = self.commentId
        self.commentRepository.likedComment(castcleId: UserManager.shared.castcleId, commentRequest: self.commentRequest) { (success, _, isRefreshToken)  in
            if success {
                print("Like success")
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func unlikeComment() {
        self.state = .unlikeComment
        self.commentRepository.unlikedComment(castcleId: UserManager.shared.castcleId, commentId: self.commentId) { (success, _, isRefreshToken)  in
            if success {
                print("Unlike success")
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func deleteComment(commentId: String) {
        self.state = .deleteComment
        self.commentId = commentId
        self.commentRepository.deleteComment(castcleId: UserManager.shared.castcleId, commentId: self.commentId) { (success, _, isRefreshToken)  in
            if success {
                if let index = self.comments.firstIndex(where: { $0.id == self.commentId }) {
                    self.comments.remove(at: index)
                    self.modifyCommentData()
                    self.content.metrics.commentCount -= 1
                    self.didLoadCommentsFinish?()
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func deleteReplyComment(commentId: String, replyId: String) {
        self.state = .deleteReplyComment
        self.commentId = commentId
        self.replyId = replyId
        self.commentRepository.deleteReplyComment(castcleId: UserManager.shared.castcleId, commentId: self.commentId, replyId: self.replyId) { (success, _, isRefreshToken)  in
            if success {
                if let index = self.comments.firstIndex(where: { $0.id == self.commentId }) {
                    let comment = self.comments[index]
                    if let replyIndex = comment.reply.firstIndex(where: { $0 == self.replyId }) {
                        self.comments[index].reply.remove(at: replyIndex)
                        self.modifyCommentData()
                        self.didLoadCommentsFinish?()
                    }
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    var didLoadCommentsFinish: (() -> Void)?
    var didLoadContentFinish: (() -> Void)?

    private func modifyCommentData() {
        for index in (0..<self.comments.count) {
            if index == 0 {
                if self.comments.count == 1 {
                    self.comments[index].isFirst = false
                    self.comments[index].isLast = true
                } else {
                    self.comments[index].isFirst = true
                    self.comments[index].isLast = false
                }
            } else if index == (self.comments.count - 1) {
                self.comments[index].isFirst = false
                self.comments[index].isLast = true
            } else {
                self.comments[index].isFirst = false
                self.comments[index].isLast = false
            }
        }
    }
}

extension CommentViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getComments {
            self.getComments()
        } else if self.state == .createComment {
            self.createComment()
        } else if self.state == .replyComment {
            self.replyComment()
        } else if self.state == .likeComment {
            self.likeComment()
        } else if self.state == .unlikeComment {
            self.unlikeComment()
        } else if self.state == .deleteComment {
            self.deleteComment(commentId: self.commentId)
        } else if self.state == .deleteReplyComment {
            self.deleteReplyComment(commentId: self.commentId, replyId: self.replyId)
        } else if self.state == .getContentDetail {
            self.getContentDetail()
        }
    }
}
