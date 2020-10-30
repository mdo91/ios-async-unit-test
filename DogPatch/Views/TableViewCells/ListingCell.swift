//
//  ListingCell.swift
//  DogPatch
//
//  Created by Mdo on 26/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

class ListingTableViewCell:UITableViewCell{
    
    @IBOutlet var ageLable:UILabel!
    @IBOutlet var breedLable:UILabel!
    @IBOutlet var breaderRatingImageView:UIImageView!
    @IBOutlet var costLable:UILabel!
    @IBOutlet var createdLable:UILabel!
    @IBOutlet var dogImageView:UIImageView!
    @IBOutlet var nameLable:UILabel!
    @IBOutlet var containerView:UIView!{
        
        didSet{
            //todo set shadow
            containerView.applyShadow()
            let selectedBackgroundView = UIView(frame: containerView.frame)
            selectedBackgroundView.backgroundColor = UIColor(named: "background")!
            
            self.selectedBackgroundView = selectedBackgroundView
        }
    }
    
}
