//
//  Place.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import Foundation
import MapKit

class Place{

    enum PlacesTypes{
        case GenericPlace
        case TouristicPlace
    }
    
    var id = ""
    var type = PlacesTypes.GenericPlace
    var name = ""
    var description = ""
    var location: CLLocationCoordinate2D!
    var image:Data? = nil
    
    init(){
        self.id = UUID().uuidString
    }
    
    init(name: String, description: String, image_in:Data?){
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.image = image_in
    }
    
    init(type: PlacesTypes, name: String, description: String, image_in:Data?){
        self.id = UUID().uuidString
        self.name = name
        self.description = description
        self.image = image_in
        self.type = type
    }
}
