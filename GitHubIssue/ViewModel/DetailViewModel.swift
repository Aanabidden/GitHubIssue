//
//  DetailViewModel.swift
//  GitHubIssue
//
//  Created by Aradhana on 20/01/21.
//

import Foundation
import UIKit

class DetailViewModel {
    var dataFetcher: APICaller!
    var issue: IssueElement
    var numberOfRows = 0
    var title = ""
    var body = ""
    
    // Input
    var bindToSourceViewModels :(() -> ()) = {  }
    
    private var tableDataSource = [NSMutableAttributedString]()
    private var dataModel: Comment! {
        didSet {
            configureTableDataSource()
            configureOutput()
        }
    }
    
    init(issued: IssueElement) {
        self.issue = issued
        self.title = issued.title
        self.body = issued.body
    }
    
    func loadData(dataFetcher: APICaller) {
        self.dataFetcher = dataFetcher
        getCommentList()
    }
    
    private func getCommentList() {
        dataFetcher.fetchCommentList(issue.number, success: {
            (comments) -> Void in
            self.dataModel = comments
        }) {
            (error) -> Void in
            // error handling
            print(error)
        }
    }
    
    private func configureTableDataSource() {
        tableDataSource.removeAll()
        for comment in dataModel {
            // save in DB
            let stringToColor = comment.user.login
            let mainString = stringToColor + ": " + comment.body
            let range = (mainString as NSString).range(of: stringToColor)

            let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.brown, range: range)
            tableDataSource.append(mutableAttributedString)
        }
    }
    
    private func configureOutput() {
        DispatchQueue.main.async {
            self.numberOfRows = self.tableDataSource.count
            self.bindToSourceViewModels()
        }
    }
    
    func tableCellDataModelForIndexPath(_ indexPath: IndexPath) -> NSMutableAttributedString {
        return tableDataSource[indexPath.row]
    }
}
