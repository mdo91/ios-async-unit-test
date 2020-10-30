//
//  ErrorTableViewCell.swift
//  DogPatch
//
//  Created by Mdo on 26/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

class ErrorTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLable:UILabel!
    @IBOutlet var subTitleLable: UILabel!
    
    @IBOutlet var containerView:UIView!{
        
        didSet{
            
            //todo apply shaddow
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
