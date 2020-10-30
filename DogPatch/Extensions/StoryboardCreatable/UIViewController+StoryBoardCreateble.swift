//
//  UIViewController+StoryBoardCreateble.swift
//  DogPatch
//
//  Created by Mdo on 27/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

extension UIViewController:StoryboardCreateble{
    @objc class var storyboard: UIStoryboard {
        let name = self.storyboardName
        let bundle = self.storyboardBundle
        return UIStoryboard(name: name, bundle: bundle)
    }
    
    @objc class var storyboardBundle: Bundle? {
        return Bundle(for: self)
    }
    
    @objc class var storyboardIdentifier: String {
        return "\(self)"
    }
    
    @objc class var storyboardName: String {
        "Main"
    }
    
    @objc class func instanceFromStoryboard() -> Self {
        let storyboardViewController = storyboard.instantiateViewController(identifier: storyboardIdentifier)
        guard let viewController = storyboardViewController as? Self else{
            
            fatalError( "View controller on storyboard named \(storyboardName) " +
                     "was expected to be an instance of type \(type(of: self)), " +
                     "but it's actually an instance of \(type(of: storyboardViewController)). " +
                   "Fix the type in the storyboard and/or overrride `storyboardIdentifier` with the right value")
        }
        return viewController
    }
    
    
    
}
