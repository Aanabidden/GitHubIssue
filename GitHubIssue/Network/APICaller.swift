//
//  APICaller.swift
//  GitHubIssue
//
//  Created by Aradhana on 19/01/21.
//

import Foundation

struct APICaller {
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    func fetchIssueList(success: @escaping (Issue) -> Void,
                        failure: @escaping (Error) -> Void) {
        let strURL = "https://api.github.com/repos/firebase/firebase-ios-sdk/issues"
        apiCaller(strURL, success: {
            (data) -> Void in
            // parse Data
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let issues = try decoder.decode(Issue.self, from: data)
                    success(issues)
                } catch {
                    failure(error)
                }
            }
        }, failure: {
            (error) -> Void in
            failure(error)
        })
    }
    
    func fetchCommentList(_ issueNum: Int,
                          success: @escaping (Comment) -> Void,
                          failure: @escaping (Error) -> Void) {
        let strURL = "https://api.github.com/repos/firebase/firebase-ios-sdk/issues/\(issueNum)/comments"
        apiCaller(strURL, success: {
            (data) -> Void in
            // parse Data
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let comments = try decoder.decode(Comment.self, from: data)
                    success(comments)
                } catch {
                    failure(error)
                }
            }
        }, failure: {
            (error) -> Void in
            failure(error)
        })
    }
    
    func apiCaller(_ strURL: String,
                   success: @escaping (Data?) -> Void,
                   failure: @escaping (Error) -> Void) {
        guard let url = URL(string: strURL) else {
            return
        }
        defaultSession.dataTask(with: URLRequest(url: url)) {
            data, response, error in
            if let error = error {
                failure(error)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    success(data)
                }
            }
        }.resume()
    }
}
