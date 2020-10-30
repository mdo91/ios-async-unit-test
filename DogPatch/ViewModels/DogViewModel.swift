//
//  DogViewModel.swift
//  DogPatch
//
//  Created by Mdo on 27/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit


class DogViewModel{
    
    //MARK: - Static Properties
    
    static let costFormatter:NumberFormatter = {
        
        let numberFormater = NumberFormatter()
        numberFormater.numberStyle = .decimal
        numberFormater.maximumFractionDigits = 2
        return numberFormater
    }()
    
    //MARK: - Instance Properties
    
    let dog:Dog
    let age:String
    let breed:String
    let breederRatingImage:UIImage
    let cost:String
    var created:String
    var imageURL:URL
    var name:String
    
    init(dog:Dog) {
        self.dog = dog
        self.age = DogViewModel.age(dog)
        self.breed = dog.breed
        self.cost = "$\(DogViewModel.cost(dog))"
        self.imageURL = dog.imageURL
        self.name = dog.name
        self.created = DogViewModel.created(dog)
        self.breederRatingImage = DogViewModel.breederRatingImage(dog)
    }
    
    private static func breederRatingImage(_ dog:Dog) ->UIImage{
        
        let name: String
        switch dog.breederRating {
        case ..<1.5: name = "star_rating_1"
        case 1.5..<2.0: name = "star_rating_1.5"
        case 2.0..<2.5: name = "star_rating_2"
        case 2.0..<3.0: name = "star_rating_2.5"
        case 3.0..<3.5: name = "star_rating_3.5"
        case 4.0..<4.5: name = "star_rating_4.0"
        case 4.5..<5.0: name = "star_rating_4.5"
        case 5.0...   :  name = "star_rating_5"
            
        default: name = "star_rating_1"
            
        }
        return UIImage(named: name)!
    }
    
    private static func cost(_ dog:Dog) -> String{
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        numberFormmater.maximumFractionDigits = 2
        return costFormatter.string(for: dog.cost)!
    }
    
    private static func created(_ dog:Dog) ->String{
        let format = NSLocalizedString("%@ ago", comment: "Formatted Date: XYZ ago")
        let dateString = self.dateString(dog.birthday)
        return String(format: format, dateString)
    }
    
    private static func age(_ dog:Dog) -> String{
        let format = NSLocalizedString("%@ old", comment: "Formatted Date String: XYZ old")
        let dateString = self.dateString(dog.birthday)
        return String(format: format, dateString)
        
    }
    
    private static func dateString(_ date:Date) -> String{
        
        let calendar =  Calendar.current
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .full
        dateFormatter.maximumUnitCount = 1
        dateFormatter.calendar = calendar
        let dateComponents = calendar.dateComponents([.year, .month,.weekOfMonth, .day, .hour,.minute, .second], from: date, to: Date())
        
        if let years = dateComponents.year, years > 0 {
            dateFormatter.allowedUnits = [.year]
        } else if let months = dateComponents.month, months > 0 {
             dateFormatter.allowedUnits = [.month]
           } else if let weeks = dateComponents.weekOfMonth, weeks > 0 {
             dateFormatter.allowedUnits = [.weekOfMonth]
           } else if let days = dateComponents.day, days > 0 {
             dateFormatter.allowedUnits = [.day]
           } else if let hours = dateComponents.hour, hours > 0 {
             dateFormatter.allowedUnits = [.hour]
           } else if let minutes = dateComponents.minute, minutes > 0 {
             dateFormatter.allowedUnits = [.minute]
           } else {
             dateFormatter.allowedUnits = [.second]
           }
        
        return dateFormatter.string(from: date,to: Date())!
    }
    
    func configure(_ cell:ListingTableViewCell) {
        cell.ageLable.text = age
        cell.breaderRatingImageView.image = breederRatingImage
        cell.breedLable.text = breed
        cell.nameLable.text = name
        cell.createdLable.text = created
        cell.costLable.text = cost
        
    }
    
}
extension DogViewModel:Equatable{
    static func ==(lhs: DogViewModel,rhs:DogViewModel) -> Bool{
        
        return lhs.dog == rhs.dog
        
    }
    
}
