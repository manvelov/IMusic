//
//  UIViewController+Storybord.swift
//  IMusic
//
//  Created by Kirill Manvelov on 02.08.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func loadFromStorybord<T:UIViewController> () -> T{
        let name = String(describing: T.self)
        let storyboard = UIStoryboard.init(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("Error: no initial view controller in \(name) storybord")
        }
    }
}
