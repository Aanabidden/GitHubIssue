//
//  IssueModel.swift
//  GitHubIssue
//
//  Created by Aradhana on 19/01/21.
//

import Foundation

// MARK: - IssueDisplay
struct IssueDisplay {
    let title: String
    let body: String?
    init(element: IssueElement) {
        self.title = element.title
        self.body  = element.body
        // 140 char limnit in body
//        let minlimit = min(string.count, 140)
//        let index = string.index(string.startIndex, offsetBy: minlimit)
//        self.body = String(string.prefix(upTo: index))
    }
}

// MARK: - IssueElement
typealias Issue = [IssueElement]

struct IssueElement: Codable {
    let url, repositoryURL: String
    let labelsURL: String
    let commentsURL, eventsURL, htmlURL: String
    let id: Int
    let nodeID: String
    let number: Int
    let title: String
    let user: User
    let state: State
    let locked: Bool
    let assignee: User?
    let assignees: [User]
    let milestone: JSONNull?
    let comments: Int
    let createdAt, updatedAt: String
    let closedAt: JSONNull?
    let body: String

    enum CodingKeys: String, CodingKey {
        case url
        case repositoryURL = "repository_url"
        case labelsURL = "labels_url"
        case commentsURL = "comments_url"
        case eventsURL = "events_url"
        case htmlURL = "html_url"
        case id
        case nodeID = "node_id"
        case number, title, user, state, locked, assignee, assignees, milestone, comments
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case body
    }
}

enum State: String, Codable {
    case stateOpen = "open"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public func hash(into hasher: inout Hasher) {}
    
    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

