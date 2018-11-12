//
//  EateriesTableTableViewController.swift
//  UITableView
//
//  Created by Konstantin on 03/11/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit
import CoreData

class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var restaurants: [Restaurant] = [] // class Restaurant создается в Eateries.xcdatamodeld в Data model inspector "NSManagedObject"
    var fetchResultsController: NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filteredResultArray: [Restaurant] = []
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func filterContentFor(searchText text: String) {
        filteredResultArray = restaurants.filter{ (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))! // только те элементы имеющие name в нижнем регистре содержащий введенный текст в нижнем регистре
        }
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
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest() // создаем запрос выборки
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true) // дескриптор сортировки по полю name
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
         
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) // контроллер для управления результатом запроса выборки данных
            
            fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                restaurants = fetchResultsController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        searchController = UISearchController(searchResultsController: nil) // результаты отображаются на главном экране
        searchController.searchResultsUpdater = self // какой контроллер будет обновлять результаты необходим протокол UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false // затемнение отключаем
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) // цвет бара
        searchController.searchBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // цвет текста
        
        tableView.tableHeaderView = searchController.searchBar // хеадеру таблицы присваиваем поисковую панель
     
        definesPresentationContext = true // чтобы searchController не переходил на следующий экран
    }
    
    // MARK: - Fetch results controller delegate
   
    // вызывается перед тем как контроллер поменяет свой контент
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates() // предупреждает tableView что будут обновления
    }
    
    // вызывается в зависимости от того как были изменены данные контроллера
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade) // добавление ряда
        case .delete: guard let indexPath = newIndexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade) // удаление ряда
        case .update: guard let indexPath = newIndexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade) // обновление
        default:
            tableView.reloadData() // перегружаем весь tableView
        }
        
        restaurants = controller.fetchedObjects as! [Restaurant] // обновляем restaurants данными в контоллере
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates() // предупредили что изменения закончились
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if searchController.isActive && searchController.searchBar.text != "" {
           return filteredResultArray.count
        } else {
            return restaurants.count
        }
    }
    
    func restaurantToDisplayAt(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filteredResultArray[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        
        let restaurant = restaurantToDisplayAt(indexPath: indexPath) // выбираем элемент с учетом поиска
        
//        cell.thumbnailImageView.image = UIImage(named: restaurants[indexPath.row].image)
        cell.thumbnailImageView.image = UIImage(data: restaurant.image! as Data) // image - binary data кастим до Data
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        
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
            let defaultText = "Я сейчас в " + self.restaurants[indexPath.row].name!
            //if let image = UIImage(named: self.restaurants[indexPath.row].image) {
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        share.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        let delete  = UITableViewRowAction(style: .default, title: "Удалить") { (action, indexPath) in
            
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            
                // выбираем объект, который хотим удалить
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete) // удаляем объект из контекста
                
                do {
                    try context.save() // сохраняем контекст без удаленного объекта
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }
            
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
                dvc.restaurant = restaurantToDisplayAt(indexPath: indexPath) // с учетом поиска
            }
        }
        
    }
    
}

extension EateriesTableViewController: UISearchResultsUpdating {
   
    // срабатывает в любой момент времени когда что-то вводится в строку поиска
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
    
}

extension EateriesTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false // убираем скрытие при свайпе когда редактируется поиск
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true // возвращаем скрытие при свайпе когда редактирование поиска закончено
    }
    
}
