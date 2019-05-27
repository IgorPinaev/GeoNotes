//
//  NoteCell.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 24/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    @IBOutlet private weak var imageNote: UIImageView!
    @IBOutlet private weak var labelNameNote: UILabel!
    @IBOutlet private weak var labelDateUpdate: UILabel!
    @IBOutlet private weak var labelLocation: UILabel!
    
    var note: Note?
    
    func initCell(note: Note) {
        self.note = note
        
        if note.imageSmall != nil {
            imageNote.image = UIImage(data: note.imageSmall! as Data)
        } else {
            imageNote.image = UIImage(named: "note_icon.png")
        }
        
        imageNote.layer.cornerRadius = imageNote.frame.width / 2
        imageNote.layer.masksToBounds = true
        
        labelNameNote.text = note.name
        labelDateUpdate.text = note.dateUpdateString
        if let _ =  note.location {
            labelLocation.text = "Location"
        } else {
            labelLocation.text = ""
        }
    }
}
