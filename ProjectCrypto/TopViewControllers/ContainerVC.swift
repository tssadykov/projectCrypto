//
//  ViewController.swift
//  ProjectCrypto
//
//  Created by Тимур on 20.02.2018.
//  Copyright © 2018 Тимур. All rights reserved.
//

import UIKit

var sideMenuOpen = false
var isMovable = true

class ContainerVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragTheView))
        mainView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func toggleSideMenu() {
        if sideMenuOpen {
            sideMenuOpen = false
            sideMenuConstraint.constant = -240
        } else {
            sideMenuOpen = true
            sideMenuConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //анимация
    @objc func dragTheView(recognizer: UIPanGestureRecognizer) {
        guard isMovable else { return }
        if recognizer.state == .began {
        } else if recognizer.state == .changed {
            let translation = recognizer.translation(in: self.view)
            
            if (!sideMenuOpen) {
                if ((-240 + translation.x) >= -240) && ((-240 + translation.x) <= 0) {
                    sideMenuConstraint.constant = -240 + translation.x
                }
            } else {
                if (translation.x <= 0) && (translation.x >= -240) {
                    sideMenuConstraint.constant = translation.x
                }
            }
        } else if recognizer.state == .ended {
            if sideMenuConstraint.constant > -120 {
                sideMenuConstraint.constant = 0
                sideMenuOpen = true
            } else {
                sideMenuConstraint.constant = -240
                sideMenuOpen = false
            }
        }
    }
}
