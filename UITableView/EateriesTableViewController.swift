//
//  EateriesTableTableViewController.swift
//  UITableView
//
//  Created by Konstantin on 03/11/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit

class EateriesTableViewController: UITableViewController {
    
    var restaurants: [Restaurant] = [
    Restaurant(name: "Ogonёk Grill&Bar", type: "ресторан", location: "Уфа, бульвар Хадии Давлетшиной 21", image: "ogonek.jpg", isVisited: false),
    Restaurant(name: "Елу", type: "ресторан", location: "Уфа", image: "elu.jpg", isVisited: false),
    Restaurant(name: "Bonsai", type: "ресторан", location: "Уфа", image: "bonsai.jpg", isVisited: false),
    Restaurant(name: "Дастархан", type: "ресторан", location: "Уфа", image: "dastarhan.jpg", isVisited: false),
    Restaurant(name: "Индокитай", type: "ресторан", location: "Уфа", image: "indokitay.jpg", isVisited: false),
    Restaurant(name: "X.O", type: "ресторан-клуб", location: "Уфа", image: "x.o.jpg", isVisited: false),
    Restaurant(name: "Балкан Гриль", type: "ресторан", location: "Уфа", image: "balkan.jpg", isVisited: false),
    Restaurant(name: "Respublica", type: "ресторан", location: "Уфа", image: "respublika.jpg", isVisited: false),
    Restaurant(name: "Speak Easy", type: "ресторанный комплекс", location: "Уфа", image: "speakeasy.jpg", isVisited: false),
    Restaurant(name: "Morris Pub", type: "ресторан", location: "Уфа", image: "morris.jpg", isVisited: false),
    Restaurant(name: "Вкусные истории", type: "ресторан", location: "Уфа", image: "istorii.jpg", isVisited: false),
    Restaurant(name: "Классик", type: "ресторан", location: "Уфа", image: "klassik.jpg", isVisited: false),
    Restaurant(name: "Love&Life", type: "ресторан", location: "Уфа", image: "love.jpg", isVisited: false),
    Restaurant(name: "Шок", type: "ресторан", location: "Уфа", image: "shok.jpg", isVisited: false),
    Restaurant(name: "Бочка", type: "ресторан", location:  "Уфа", image: "bochka.jpg", isVisited: false)]
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurants.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        
        cell.thumbnailImageView.image = UIImage(named: restaurants[indexPath.row].image)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.locationLabel.text = restaurants[indexPath.row].location
        cell.typeLabel.text = restaurants[indexPath.row].type
        
        cell.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none
        
        return cell
    }
    
    func showAlert(tableView: UITableView, indexPath: IndexPath) {

        /*
        let ac = UIAlertController(title: nil, message:  "Выберите действие", preferredStyle: .actionSheet)
        
        let call = UIAlertAction(title: "Позвонить +7 911 111-111\(indexPath.row)", style: .default) { (action: UIAlertAction) in
            
            let alertC = UIAlertController(title: nil, message:  "Вызов не может быть  совершен", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertC.addAction(ok)
            self.present(alertC, animated: true, completion: nil)
            
        }
        ac.addAction(call)
        let isVisitedTitle = self.restaurants[indexPath.row].isVisited ? "Я не был здесь" : "Я был здесь"
        let isVisited = UIAlertAction(title: isVisitedTitle, style: .default) { (action: UIAlertAction) in
            let cell = tableView.cellForRow(at: indexPath)
            self.restaurants[indexPath.row].isVisited = !self.restaurants[indexPath.row].isVisited
            cell?.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none
        }
        ac.addAction(isVisited)
        
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        ac.addAction(cancel)
        present(ac, animated: true, completion: nil)
        */
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(tableView: tableView, indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
     self.restaurantImages.remove(at: indexPath.row)
     self.restaurantNames.remove(at: indexPath.row)
     self.restaurantIsVisited.remove(at: indexPath.row)
     //tableView.reloadData()
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .default, title: "Поделиться") { (action, indexPath) in
            let defaultText = "Я сейчас в " + self.restaurants[indexPath.row].name
            if let image = UIImage(named: self.restaurants[indexPath.row].image) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        share.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        let delete  = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        delete.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        return [delete, share]
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! EateryDetailViewController
                dvc.restaurant = self.restaurants[indexPath.row]
            }
        }
        
    }
    
}
