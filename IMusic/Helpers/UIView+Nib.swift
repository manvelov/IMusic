//
//  UIView+Nib.swift
//  IMusic
//
//  Created by Kirill Manvelov on 17.08.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView > () -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as! T
    }
}
 
