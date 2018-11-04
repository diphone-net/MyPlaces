//
//  Place.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import Foundation
import MapKit

class Place: Codable{
    
    // MARK: Codable metodes
    enum PlacesTypes: Int, Codable{
        case GenericPlace
        case TouristicPlace
    }
    
    enum CodingKeys: CodingKey{
        case id
        case description
        case name
        case type
        case latitude
        case longitude
        //case location // casca perque CLLocationCoordinate2D no es Codable
        //case image // ho podriem fer però no ho fem
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // encode vars
        try container.encode(self.id, forKey: CodingKeys.id)
        try container.encode(self.description, forKey: CodingKeys.description)
        try container.encode(self.name, forKey: CodingKeys.name)
        try container.encode(self.type, forKey: CodingKeys.type)
        try container.encode(self.location.latitude, forKey: CodingKeys.latitude)
        try container.encode(self.location.longitude, forKey: CodingKeys.longitude)
        //try container.encode(self.image, forKey: CodingKeys.image)
    }
    
    func decodeIntern(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        description = try container.decode(String.self, forKey: .description)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(Place.PlacesTypes.self, forKey: .type)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //image = try container.decode(Data?.self, forKey: .image)
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        try decodeIntern(from: decoder)
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
