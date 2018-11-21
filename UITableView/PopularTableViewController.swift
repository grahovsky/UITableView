//
//  PopularTableViewController.swift
//  UITableView
//
//  Created by Konstantin on 21/11/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit
import CloudKit

class PopularTableViewController: UITableViewController {
    
    var restaurants: [CKRecord] = []
    let publicDataBase = CKContainer.default().publicCloudDatabase
    var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        tableView.addSubview(spinner)
        
//        spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
//        spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
       
        NSLayoutConstraint(item: spinner, attribute: .centerX, relatedBy: .equal, toItem: tableView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: spinner, attribute: .centerY, relatedBy: .equal, toItem: tableView, attribute: .centerY, multiplier: 0.8, constant: 0).isActive = true
        
        getCloudRecords()
        
    }
    
    func getCloudRecords() {
        
        //        let predicate = NSPredicate(value: true)
        //        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        //
        //        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
        //            guard error == nil else {
        //                print(error)
        //                return
        //            }
        //            if let records = records {
        //                self.restaurants = records
        //                // т.к. код выполняется в фоне, обновление нужно вызвать в основном потоке
        //                DispatchQueue.main.async {
        //                    self.tableView.reloadData()
        //                }
        //            }
        //        }
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        query.sortDescriptors = [sort]
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.resultsLimit = 10
        queryOperation.queuePriority = .veryHigh
        queryOperation.recordFetchedBlock = { (record: CKRecord!) in
            if let record = record {
                self.restaurants.append(record)
            }
        }
        queryOperation.queryCompletionBlock = { (cursor, error) in
            guard error == nil else {
                print("Не удалось получить записи из iCloud: \(error?.localizedDescription)")
                return
            }
            
            print("Записи успешно получены из iCloud®")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        publicDataBase.add(queryOperation)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.object(forKey: "name") as? String
        
        cell.imageView?.image = UIImage(named: "photo")
        let fetchRecordsOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
        fetchRecordsOperation.desiredKeys = ["image"]
        fetchRecordsOperation.queuePriority = .veryHigh
        fetchRecordsOperation.perRecordCompletionBlock = { (record, recordID, error) in
            guard error == nil else {
                print("Не удалось получить изображение из iCloud: \(error?.localizedDescription)")
                return
            }
            
            if let record = record {
                if let image = record.object(forKey: "image")  {
                    let image = image as! CKAsset
                    let data = try? Data(contentsOf: image.fileURL)
                    if let data = data {
                        DispatchQueue.main.async {
                            cell.imageView?.image = UIImage(data: data)
                            self.spinner.stopAnimating()
                        }
                    }
                }
            }
        }
        
        publicDataBase.add(fetchRecordsOperation)
        
        return cell
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
