//
//  NotificationManager.swift
//  MyPlaces
//
//  Created by Albert Rovira on 03/12/2018.
//  Copyright © 2018 diphone. All rights reserved.
//

import Foundation
import MapKit
import UserNotifications

class NotificationManager: ManagerLocationObserver{
    
    var lastClosestPlace: Place? = nil
    var lastLocation: CLLocation? = nil
    var managerPlaces_provider = ManagerPlaces.shared()
    
    //MARK: Singleton
    private static var sharedNotificationManager: NotificationManager = {
        let shared = NotificationManager()
        var managerLocation_provider = ManagerLocation.shared()
        managerLocation_provider.addLocationOberserver(object: shared)
        return shared
    }()
    
    class func shared() -> NotificationManager{
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {(granted, error) in})
        
        return sharedNotificationManager
    }
    
    // es avisat d'una nova posicio i s'encarrega de fer la notificacio
    private func newLocation(at newLocation: CLLocation){
        
        print ("long: \(newLocation.coordinate.longitude) lat: \(newLocation.coordinate.latitude)")
        
        if (lastLocation != nil && newLocation.coordinate.longitude == lastLocation!.coordinate.longitude && newLocation.coordinate.latitude == lastLocation?.coordinate.latitude){
            // si es el mateix punt no fem res
            return
        }
        
        // busquem el place més pròxim
        var closestPlace: Place? = nil
        var distanceToCurrentPlace: CLLocationDistance? = nil
        
        for place in managerPlaces_provider.places{
            let placeLocation: CLLocation = CLLocation(latitude: place.location.latitude, longitude: place.location.longitude)
            let distance = newLocation.distance(from: placeLocation)
            if (distanceToCurrentPlace == nil || distance.isLess(than: distanceToCurrentPlace!) ){
                closestPlace = place
                distanceToCurrentPlace = distance
            }
        }
        if (closestPlace == nil){
            // si no n'hem trobat cap, res a fer
            return
        }
        
        print ("LastClosestPlace: \(lastClosestPlace?.name) CurrentClosestPlace: \(closestPlace?.name)")
        
        if (lastClosestPlace != nil && closestPlace!.id == lastClosestPlace!.id){
            // si l'anterior place més pròxim és el mateix que l'actual, no fem res
            return
        }
        
        // ens guardem el place més pròxim
        lastClosestPlace = closestPlace
        
        // Creem la notificació
        let content = UNMutableNotificationContent()
        content.title = "You are close to " + closestPlace!.name
        //content.subtitle = "Message subtitle"
        content.body = "Get more info"
        content.badge = 0
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIdentifier = "prova"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                // handle errors
            }
        }
        
    }
    
    func onLocationChange(newLocation: CLLocation) {
        self.newLocation(at: newLocation)
    }
    
}
