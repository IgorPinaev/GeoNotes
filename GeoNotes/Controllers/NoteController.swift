//
//  NoteController.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 22/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import UIKit

class NoteController: UITableViewController {

    var note: Note?
    
    @IBOutlet weak var labelFolder: UILabel!
    @IBOutlet weak var labelFolderName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    
    @IBAction func pushShareAction(_ sender: Any) {
        
        var activities: [Any] = []
        
        if let image =  note?.imageActual{
            activities.append(image)
        }
        activities.append(note?.name ?? "")
        activities.append(note?.textDescription ?? "")
        
        let activityController = UIActivityViewController(activityItems: activities, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if note?.name != "Untitled".localize(){
            textName.text = note?.name
        } 
        textDescription.text = note?.textDescription
        imageView.image = note?.imageActual
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        
        navigationItem.title = note?.name
        
    }

    override func viewWillAppear(_ animated: Bool) {
        if let folder = note?.folder {
            labelFolderName.text = folder.name
        } else {
            labelFolderName.text = "-"
        }
    }
    
    @IBAction func pushDoneAction(_ sender: Any) {
        saveNote()
        navigationController?.popViewController(animated: true)
    }
    
    func saveNote() {
        if textName.text == "" && textDescription.text == "" && imageView.image == nil
        {
            CoreDataManager.sharedInstance.managedObjectContext.delete(note!)
            CoreDataManager.sharedInstance.saveContext()
            return
        }
        
        if note?.name != textName.text || note?.textDescription != textDescription.text {
            note?.dateUpdate = NSDate()
        }
        
        if textName.text != ""{
            note?.name = textName.text
        } else {
            note?.name = "Untitled".localize()
        }
        note?.textDescription = textDescription.text
        
        CoreDataManager.sharedInstance.saveContext()
    }
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 && indexPath.section == 0 {
            let alertController = UIAlertController(title: nil, message: "Image for item".localize(), preferredStyle: UIAlertController.Style.actionSheet)
            let action1Camera = UIAlertAction(title: "Make a photo".localize(), style: UIAlertAction.Style.default) { (alert) in
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(action1Camera)
            
            let action2Photo = UIAlertAction(title: "Select from library".localize(), style: UIAlertAction.Style.default) { (alert) in
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(action2Photo)
            
            if self.imageView.image != nil {
            let action3Delete = UIAlertAction(title: "Delete".localize(), style: UIAlertAction.Style.destructive) { (alert) in
                self.imageView.image = nil
            }
            alertController.addAction(action3Delete)
            }
            
            let action4Cancel = UIAlertAction(title: "Cancel".localize(), style: UIAlertAction.Style.cancel, handler: nil)
            alertController.addAction(action4Cancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSelectFolder" {
            (segue.destination as! SelectFolderController).note = note
        }
        
        if segue.identifier == "goToMap" {
            (segue.destination as! NoteMapController).note = note
        }
    }
}

extension NoteController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        note?.imageActual = imageView.image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
