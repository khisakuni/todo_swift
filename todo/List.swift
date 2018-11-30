//
//  List.swift
//  todo
//
//  Created by Kohei Hisakuni on 11/11/18.
//  Copyright © 2018 Kohei Hisakuni. All rights reserved.
//

import Foundation

class List {
    var items: [ListItem]
    
    var count: Int {
        return self.items.count
    }
    
    init() {
        self.items = []
    }
    
    init(items: [ListItem]) {
        self.items = items
    }
    
    func add(item: ListItem) {
        items.append(item)
    }
    
    func add(item: String) {
        items.append(ListItem(value: item))
    }
    
    func itemAt(index: Int) -> ListItem {
        return self.items[index]
    }
    
    func update(at: Int, with: ListItem) {
        items[at] = with
    }
}

struct ListItem {
    var value: String
}
