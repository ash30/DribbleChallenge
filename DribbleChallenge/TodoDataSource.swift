//
//  TodoDataSource.swift
//  DribbleChallenge
//
//  Created by Ashley Arthur on 09/06/2017.
//  Copyright © 2017 AshArthur. All rights reserved.
//

import Foundation

protocol DataSource {
    
    var observer: DataSourceObserver? { get set }
}

enum DataSourceChanges {
    
    case insert(Int)
    case removed(Int)
    
}

protocol OrderedDataSource: DataSource {
    
    var count: Int { get }
    
    func insert(at index:Int, item: String)
    func pop(at index:Int) -> String
    func getItem(at index:Int) -> String?

}

protocol DataSourceObserver {
    
    func didUpdate(dataSource: OrderedDataSource, change:DataSourceChanges)
    
}

class TodoDataSource: OrderedDataSource {
    
    var observer: DataSourceObserver?

    private var items: [String] = []
    
    convenience init(items:[String]) {
        self.init()
        self.items = items
    }
    
    var count: Int {
        return items.count
    }
    
    func insert(at index:Int, item: String) {
        items.insert(item, at: index)
        observer?.didUpdate(dataSource: self, change: .insert(index))
    }
    func pop(at index:Int) -> String {
        observer?.didUpdate(dataSource: self, change: .removed(index))
        return items.remove(at: index)
    }
    
    func getItem(at index:Int) -> String? {
        guard index < items.count else {
            return nil
        }
        return items[index]
    }
    
}
