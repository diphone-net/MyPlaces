//
//  ManagerLocation.swift
//  MyPlaces
//

//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation
import MapKit

class ManagerLocation: NSObject, CLLocationManagerDelegate
{
    static var pos:Int = 0
    var m_locationManager: CLLocationManager!
    
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
            manager.m_locationManager.requestWhenInUseAuthorization()
        }else{
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
}
