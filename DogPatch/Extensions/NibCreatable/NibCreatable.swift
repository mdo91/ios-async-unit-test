//
//  NibCreatable.swift
//  DogPatch
//
//  Created by Mdo on 27/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

protocol NibCreatable:class {
    
    static var nib:UINib {get}
    static var nibBundle:Bundle? {get}
    static var nibName:String { get}
    static func instanceFromNib() -> Self
}
