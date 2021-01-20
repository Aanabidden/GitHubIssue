//
//  DetailViewController.swift
//  GitHubIssue
//
//  Created by Aradhana on 19/01/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 45.0
        tableView.rowHeight = UITableView.automaticDimension
        
        self.viewModel?.loadData(dataFetcher: APICaller())
        self.viewModel?.bindToSourceViewModels = { [weak self] in
            self?.refreshData()
        }
    }
    
    private func refreshData() {
        if let row = viewModel?.numberOfRows, row > 0 {
            self.tableView.reloadData()
        } else {
            let alert = UIAlertController.init(title: "No comments available for this issue", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (_) in
                if let navController = self.navigationController {
                     navController.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: {})
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Table view data source
extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return viewModel!.numberOfRows
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cellIssue: IssueListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "isssueFull", for: indexPath) as! IssueListTableViewCell
            cellIssue.title.text = viewModel?.title
            cellIssue.body.text = viewModel?.body
            return cellIssue
        }
        let cellComment = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath)
        
        let cellData = viewModel!.tableCellDataModelForIndexPath(indexPath)
        cellComment.textLabel?.numberOfLines = 0
        cellComment.textLabel?.lineBreakMode = .byWordWrapping
        cellComment.textLabel?.attributedText = cellData
        return cellComment
    }
    
    
}
