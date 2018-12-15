//
//  ViewController.swift
//  todo
//
//  Created by Kohei Hisakuni on 11/11/18.
//  Copyright © 2018 Kohei Hisakuni. All rights reserved.
//

import UIKit

protocol TodoViewControllerDelegate {
    func saveTodo(_ listItem: ListItem)
}

private let isbnKey = ""

class TodoViewController: UIViewController {
    
    var list = List()
    var delegate: TodoViewControllerDelegate?
    var listItem: ListItem?

    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func validateName(_ sender: Any) {
        validate()
    }
    
    @IBAction func validateCategory(_ sender: Any) {
        validate()
    }
    
    @IBAction func touchCancel(_ sender: Any) {
        dissmissMe()
    }
    
    @IBAction func touchSave(_ sender: Any) {
        let listItem = ListItem(value: nameInput.text!, category: categoryInput.text!)
        delegate?.saveTodo(listItem)
        dissmissMe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        if let listItem = listItem {
            nameInput.text = listItem.value
            categoryInput.text = listItem.category
        }
    }
    
    func dissmissMe() {
        if presentingViewController != nil {
            // Was presented via a modal segue.
            dismiss(animated: true, completion: nil)
        } else {
            // Was pushed onto navigation stack.
            navigationController!.popViewController(animated: true)
        }
    }
    
    func validate() {
        if nameInput.text!.count > 0 && categoryInput.text!.count > 0 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

