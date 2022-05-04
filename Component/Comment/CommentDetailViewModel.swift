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
//  CommentDetailViewModel.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 4/5/2565 BE.
//

import Core
import Networking
import Moya
import SwiftyJSON
import RealmSwift

public final class CommentDetailViewModel {
    
    private var commentRepository: CommentRepository = CommentRepositoryImpl()
    private var isComment: Bool = true
    var contentId: String = ""
    private var commentId: String = ""
    var replyCommentId: String = ""
    var comment: Comment = Comment()
    var replyList: [Comment] = []
    var commentRequest: CommentRequest = CommentRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var state: State = .none
    var commentLoadState: LoadState = .loading
    var meta: Meta = Meta()
    let realm = try! Realm()
    
    public init(contentId: String = "", commentId: String = "") {
        if !contentId.isEmpty && !commentId.isEmpty {
            self.tokenHelper.delegate = self
            self.contentId = contentId
            self.commentId = commentId
            self.getCommentDetail()
        }
    }

    public func getCommentDetail() {
        self.state = .getCommentDetail
        self.commentRepository.getCommentDetail(contentId: self.contentId, commentId: self.commentId, commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    self.comment = Comment(json: JSON(json[JsonKey.payload.rawValue].dictionaryValue))
                    self.meta = Meta(json: JSON(json[JsonKey.meta.rawValue].dictionaryValue))
                    let includes = JSON(json[JsonKey.includes.rawValue].dictionaryValue)
                    let users = includes[JsonKey.users.rawValue].arrayValue
                    let replyData = json[JsonKey.reply.rawValue].arrayValue
                    
                    replyData.forEach { reply in
                        self.replyList.append(Comment(json: reply))
                        try! self.realm.write {
                            let commentRef = CommentRef().initCustom(json: reply)
                            self.realm.add(commentRef, update: .modified)
                        }
                    }
                    users.forEach { user in
                        try! self.realm.write {
                            let authorRef = AuthorRef().initCustom(json: user)
                            self.realm.add(authorRef, update: .modified)
                        }
                    }
                    self.didLoadCommentFinish?()
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
        self.commentRepository.replyComment(castcleId: UserManager.shared.rawCastcleId, commentId: self.commentId, commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let commentJson = JSON(json[JsonKey.payload.rawValue].dictionaryValue)
                    let includes = JSON(json[JsonKey.includes.rawValue].dictionaryValue)
                    let users = includes[JsonKey.users.rawValue].arrayValue

                    try! self.realm.write {
                        self.replyList.append(Comment(json: commentJson))
                        let commentRef = CommentRef().initCustom(json: commentJson)
                        self.realm.add(commentRef, update: .modified)
                    }
                    users.forEach { user in
                        try! self.realm.write {
                            let authorRef = AuthorRef().initCustom(json: user)
                            self.realm.add(authorRef, update: .modified)
                        }
                    }
                    self.didLoadCommentFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func likeComment(isComment: Bool) {
        self.state = .likeComment
        self.isComment = isComment
        self.commentRequest.commentId = (isComment ? self.commentId : self.replyCommentId)
        self.commentRepository.likedComment(castcleId: UserManager.shared.rawCastcleId, commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                print("Like success")
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func unlikeComment(isComment: Bool) {
        self.state = .unlikeComment
        self.isComment = isComment
        self.commentRepository.unlikedComment(castcleId: UserManager.shared.rawCastcleId, commentId: (isComment ? self.commentId : self.replyCommentId)) { (success, response, isRefreshToken)  in
            if success {
                print("Unlike success")
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func deleteComment() {
        self.state = .deleteComment
        self.commentRepository.deleteComment(castcleId: UserManager.shared.rawCastcleId, commentId: self.commentId) { (success, response, isRefreshToken)  in
            if success {
                self.didDeleteCommentFinish?()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    public func deleteReplyComment(replyId: String) {
        self.state = .deleteReplyComment
        self.replyCommentId = replyId
        self.commentRepository.deleteReplyComment(castcleId: UserManager.shared.rawCastcleId, commentId: self.commentId, replyId: self.replyCommentId) { (success, response, isRefreshToken)  in
            if success {
                if let replyIndex = self.replyList.firstIndex(where: { $0.id == self.replyCommentId }) {
                    self.replyList.remove(at: replyIndex)
                    self.didLoadCommentFinish?()
                }
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }

    var didLoadCommentFinish: (() -> ())?
    var didDeleteCommentFinish: (() -> ())?
}

extension CommentDetailViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.state == .getCommentDetail {
            self.getCommentDetail()
        } else if self.state == .replyComment {
            self.replyComment()
        } else if self.state == .likeComment {
            self.likeComment(isComment: self.isComment)
        } else if self.state == .unlikeComment {
            self.unlikeComment(isComment: self.isComment)
        } else if self.state == .deleteComment {
            self.deleteComment()
        } else if self.state == .deleteReplyComment {
            self.deleteReplyComment(replyId: self.replyCommentId)
        }
    }
}
