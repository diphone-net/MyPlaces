//
//  FileSystem.swift
//  MyPlaces
//

//  Copyright © 2018 UOC. All rights reserved.
//

import Foundation

class FileSystem
{
    class func GetPathBase() -> String
    {
        let pathBase:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        do{
            let fileManager:FileManager = FileManager()
            try fileManager.createDirectory(atPath: pathBase, withIntermediateDirectories: true, attributes: nil)
        }
        catch
        {
        }
        
        return pathBase
    }
    
    class func GetPath() -> URL
    {
        // Get App Document directory
        let pathBase:String = GetPathBase()
        let pathBD:String = pathBase + "/database.txt"
        let url:URL = URL(fileURLWithPath: pathBD)
        return url
    }
    
    class func Read() -> String
    {
        var data:String = ""
        do {
             data = try String(contentsOf: GetPath(), encoding: .utf8)
        }
        catch {
            //************ error handling
        }
        //print("Llegint això: \(data)")
        return data
    }
    
    class func ReadData(id: String) -> Data?{
        let path = GetPathBase() + "/" + id
        var data:Data?
        
        do{
            data = try Data(contentsOf: URL(fileURLWithPath: path))
        }
        catch{
            // error handling
        }
        return data
    }
    
    
    class func GetPathImage(id:String)->String
    {
        return GetPathBase()+"/"+id;
        
    }
    
    // implementació temporal fins veure com s'implementa a la pla3
    class func WriteData(id:String,image:Data)
    {
        do {
            try image.write(to: URL(fileURLWithPath:GetPathImage(id: id)))
        }
        catch {
            //************ error handling
        }
    }

    class func Write(data:String)
    {
        //print ("Guardant això: \(data)")
        do {
            try data.write(to: GetPath(), atomically: false, encoding: .utf8)
        }
        catch {
            //************ error handling
        }
    }
}
