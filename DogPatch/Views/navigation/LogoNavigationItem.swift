//
//  LogoNavigationItem.swift
//  DogPatch
//
//  Created by Mdo on 26/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

class LogoNavigationItem: UINavigationItem {
    
    override init(title:String) {
        super.init(title:title)
        setupTitleView()
    }
    
    required init?(coder:NSCoder) {
        super.init(coder:coder)
        setupTitleView()
    }
    
    private func setupTitleView(){
        
        let image = UIImage(named:"logo_do_patch")
        let imageView = UIImageView(image:image)
        titleView = imageView
    }
}
