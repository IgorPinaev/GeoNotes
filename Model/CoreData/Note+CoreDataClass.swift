//
//  Note+CoreDataClass.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 21/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Note)
public class Note: NSManagedObject {
    class func newNote(name: String, inFolder: Folder?) -> Note {
        let note = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        note.name = name
        note.dateUpdate = NSDate()
        
        if let inFolder = inFolder {
            note.folder = inFolder
        }
        
        return note
    }
    
    var imageActual: UIImage? {
        set{
            if newValue == nil {
                if self.image != nil{
                    CoreDataManager.sharedInstance.managedObjectContext.delete(self.image!)
                }
                self.imageSmall = nil
            } else {
                if self.image == nil {
                    self.image = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
                }
                self.image?.imageBig = newValue!.jpegData(compressionQuality: 1) as NSData?
                self.imageSmall = newValue!.jpegData(compressionQuality: 0.05) as NSData?
            }
            dateUpdate = NSDate()
        }
        get{
            if self.image != nil {
                if image?.imageBig != nil
                {
                    return UIImage(data:self.image!.imageBig! as Data)
                }
            }
            return nil
        }
    }
    
    var locationActual: LocationCoordinate? {
        get{
            if self.location == nil {
                return nil
            } else {
                return LocationCoordinate(lat: self.location!.latitude, lon: self.location!.longitude)
            }
        }
        set{
            if newValue == nil && self.location != nil{
                // delete
                CoreDataManager.sharedInstance.managedObjectContext.delete(self.location!)
            }
            
            if newValue != nil && self.location != nil{
                // update
                self.location?.latitude = newValue!.lat
                self.location?.longitude = newValue!.lon
            }
            
            if newValue != nil && self.location == nil{
                // create
                let newLocation = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
                newLocation.latitude = newValue!.lat
                newLocation.longitude = newValue!.lon
                self.location = newLocation
            }
        }
    }
    
    func addCurrentLocation() {
        LocationManager.sharedInstance.getCurrentLocation { (location) in
            self.locationActual = location
            print("\(location)")
        }
    }
    
    func addImage(image: UIImage){
        let imageNote = ImageNote(context: CoreDataManager.sharedInstance.managedObjectContext)
        imageNote.imageBig = image.jpegData(compressionQuality: 1) as NSData?
        self.image = imageNote
    }
    
    func addLocation(latitude: Double, longitude: Double) {
        let location = Location(context: CoreDataManager.sharedInstance.managedObjectContext)
        location.latitude = latitude
        location.longitude = longitude
        self.location = location
    }
    
    var dateUpdateString: String{
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: self.dateUpdate! as Date) ////
    }
}
