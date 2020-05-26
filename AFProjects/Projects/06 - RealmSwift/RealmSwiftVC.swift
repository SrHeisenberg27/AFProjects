//
//  RealmSwiftVC.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit
import RealmSwift

class RealmSwiftVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.createBackButton()


        /*
         GRABAR DATOS
        do {
            let realm = try Realm()

            print(realm.configuration.fileURL)

            let cat1 = Cat(name: "Joe", colour: "Black", gender: "Male")
            let cat2 = Cat(name: "Joa", colour: "White", gender: "Female")
            let cat3 = Cat(name: "Jou", colour: "Green", gender: "Male")

            let cats = [cat1, cat2, cat3]

            do {
                try realm.write {
                    for cat in cats {
                        realm.add(cat)
                    }
                }
            } catch let error as NSError {
                print("error write")
            }
        } catch let error as NSError {
            print("error creating realm")
        }*/

        /*
         RECIBIR DATOS
        do {
            let realm = try Realm()

            let cats = realm.objects(Cat.self)
            
            print("Tengo un gato llamado \(cats[0].name ?? ""), de color \(cats[0].colour ?? "") y de genero \(cats[0].gender ?? "")")
            
            print(cats.filter("name = 'Iván'").count)
        } catch let error as NSError {
            print("error creating realm")
        }*/
    }

    fileprivate func createBackButton() {
        let backbutton = UIButton(type: .custom)
        backbutton.setImage(UIImage(named: "backButton.png"), for: .normal)
        backbutton.setTitle("Back", for: .normal)
        backbutton.setTitleColor(backbutton.tintColor, for: .normal)
        backbutton.addTarget(self, action:
                #selector(backAction(_:)), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbutton)
    }

    @objc func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
