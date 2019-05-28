//
//  FoldersController.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 21/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class FoldersController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationManager.sharedInstance.requestAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction private func pushAddAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Create new folder".localize(), message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (text) in
            text.placeholder = "Folder name".localize()
        }
        
        let alertActionAdd = UIAlertAction(title: "Create".localize(), style: UIAlertAction.Style.default) { [unowned self](alert) in
            
            let folderName = alertController.textFields?[0].text
            if folderName != "" {
                _ = Folder.newFolder(name: folderName!.uppercased())
                CoreDataManager.sharedInstance.saveContext()
                self.tableView.reloadData()
            }
        }
        
        let alertActionCancel = UIAlertAction(title: "Cancel".localize(), style: UIAlertAction.Style.default, handler: nil)
        
        alertController.addAction(alertActionCancel)
        alertController.addAction(alertActionAdd)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFolder" {
            guard let selectedRow = tableView.indexPathForSelectedRow?.row,
                let destination = segue.destination as? FolderController  else { return }
            
            destination.folder = folders[selectedRow]
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFolder", for: indexPath)

        let folderInCell = folders[indexPath.row]
    
        cell.textLabel?.text = folderInCell.name
        cell.detailTextLabel?.text = String(folderInCell.notes!.count) + " item(-s)".localize()

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToFolder", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let folderInCell = folders[indexPath.row]
            CoreDataManager.sharedInstance.managedObjectContext.delete(folderInCell)
            CoreDataManager.sharedInstance.saveContext()

            tableView.deleteRows(at: [indexPath], with: .fade)
        }   
    }
}
