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

class ManagerPlaces: Codable {
    var places = [Place]()
    var m_observer = Array<ManagerPlacesObserver>()
    
    // MARK: Coding metodes
    enum CodingKeys: CodingKey{
        case places
    }
    
    enum PlacesTypesKeys: CodingKey{
        case type
    }
    
    func encode(to encoder: Encoder) throws{
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(places, forKey: .places)
    }
    
    func decodeIntern(from decoder: Decoder) throws{
        // el problema de fer això o fer-lo automàtic es que no desarialitza els places que son TouristicPlace
        //places = try container.decode([Place], forKey: .places)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        places = [Place]()
        var objectsArrayForType = try container.nestedUnkeyedContainer(forKey: CodingKeys.places)
        
        var tmp_array = objectsArrayForType
        
        while(!objectsArrayForType.isAtEnd){
            let object = try objectsArrayForType.nestedContainer(keyedBy: PlacesTypesKeys.self)
            let type = try object.decode(Int.self, forKey: PlacesTypesKeys.type)
            switch type{
            case Place.PlacesTypes.TouristicPlace.rawValue: // temporal
                self.append(try tmp_array.decode(PlaceTourist.self))
            default:
                self.append(try tmp_array.decode(Place.self))
            }
        }
    }
    
    required convenience init(from decoder: Decoder) throws{
        // el problema de fer això o fer-lo automàtic es que no desarialitza els places que son TouristicPlace
        //let container = try decoder.container(keyedBy: CodingKeys.self)
        //self.places = try container.decode([Place].self, forKey: .places)

        self.init()
        try decodeIntern(from: decoder)
    }
    
    static func load() -> ManagerPlaces? {
        var resul: ManagerPlaces? = nil
        let data_str = FileSystem.Read()
        if (data_str != ""){
            do{
                let decoder = JSONDecoder()
                let data: Data = Data(data_str.utf8)
                resul = try decoder.decode(ManagerPlaces.self, from: data)
                
                // les imatges es carreguen sota demanda des dels controllers
            }
            catch{
                resul = nil
            }
        }
        return resul
    }
    
    func store(){
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            for place in places {
                if (place.image != nil){
                    FileSystem.WriteData(id: place.id, image: place.image!)
                    place.image = nil
                }
            }
            FileSystem.Write(data: String(data: data, encoding: .utf8)!)
        }
        catch{
        }
    }
    
    // MARK: Gestió d Observers
    func addOberserver(object: ManagerPlacesObserver){
        m_observer.append(object)
    }
    
    func updateObserversAndStore(){
        self.store()
        m_observer.forEach{ observer in
           observer.onPlacesChange()
        }
    }

    // MARK: Gestió de Places
    func append(_ value: Place){
        places.append(value)
    }
    
    func remove(_ value: Place){
        places = places.filter({$0.id != value.id})
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
    
    func GetPathImage(of place: Place) -> String{
        return FileSystem.GetPathImage(id: place.id)
    }
    
    // retorna true si hi ha un place diferent a apartFrom amb el mateix nom
    func ExistPlaceLike(name placeName: String, apartFrom exceptionPlace: Place?) -> Bool{
        for place in places{
            if place.name == placeName {
                if (exceptionPlace == nil || (exceptionPlace != nil && exceptionPlace!.id != place.id)) {return true}
            }
        }
        return false
    }
    
    //MARK: Singleton
    private static var sharedManagerPlaces: ManagerPlaces = {
        // intentem carregar el Manager i si ho aconseguim, el retornem
        var loadedManager: ManagerPlaces? = load()
        if (loadedManager != nil) {
            return loadedManager!
        }
        
        // si no ho aconseguim, el creem i el retornem
        return ManagerPlaces()
    }()
    
    class func shared() -> ManagerPlaces{
        return sharedManagerPlaces
    }
}
