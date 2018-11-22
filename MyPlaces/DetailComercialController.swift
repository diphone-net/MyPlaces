//
//  DetailComercialViewController.swift
//  MyPlaces
//
//  Created by Albert Rovira on 20/11/2018.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit

class DetailComercialController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var detail: UILabel!
    #warning("Intentar treure l optional")
    var place: Place?
    var m_location_manager = ManagerLocation.shared()
    var m_places_manager = ManagerPlaces.shared()
    var m_styler = Styler.shared()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        m_styler.recursiveSetStyle(v: self.view)
        populate()
    }
    
    private func populate(){
        assert(place != nil,"Realizando populate sin place!")
        name.text = place!.name
        image.image = UIImage(contentsOfFile: m_places_manager.GetPathImage(of: place!))
        detail.text = place!.description
        
        //distance
        if let currentLocation = m_location_manager.GetLocation() {
            let (distancia, unitats) = m_location_manager.getDistance(location1: currentLocation, location2: place!.location)
            let fm = NumberFormatter()
            fm.numberStyle = .decimal
            fm.maximumFractionDigits = 0
            distance.text = "Distance from here: \(fm.string(for: distancia)!)\(unitats)"
        }
    }
}
