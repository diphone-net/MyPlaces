//
//  PlaceTurist.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import Foundation

class PlaceTourist: Place{
    
    var discount_tourist = ""
    
    override init(){
        super.init()
        self.type = PlacesTypes.TouristicPlace
    }
    
    init(name: String, description: String, discount_tourist: String, image_in: Data?){
        super.init(type: .TouristicPlace, name: name, description: description, image_in: image_in)
        self.discount_tourist = discount_tourist
    }
    
}
