//
//  DetailViewController.swift
//  GitHubIssue
//
//  Created by Aradhana on 19/01/21.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var titleFull: UILabel!
    @IBOutlet weak var bodyFull: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 45.0
        tableView.rowHeight = UITableView.automaticDimension
        
        self.titleFull.text = viewModel?.title
        self.bodyFull.text = viewModel?.body
        
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
                self.dismiss(animated: true, completion: {})
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Table view data source
extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel!.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellView = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath)
        let cellData = viewModel!.tableCellDataModelForIndexPath(indexPath)
        cellView.textLabel?.numberOfLines = 0
        cellView.textLabel?.lineBreakMode = .byWordWrapping
        cellView.textLabel?.attributedText = cellData
        return cellView
    }
    
    
}
