//
//  SelectFolderController.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 23/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class SelectFolderController: UITableViewController {
    var note: Note?

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return folders.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if indexPath.row == 0 {
            cell.textLabel?.text = "-"
            if note?.folder == nil{
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            let folder = folders[indexPath.row - 1]
            cell.textLabel?.text = folder.name
            if folder == note?.folder {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        return cell
    }
   
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            note?.folder = nil
        } else {
            let folder = folders[indexPath.row - 1]
            note?.folder = folder
        }
        tableView.reloadData()
    }
}
