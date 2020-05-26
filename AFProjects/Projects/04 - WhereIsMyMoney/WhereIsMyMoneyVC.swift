//
//  WhereIsMyMoneyVC.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 24/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

class WhereIsMyMoneyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func button(sender: UIButton) {
        let storyboard = UIStoryboard(name: "WhereIsMyMoney", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WhereIsMyMoneyMainVC")
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func back(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
