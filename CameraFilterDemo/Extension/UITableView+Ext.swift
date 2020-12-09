//
//  UITableView+Ext.swift
//  CameraFilterDemo
//
//  Created by Steven on 2020/12/9.
//

import Foundation
import UIKit

// MARK: -
extension UITableViewCell {
    
    static var reuseCellID: String {
        return String(describing: self)
    }
}

// MARK: -
extension UITableView {

    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseCellID, for: indexPath) as? T else {
            fatalError("Unable to dequeue reusable cell - \(T.reuseCellID)")
        }

        return cell
    }
}
