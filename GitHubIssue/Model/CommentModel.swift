//
//  CommentModel.swift
//  GitHubComment
//
//  Created by Aradhana on 20/01/21.
//

import Foundation

// MARK: - CommentElement
typealias Comment = [CommentElement]
struct CommentElement: Codable {
    let url, issueURL, htmlURL: String
    let id: Int
    let nodeID: String
    let user: User
    let createdAt, updatedAt: String
    let body: String
    
    enum CodingKeys: String, CodingKey {
        case url
        case issueURL = "issue_url"
        case htmlURL = "html_url"
        case id
        case nodeID = "node_id"
        case user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case body
    }
}
