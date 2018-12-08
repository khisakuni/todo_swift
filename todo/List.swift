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
    var sortBy: order = order.value {
        didSet {
            sort(items: &items)
        }
    }
    
    enum order: Int {
        case value
        case category
    }
    
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
    
    func add(value: String, category: String) {
        items.append(ListItem(value: value, category: category))
    }
    
    func itemAt(index: Int) -> ListItem {
        return self.items[index]
    }
    
    func update(at: Int, with: ListItem) {
        items[at] = with
    }
    
    func remove(at: Int) {
        items.remove(at: at)
    }
    
    func sort(items: inout [ListItem]) {
        switch sortBy {
        case .value:
            items.sort(by: {return $0.value.localizedLowercase < $1.value.localizedLowercase})
        case .category:
            items.sort(by: {return $0.category.localizedLowercase < $1.category.localizedLowercase})
        }
    }
}

struct ListItem {
    var value: String
    var category: String
}
