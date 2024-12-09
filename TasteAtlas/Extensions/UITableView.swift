//
//  UITableView.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/9.
//

import UIKit

extension UITableView {
    /// Register a cell in the table view
    /// - parameter cell: The cell to register
    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UITableViewHeaderFooterView>(view: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }
    
    /// Dequeue a cell in the table view
    /// - parameter type: The type cell to dequeue
    /// - returns: The dequeued cell
    func dequeueCell<T: UITableViewCell>(for type: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseIdentifier) as? T else { fatalError("Unable to dequeue cell💥💥💥💥💥") }
        return cell
    }
}
