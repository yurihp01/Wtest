//
//  Storyboarded.swift
//  Wtest
//
//  Created by Yuri on 02/07/2022.
//

import UIKit

// MARK: - Enums
enum Storyboard: String {
    case main = "Main"
}

// MARK: - Protocols
protocol Storyboarded {
    static func instantiate(storyboardName name: Storyboard) -> Self
}

// MARK: - Extensions
extension Storyboarded where Self: UIViewController {
    static func instantiate(storyboardName name: Storyboard) -> Self {
        let fullName = NSStringFromClass(self)
        
        // we need to get the value at position 1 because it's the view controller name.
        let className = fullName.components(separatedBy: ".")[1]
        
        let storyboard = UIStoryboard(name: name.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
