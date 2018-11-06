//
//  MKMyPointAnnotation.swift
//  MyPlaces
//
//  Created by Albert Rovira on 04/11/2018.
//  Copyright © 2018 diphone. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MKMyPointAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var place_id: String = ""
    var subtitle:String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, place_id: String){
        self.coordinate = coordinate
        self.title = title
        self.place_id = place_id
    }
}
