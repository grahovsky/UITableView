//
//  ViewController.swift
//  UITableView
//
//  Created by Konstantin on 02/11/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Hello", message: "Hello world App", preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        ac.addAction(alertAction)
        
        present(ac, animated: true, completion: nil)
        
    }
    
}

