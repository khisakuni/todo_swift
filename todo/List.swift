//
//  List.swift
//  todo
//
//  Created by Kohei Hisakuni on 11/11/18.
//  Copyright © 2018 Kohei Hisakuni. All rights reserved.
//

import Foundation

private let appSupportDirectory: URL = {
    let url = FileManager().urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    if !FileManager().fileExists(atPath: url.path) {
        do {
            try FileManager().createDirectory(at: url, withIntermediateDirectories: false)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    return url
}()

private let itemsFile = appSupportDirectory.appendingPathComponent("Items")

class List {
    private lazy var items: [ListItem] = self.load()
    var filtered: [ListItem] = []
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
        
    func add(item: ListItem) {
        items.append(item)
        sort(items: &items)
        save()
    }
    
    func add(value: String, category: String) {
        items.append(ListItem(value: value, category: category))
        sort(items: &items)
        save()
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
        save()
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
        save()
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
    
    // MARK: Local storage
    func save() {
        (items.map({$0.dictionary}) as NSArray).write(to:itemsFile, atomically: true)
    }
    
    private func load() -> [ListItem] {
        return loadFromDisk() ?? []
        
    }
    
    func loadFromDisk() -> [ListItem]? {
        guard let array = NSArray(contentsOf: itemsFile) as? [[String: String]] else {return nil}
        guard let items = array.map({ListItem(item:$0)}) as? [ListItem] else {return nil}
        return items
    }
}

struct ListItem {
    var value: String
    var category: String
    var dictionary: [String: String] {
        return [
            Key.value: value,
            Key.category: category
        ]
    }
    init(value: String, category: String) {
        self.value = value
        self.category = category
    }
    init?(item: [String: String]) {
        guard let category = item[Key.category],
            let value = item[Key.value]
            else {return nil}
        self.init(value: value, category: category)
    }
}

internal struct Key {
    static let value = "value"
    static let category = "category"
}

extension ListItem: Equatable {}
func ==(lhs: ListItem, rhs: ListItem) -> Bool {
    return (
        lhs.value == rhs.value && lhs.category == rhs.category
    )
}
