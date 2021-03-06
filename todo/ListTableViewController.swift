//
//  ListTableViewController.swift
//  todo
//
//  Created by Kohei Hisakuni on 11/11/18.
//  Copyright © 2018 Kohei Hisakuni. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController, Injectable {
    let searchController = UISearchController(searchResultsController: nil)
    var list:List!
    
    @IBAction func changedSegment(_ sender: UISegmentedControl) {
        guard let sortBy = List.order(rawValue: sender.selectedSegmentIndex) else {return}
        list.sortBy = sortBy
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(animated)
        tableView?.reloadData()
    }

    func inject(data: List) {
        self.list = data
    }
    
    func addListItem(_ listItem: ListItem) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Update
            list.update(at: selectedIndexPath.row, with: listItem)
        } else {
            // Add new
            list.add(item: listItem)
        }
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow,
            let todoViewController = segue.destination as? TodoViewController {
            todoViewController.listItem = list.itemAt(index: selectedIndexPath.row)
            todoViewController.delegate = self
        }
        if let navController = segue.destination as? UINavigationController {
            if let todoViewController = navController.topViewController as? TodoViewController {
                todoViewController.delegate = self
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath)
        let item = list.itemAt(index: indexPath.row)
        cell.textLabel?.text = item.value
        cell.detailTextLabel?.text = item.category
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListTableViewController: TodoViewControllerDelegate {
    func saveTodo(_ listItem: ListItem) {
        addListItem(listItem)
        tableView.reloadData()
    }
}

extension ListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        list.filterBy = searchText
        tableView.reloadData()
    }
}
