//
//  FolderController.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 21/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class FolderController: UITableViewController {
    var folder: Folder?
    
    var notesActual: [Note] {
        return folder?.notesSorted ?? notes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = folder?.name ?? "All notes".localize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    var selectedNote: Note?
    
    @IBAction func pushAddAction(_ sender: Any) {
        selectedNote = Note.newNote(name: "New Note".localize(), inFolder: folder)
        selectedNote?.addCurrentLocation()
        
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNote" {
            guard let destination = segue.destination as? NoteController else { return }
            destination.note = selectedNote
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesActual.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNote", for: indexPath) as! NoteCell

        let noteInCell = notesActual[indexPath.row]
        cell.initCell(note: noteInCell)

        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteInCell = notesActual[indexPath.row]
        selectedNote = noteInCell
        performSegue(withIdentifier: "goToNote", sender: self)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.sharedInstance.managedObjectContext.delete(notesActual[indexPath.row])
            CoreDataManager.sharedInstance.saveContext()
                
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
