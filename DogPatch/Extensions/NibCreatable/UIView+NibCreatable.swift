//
//  UIView+NibCreatable.swift
//  DogPatch
//
//  Created by Mdo on 27/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

extension UIView:NibCreatable{
    @objc final class var nib: UINib {
        let nibName = Self.nibName
        let nibBundle = Self.nibBundle
        return UINib(nibName: nibName, bundle: nibBundle)
    }
    
    @objc class var nibBundle: Bundle? {
        return Bundle(for: self)
    }
    
    @objc class  var nibName: String {
        return "\(self)"
    }
    
    @objc class  func instanceFromNib() -> Self {
        return nib.instantiate(withOwner: nil, options: nil).last as! Self
    }
    
    
    
}
