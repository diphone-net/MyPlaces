//
//  ManagerPlaces.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import Foundation

protocol ManagerPlacesObserver {
    func onPlacesChange()
}

class ManagerPlaces{
    var places = [Place]()
    var m_observer = Array<ManagerPlacesObserver>()
    
    func addOberserver(object: ManagerPlacesObserver){
        m_observer.append(object)
    }
    
    func updateObservers(){
        /*for observer in m_observer {
            observer.onPlacesChange()
        }*/
        m_observer.forEach{ observer in
           observer.onPlacesChange()
        }
    }
    
    func append(_ value: Place){
        places.append(value)
    }
    
    func GetCount() -> Int{
        return places.count
    }
    
    func GetItemAt(position:Int) -> Place{
        return places[position]
    }
    
    func GetItemById(id:String) -> Place{
        var placesFound = places.filter({$0.id == id})
        //return placesFound.count == 1 ? placesFound[0] : nil
        // al meu parer hauria de retornar Place? pero vaja
        return placesFound[0]
    }
    
    func remove(_ value: Place){
        places = places.filter({$0.id != value.id})
    }
    
    //MARK: Singleton
    private static var singletonManage: ManagerPlaces = {
        return ManagerPlaces()
    }()
    
    class func shared() -> ManagerPlaces{
        return singletonManage
    }
}
