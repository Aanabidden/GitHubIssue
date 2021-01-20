//
//  RealmIssueModel.swift
//  GitHubIssue
//
//  Created by Aradhana on 20/01/21.
//

import Foundation
import RealmSwift

class IssueDB: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var number: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var body: String?
    @objc dynamic var updateAt: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }

    override static func indexedProperties() -> [String] {
        return ["updateAt"]
    }
}
