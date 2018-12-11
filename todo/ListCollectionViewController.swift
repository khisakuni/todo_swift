//
//  ListCollectionViewController.swift
//  todo
//
//  Created by Kohei Hisakuni on 12/9/18.
//  Copyright © 2018 Kohei Hisakuni. All rights reserved.
//

import UIKit

private let reuseIdentifier = "collectionHeader"

class ListCollectionViewController: UICollectionViewController {
    let searchController = UISearchController(searchResultsController: nil)
    var list: List = List()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        list.add(value: "foo", category: "meow")
        list.add(value: "foo", category: "meow")
        list.add(value: "foo", category: "meow")
        list.add(value: "foo", category: "meow")
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    // MARK: Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
        if indexPath.section == 0 {
            reusableView.addSubview(searchController.searchBar)
        }
        return reusableView
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first,
            let todoViewController = segue.destination as? TodoViewController {
            // Editing
            todoViewController.listItem = list.itemAt(index: selectedIndexPath.row)
            todoViewController.delegate = self
        } else if let navController = segue.destination as? UINavigationController,
            let viewController = navController.topViewController as? TodoViewController {
            // Adding
            viewController.delegate = self
        }
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 0 : list.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ListCollectionViewCell
        let item = list.itemAt(index: indexPath.row)
        cell.itemLabel.text = item.value
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func addListItem(_ listItem: ListItem) {
        if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
            list.update(at: selectedIndexPath.row, with: listItem)
        } else {
            list.add(item: listItem)
        }
        list.sort(items: &list.items)
        collectionView?.reloadSections(NSIndexSet(index: 1) as IndexSet)
    }
}

extension ListCollectionViewController: TodoViewControllerDelegate {
    func saveTodo(_ listItem: ListItem) {
        addListItem(listItem)
    }
}

extension ListCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {return}
        list.filterBy = searchText
        collectionView?.reloadSections(NSIndexSet(index: 1) as IndexSet)
    }
}
