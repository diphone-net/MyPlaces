//
//  ManagerLocation.swift
//  MyPlaces
//

//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class ManagerLocation: NSObject, CLLocationManagerDelegate
{
    static var pos:Int = 0
    var m_locationManager: CLLocationManager!
    var notificationManager_provider: NotificationManager = NotificationManager.shared()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations[locations.endIndex - 1 ]
        notificationManager_provider.newLocation(at: currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Error: \(error)")
    }
    
    private static var sharedManagerLocation: ManagerLocation = {
        var singletonManager: ManagerLocation?
        
        if (singletonManager == nil){
            singletonManager = ManagerLocation()
            singletonManager!.m_locationManager = CLLocationManager()
            singletonManager!.m_locationManager.delegate = singletonManager
            prepareLocation(for: singletonManager!)
        }
        return singletonManager!
    }()
    
    private static func prepareLocation(for manager: ManagerLocation){
        // permetre actualitzacions en background
        manager.m_locationManager.allowsBackgroundLocationUpdates = true
        
        // distància mínima d'actualitzacio
        manager.m_locationManager.distanceFilter = 10
        
        // forma optima d obtenir la localitzacio
        manager.m_locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined){
            //manager.m_locationManager.requestWhenInUseAuthorization()
            manager.m_locationManager.requestAlwaysAuthorization()
        }
        if (CLLocationManager.locationServicesEnabled()){
            manager.startLocation()
        }
    }
    
    class func shared() -> ManagerLocation {
        return sharedManagerLocation
    }
    
    func startLocation(){
        m_locationManager.startUpdatingLocation()
    }
    
    func GetLocation()->CLLocationCoordinate2D?{
        // controlem el cas que no s'hagi pogut obtenir localització∫
        if let loc = m_locationManager.location{
            //print ("Current loc: Lat:\(loc.coordinate.latitude) Long:\(loc.coordinate.longitude) Alt:\(loc.altitude)")
            return loc.coordinate
        } else {
            return nil
        }
    }
    
    func GetStatus() -> CLAuthorizationStatus{
        return CLLocationManager.authorizationStatus()
    }
    
    func getDistance(location1: CLLocationCoordinate2D, location2: CLLocationCoordinate2D) -> (CLLocationDistance, String){
        let location1Location:CLLocation = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
        let location2Location: CLLocation = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        
        var distance:CLLocationDistance = (location1Location.distance(from: location2Location))
        var units = "m"
        if distance > 1000 {
            distance = distance / 1000
            units = "Km"
        }
        return (distance, units)
    }
}
