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
    var trackingUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.m_map.delegate = self
        addMarkers()
        addButtonCenterMap()
        self.m_map.showsUserLocation = true
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
    
    // crea un botó per centrar el mapa a la location actual
    func addButtonCenterMap(){
        let image = UIImage(named: "center") as UIImage?
        let button   = UIButton(type: UIButton.ButtonType.custom) as UIButton
        button.frame = CGRect(origin: CGPoint(x:20, y: 20), size: CGSize(width: 25, height: 25))
        button.setImage(image, for: .normal)
        button.backgroundColor = .clear
        button.alpha = 0.5
        
        button.addTarget(self, action: #selector(self.centerMapOnUserButtonClicked), for:.touchUpInside)
        m_map.addSubview(button)
    }
    
    @objc func centerMapOnUserButtonClicked() {
        m_map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        trackingUser = true
    }
    
    // preguntem si l'usuari ha intervingut
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view: UIView = self.m_map.subviews[0] as UIView
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    // deshabilitem el tracking de l'usuari quan es mou el mapa
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool){
        if (self.mapViewRegionDidChangeFromUserInteraction()){
            trackingUser = false
        }
    }
    
    // centra el mapa al MKAnnotationView seleccionat
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        mapView.setCenter(view.annotation!.coordinate, animated: true)
    }
    
    // mostra les annotations al mapa
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
    
    // centrar el mapa al punt actual de la ubicació
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !trackingUser {return}
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let location = userLocation.coordinate
        let region = MKCoordinateRegion(center: location ,span: span)
        self.m_map?.setRegion(region,animated: true)
    }
    
    // enviar a DetailController
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

