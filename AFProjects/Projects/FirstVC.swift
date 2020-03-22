//
//  FirstVC.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 21/03/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {

    @IBOutlet public weak var labelText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configurateLabel()
        createNavBar()
    }

    fileprivate func configurateLabel() {
        labelText.text = "FirstVCTest"
        labelText.textColor = UIColor(hex: "#00e600e7")
        labelText.font = UIFont(name: "Helvetica", size: 41)
        labelText.textAlignment = .center

    }

    fileprivate func createNavBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "FirstVC")
        let backItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(backButtonPressed))
        navItem.leftBarButtonItem = backItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }

    @objc fileprivate func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
