//
//  ContentViewController.swift
//  UITableView
//
//  Created by Konstantin on 18/11/2018.
//  Copyright © 2018 Konstantin. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControll: UIPageControl!
    @IBOutlet weak var pageButton: UIButton!
    
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0
    
    @IBAction func pageButtonPressed(_ sender: UIButton) {
    
        switch index {
        case 0:
            let pageVC = parent as! PageViewController
            pageVC.nextVC(atIndex: index)
        case 1:
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        headerLabel.text = header
        subheaderLabel.text = subheader
        imageView.image = UIImage(named: imageFile)
        
        pageControll.numberOfPages = 2
        pageControll.currentPage = index
        
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true // обрезка границ
        pageButton.layer.borderWidth = 2
        pageButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        pageButton.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
        switch index {
        case 0:
            pageButton.setTitle("Дальше", for: .normal)
        case 1:
            pageButton.setTitle("Открыть", for: .normal)
        default:
            break
        }
    }
    
    
}
