//
//  StoryboardCreateble.swift
//  DogPatch
//
//  Created by Mdo on 27/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

protocol StoryboardCreateble:class {
    static var storyboard:UIStoryboard { get}
    static var storyboardBundle: Bundle? { get}
    static var storyboardIdentifier:String{ get}
    static var storyboardName:String{ get}
    
    static func instanceFromStoryboard()->Self
}
