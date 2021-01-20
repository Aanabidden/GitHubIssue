//
//  IssueListTableViewController.swift
//  GitHubIssue
//
//  Created by Aradhana on 19/01/21.
//

import UIKit

class IssueListTableViewController: UITableViewController {
    
    let viewModel = IssueListViewModel(dataFetcher: APICaller())

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 45.0
        tableView.rowHeight = UITableView.automaticDimension
        
        viewModel.loadData()
        self.viewModel.bindToSourceViewModels = { [weak self] in
            self?.refreshData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellView: IssueListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "issues", for: indexPath) as! IssueListTableViewCell
        let cellData = viewModel.tableCellDataModelForIndexPath(indexPath)
        cellView.title.text = cellData.title
        cellView.body.text = cellData.body
        return cellView
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detail" {
            if let destination = segue.destination as? DetailViewController {
                let indexPath = self.tableView.indexPathForSelectedRow!
                destination.viewModel = self.viewModel.getDetailViewModel(indexPath)
            }
        }
    }
    
    private func refreshData() {
        if viewModel.numberOfRows > 0 {
            self.tableView.reloadData()
        }
    }
}
