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
    var filtered: [ListItem]
    var sortBy: order = order.value {
        didSet {
            sort(items: &items)
        }
    }
    var filterBy = "" {
        didSet {
            filter()
        }
    }
    
    enum order: Int {
        case value
        case category
    }
    
    var count: Int {
        return filterBy.isEmpty ? items.count : filtered.count
    }
    
    init() {
        self.items = []
        self.filtered = []
    }
    
    init(items: [ListItem]) {
        self.items = items
        self.filtered = []
    }
    
    func add(item: ListItem) {
        items.append(item)
    }
    
    func add(value: String, category: String) {
        items.append(ListItem(value: value, category: category))
    }
    
    func itemAt(index: Int) -> ListItem {
        return filterBy.isEmpty ? items[index] : filtered[index]
    }
    
    func update(at: Int, with: ListItem) {
        if filterBy.isEmpty {
            items[at] = with
            sort(items: &items)
        } else {
            let toUpdate = filtered[at]
            guard let index = items.index(of: toUpdate) else {
                print("Error: item not found")
                return
            }
            items[index] = with
            sort(items: &items)
            filter()
        }
        
    }
    
    func remove(at: Int) {
        if filterBy.isEmpty {
            items.remove(at: at)
        } else {
            let removed = filtered.remove(at: at)
            guard let index = items.index(of: removed) else {
                // TODO: Better error handling
                print("Error: item not found")
                return
            }
            items.remove(at: index)
        }
    }
    
    func sort(items: inout [ListItem]) {
        switch sortBy {
        case .value:
            items.sort(by: {return $0.value.localizedLowercase < $1.value.localizedLowercase})
        case .category:
            items.sort(by: {return $0.category.localizedLowercase < $1.category.localizedLowercase})
        }
    }
    
    func filter() {
        filtered = items.filter {item in
            return item.value.localizedLowercase.contains(filterBy.localizedLowercase) || item.category.localizedLowercase.contains(filterBy.localizedLowercase)
            
        }
    }
}

struct ListItem {
    var value: String
    var category: String
}

extension ListItem: Equatable {}
func ==(lhs: ListItem, rhs: ListItem) -> Bool {
    return (
        lhs.value == rhs.value && lhs.category == rhs.category
    )
}
