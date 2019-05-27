//
//  Folder+CoreDataClass.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 21/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    class func newFolder(name: String) -> Folder {
       let folder = Folder(context: CoreDataManager.sharedInstance.managedObjectContext)
        folder.name = name
        folder.dateUpdate = NSDate()
        
        return folder
    }
    
    func addNoteToFolder() -> Note {
        let note = Note(context: CoreDataManager.sharedInstance.managedObjectContext)
        note.folder = self
        note.dateUpdate = NSDate()
        return note
    }
    
    var notesSorted: [Note] {
        let sortDescriptor = NSSortDescriptor(key: "dateUpdate", ascending: false)
        return self.notes?.sortedArray(using: [sortDescriptor]) as! [Note]
    }
}
