//
//  SecondViewController.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit
import MapKit

class SecondViewController: UIViewController, MKMapViewDelegate, ManagerPlacesObserver {

    @IBOutlet weak var m_map: MKMapView!
    var m_provider = ManagerPlaces.shared()
    var selectedPlace: Place? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.m_map.delegate = self
        addMarkers()
        #warning ("Es carrega cada cop? potser es fa l'addMarkers 2 cops")
        m_provider.addOberserver(object: self)
     }
    
    func onPlacesChange() {
        self.removeMarkers()
        self.addMarkers()
    }
    
    func removeMarkers(){
        let llista = self.m_map.annotations.filter {!($0 is MKUserLocation)}
        self.m_map.removeAnnotations(llista)
    }
    
    func addMarkers(){
        for i in 0..<m_provider.GetCount(){
            let p = m_provider.GetItemAt(position: i)
            let coordinada = CLLocationCoordinate2D(latitude: p.location.latitude, longitude: p.location.longitude)
            let annotation: MKMyPointAnnotation = MKMyPointAnnotation(coordinate: coordinada, title: p.name, place_id: p.id)
            self.m_map.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKMyPointAnnotation{
            let identifier = "CustomPinAnnotationView"
            var pinView: MKPinAnnotationView
            if let dequeuedView = self.m_map?.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            } else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView.canShowCallout = true
                pinView.calloutOffset = CGPoint(x: -5, y: 5)
                pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
                pinView.setSelected(true, animated: true)
            }
            return pinView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let annotation: MKMyPointAnnotation = view.annotation as! MKMyPointAnnotation
        // Mostrar el DetailController de este place
        selectedPlace = m_provider.GetItemById(id: annotation.place_id)
        performSegue(withIdentifier: "showFromMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFromMap" {
            if let destinationVC = segue.destination as? DetailController {
                destinationVC.place = selectedPlace!
            }
        }
    }


}

