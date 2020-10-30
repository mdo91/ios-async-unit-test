//
//  User.swift
//  DogPatch
//
//  Created by Mdo on 26/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import Foundation

struct User:Decodable,Equatable {
    
    //MARK: - Identifier Properties
    let id: String
    
    //MARK: - Instance Properties
    let about:String?
    let email:String
    let name:String
    let profileImageURL:URL?
    let reviewCount:UInt
    let reviewRatingAverage:Double
    
    
    
    
}
