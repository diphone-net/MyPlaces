//
//  PlaceTurist.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import Foundation

class PlaceTourist: Place{
    
    // MARK: Codable metodes
    enum CodingKeysTourist: CodingKey{
            case discount_tourist
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysTourist.self)
        try container.encode(discount_tourist, forKey: .discount_tourist)
        try super.encode(to: encoder)
    }
    
    override func decodeIntern(from decoder: Decoder) throws {
        try super.decodeIntern(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeysTourist.self)
        discount_tourist = try container.decode(String.self, forKey: .discount_tourist)
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        try decodeIntern(from: decoder)
    }
    
    var discount_tourist = "" {
        // valido que sigui numèric
        didSet{
            let testNumber = Int(discount_tourist)
            if (testNumber == nil || (testNumber != nil && (testNumber! > 100 || testNumber! < 0))) {
                discount_tourist = "0"
            } else {
                discount_tourist = String(testNumber!)
            }
        }
    }
    
    override init(){
        super.init()
        self.type = PlacesTypes.TouristicPlace
    }
    
    init(name: String, description: String, discount_tourist: String, image_in: Data?){
        super.init(type: .TouristicPlace, name: name, description: description, image_in: image_in)
        self.discount_tourist = discount_tourist
    }
    
}
