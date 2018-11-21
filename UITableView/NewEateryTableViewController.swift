//
//  NewEateryTableViewController.swift
//  UITableView
//
//  Created by Konstantin on 11/11/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit
import CloudKit

class NewEateryTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    var isVisited = false
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" || adressTextField.text == "" || typeTextField.text == "" {
            
            let alertController = UIAlertController(title: "Не все поля заполнены", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            // получаем context для последующего сохранения
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let restaurant = Restaurant(context: context) // создаем экземпляр класса в контексте
                restaurant.name = nameTextField.text
                restaurant.location = adressTextField.text
                restaurant.type = typeTextField.text
                restaurant.isVisited = isVisited
                
                if let image = imageView.image {
                    restaurant.image = image.pngData()
                }
                
                do {
                    try context.save() // сохраняем контекст
                    print("Сохранение выполнено")
                } catch let error as NSError {
                    print("Не удалось сохранить данные \(error), \(error.userInfo)")
                }
                saveToCloud(restaurant)
            }
            
            performSegue(withIdentifier: "unwindSegueFromNewEatery", sender: self)
        }
    }
    
    func saveToCloud(_ restaurant: Restaurant) {
   
        let restRecord = CKRecord(recordType: "Restaurant")
        restRecord.setValue(nameTextField.text, forKey: "name")
        restRecord.setValue(typeTextField.text, forKey: "type")
        restRecord.setValue(adressTextField.text, forKey: "location")
        
        guard let originImage = UIImage(data: restaurant.image! as Data) else { return }
        let scale = originImage.size.width > 1080.0 ? 1080.0 / originImage.size.width : 1.0
        let scaledImage = UIImage(data: restaurant.image as! Data, scale: scale)
        let imageFilePath = NSTemporaryDirectory() + restaurant.name!
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        
        do {
            try scaledImage?.jpegData(compressionQuality: 0.7)?.write(to: imageFileURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
        
        let imageAsset = CKAsset(fileURL: imageFileURL)
        restRecord.setValue(imageAsset, forKey: "image")
        
        let publicDataBase = CKContainer.default().publicCloudDatabase
        publicDataBase.save(restRecord) { (record, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            do {
                try FileManager.default.removeItem(at: imageFileURL)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    @IBAction func togglelsVisitedPressed(_ sender: UIButton) {
        if sender == yesButton {
            sender.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            noButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            isVisited = true
        } else if sender == noButton {
            sender.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            yesButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            isVisited = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        noButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        yesButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill //режим отображения
        imageView.clipsToBounds = true //обрезать то что за рамками
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let alertController = UIAlertController(title: NSLocalizedString("Источник фотографии", comment: "Источник фотографии"), message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: NSLocalizedString("Камера", comment: "Камера"), style: .default) { (action) in
                self.chooseImagePickerAction(source: .camera)
            }
            let photoLibAction = UIAlertAction(title: NSLocalizedString("Фото", comment: "Фото"), style: .default) { (action) in
                self.chooseImagePickerAction(source: .photoLibrary)
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("Отмена", comment: "Отмена"), style: .cancel, handler: nil)
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            
            self.present(imagePicker, animated: true, completion: nil)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
