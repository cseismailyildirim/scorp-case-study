//
//  UITableView.swift
//  ScorpCaseStudy
//
//  Created by ismailyildirim on 19.08.2021.
//

import Foundation
import UIKit


extension UITableView{
   
    public func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = String(describing:  cellType)
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>(with cellType: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: cellType) , for: indexPath) as! T
    }
    
}
