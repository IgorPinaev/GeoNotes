//
//  FoldersController.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 21/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class FoldersController: UITableViewController {

    
    @IBAction func pushAddAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Create new folder".localize(), message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (text) in
            text.placeholder = "Folder name".localize()
        }
        
        let alertActionAdd = UIAlertAction(title: "Create".localize(), style: UIAlertAction.Style.default) { (alert) in
            
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        LocationManager.sharedInstance.requestAuthorization()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFolder", for: indexPath)

        let folderInCell = folders[indexPath.row]
    
        cell.textLabel?.text = folderInCell.name
        cell.detailTextLabel?.text = String(folderInCell.notes!.count) + " item(-s)".localize()

        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToFolder", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToFolder" {
            let selectedFolder = folders[tableView.indexPathForSelectedRow!.row]
            (segue.destination as! FolderController).folder = selectedFolder
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let folderInCell = folders[indexPath.row]
            CoreDataManager.sharedInstance.managedObjectContext.delete(folderInCell)
            CoreDataManager.sharedInstance.saveContext()

            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
 

}
