//
//  IssueListViewModel.swift
//  GitHubIssue
//
//  Created by Aradhana on 19/01/21.
//

import Foundation

class IssueListViewModel {
    var dataFetcher: APICaller!
    
    var numberOfRows = 0
    // Input
    var loadData: () -> () = { }
    var bindToSourceViewModels :(() -> ()) = {  }
    
    private var tableDataSource = [IssueDisplay]()
    private var dataModel: Issue! {
        didSet {
            configureTableDataSource()
            configureOutput()
        }
    }
    
    init(dataFetcher: APICaller) {
        self.dataFetcher = dataFetcher
        loadData = { [weak self] in
            self?.getIssueList()
        }
    }
    
    private func getIssueList() {
        // fetch from DB, if available
        dataFetcher.fetchIssueList(success: {
            (issues) -> Void in
            // sort by updateDate
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"
            self.dataModel = issues
                .map { return ($0, dateFormatter.date(from: $0.updatedAt)!) }
                .sorted { $0.1 > $1.1 }
                .map(\.0)
            
            // and save in DB
        }) {
            (error) -> Void in
            // error handling
            print(error)
        }
    }
    
    private func configureTableDataSource() {
        tableDataSource.removeAll()
        for issue in dataModel {
            let issueList = IssueDisplay.init(element: issue)
            tableDataSource.append(issueList)
        }
    }
    
    private func configureOutput() {
        DispatchQueue.main.async {
            self.numberOfRows = self.tableDataSource.count
            self.bindToSourceViewModels()
        }
    }
    
    func tableCellDataModelForIndexPath(_ indexPath: IndexPath) -> IssueDisplay {
        return tableDataSource[indexPath.row]
    }
    
    func getDetailViewModel(_ indexPath: IndexPath) -> DetailViewModel {
        let viewModel = DetailViewModel(issued:dataModel[indexPath.row])
        return viewModel
    }
}
