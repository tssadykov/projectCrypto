//
//  ContentViewController.swift
//  ProjectCrypto
//
//  Created by Тимур on 15.04.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subheaderLabel: UILabel!
    @IBOutlet weak var pageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var header = ""
    var subheader = ""
    var imageFile = ""
    var index = 0
    
    @IBAction func pageButtonPressed(_ sender: UIButton) {
        switch index {
        case 0:
            let pvc = parent as! StartViewController
            pvc.nextVC(atIndex: index)
        case 1:
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "wasIntroWatched")
            userDefaults.synchronize()
            
            dismiss(animated: true, completion: nil)
        default: break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch  index {
        case 0:
            self.pageButton.setTitle("Next", for: .normal)
        case 1:
            self.pageButton.setTitle("Open", for: .normal)
        default:
            break
        }
        
        pageButton.layer.cornerRadius = 15
        pageButton.clipsToBounds = true
        pageButton.layer.borderWidth = 2
        pageButton.layer.borderColor = pageButton.backgroundColor?.cgColor
        
        headerLabel.text = header
        subheaderLabel.text = subheader
        imageView.image = UIImage(named: imageFile)
        pageControl.numberOfPages = 2
        pageControl.currentPage = index
    }


}
