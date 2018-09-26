//
//  ManagerPlaces.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import Foundation

class ManagerPlaces{
    var places = [Place]()

    func append(_ value: Place){
        places.append(value)
    }
    
    func GetCount() -> Int{
        return places.count
    }
    
    func GetItemAt(position:Int) -> Place?{
        // TODO: Revisar què tornar si no existeix a la def retorna Place
        return places[position]
    }
    
    func GetItemById(id:String) -> Place?{
        var placesFound = places.filter({$0.id == id})
        return placesFound.count == 1 ? placesFound[0] : nil
    }
    
    func remove(_ value: Place){
        places = places.filter({$0.id != value.id})
//        for i in places.indices{
//            if (palces[i].id == value.id){
//                places.remove(at: i)
//                // com que nomes n'hi pot haver un parem
//                break
//            }
//        }
    }
    
    //MARK: Singleton
    private static var singletonManage: ManagerPlaces = {
        return ManagerPlaces()
    }()
    
    class func share() -> ManagerPlaces{
        return singletonManage
    }
    
    
    
}
