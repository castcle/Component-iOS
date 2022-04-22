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
import RealmSwift

public final class CommentViewModel {
    
    private var commentRepository: CommentRepository = CommentRepositoryImpl()
    var content: Content?
    var comments: [Comment] = []
    var commentRequest: CommentRequest = CommentRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var state: State = .none
    var commentId: String = ""
    var replyId: String = ""
    var meta: Meta = Meta()
    
    public init(content: Content? = nil) {
        if let content = content {
            self.content = content
            self.comments = []
            self.getComments()
        }
    }
    
    public func getComments() {
        self.state = .getComments
        self.commentRepository.getComments(contentId: self.content?.id ?? "", commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
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
        self.commentRepository.createComment(castcleId: UserManager.shared.rawCastcleId, commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let comment = Comment(json: JSON(json[JsonKey.payload.rawValue].dictionaryValue))
                    let includes = JSON(json[JsonKey.includes.rawValue].dictionaryValue)
                    let users = includes[JsonKey.users.rawValue].arrayValue
                    do {
                        let realm = try Realm()
                        users.forEach { user in
                            try? realm.write {
                                let authorRef = AuthorRef().initCustom(json: user)
                                realm.add(authorRef, update: .modified)
                            }
                        }
                        self.comments.insert(comment, at: 0)
                        self.modifyCommentData()
                        self.didLoadCommentsFinish?()
                    } catch {
                        return
                    }
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
                    let replyId = commentJson["id"].stringValue
                    let includes = JSON(json[JsonKey.includes.rawValue].dictionaryValue)
                    let users = includes[JsonKey.users.rawValue].arrayValue
                    let realm = try! Realm()
                    try! realm.write {
                        let commentRef = CommentRef().initCustom(json: commentJson)
                        realm.add(commentRef, update: .modified)
                    }
                    users.forEach { user in
                        try! realm.write {
                            let authorRef = AuthorRef().initCustom(json: user)
                            realm.add(authorRef, update: .modified)
                        }
                    }
                    if let index = self.comments.firstIndex(where: { $0.id == self.commentId }) {
                        self.comments[index].reply.append(replyId)
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
    
    public func unlikeComment() {
        self.state = .unlikeComment
        self.commentRepository.unlikedComment(castcleId: UserManager.shared.rawCastcleId, commentId: self.commentId) { (success, response, isRefreshToken)  in
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
        self.commentRepository.deleteComment(castcleId: UserManager.shared.rawCastcleId, commentId: self.commentId) { (success, response, isRefreshToken)  in
            if success {
                if let index = self.comments.firstIndex(where: { $0.id == self.commentId }) {
                    self.comments.remove(at: index)
                    self.modifyCommentData()
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
        self.commentRepository.deleteReplyComment(castcleId: UserManager.shared.rawCastcleId, commentId: self.commentId, replyId: self.replyId) { (success, response, isRefreshToken)  in
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
    
    var didLoadCommentsFinish: (() -> ())?
    
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
        }
    }
}
