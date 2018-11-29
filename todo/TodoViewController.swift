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

class TodoViewController: UIViewController {
    
    var list = List(items: [])
    var delegate: TodoViewControllerDelegate?
    var listItem: ListItem?

    @IBOutlet weak var input: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func validate(_ sender: UITextField) {
        if input.text!.count > 0 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    @IBAction func touchCancel(_ sender: Any) {
        dissmissMe()
    }
    
    @IBAction func touchSave(_ sender: Any) {
        let listItem = ListItem(value: input.text!)
        delegate?.saveTodo(listItem)
        dissmissMe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        if let listItem = listItem {
            input.text = listItem.value
        }
    }
    
    func dissmissMe() {
        dismiss(animated: true, completion: nil)
    }
}

