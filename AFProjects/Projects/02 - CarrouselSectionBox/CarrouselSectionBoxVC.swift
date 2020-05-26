//
//  CarrouselSectionBoxVC.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 11/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

class CarrouselSectionBoxVC: UIViewController {

    @IBOutlet public weak var scrollView: UIScrollView!
    @IBOutlet public weak var viewS: UIView!
    @IBOutlet public weak var carrouselSectionBox1: CarrouselSectionBoxComponent!
    @IBOutlet public weak var carrouselSectionBox2: CarrouselSectionBoxComponent!
    @IBOutlet public weak var carrouselSectionBox3: CarrouselSectionBoxComponent!
    @IBOutlet public weak var carrouselSectionBox4: CarrouselSectionBoxComponent!

    let view1Carrousel1 = CarrouselSectionBoxView1()
    let view2Carrousel1 = CarrouselSectionBoxView1()
    let view3Carrousel1 = CarrouselSectionBoxView1()
    var viewsCarrousel1: [UIView] = []

    let view1Carrousel2 = CarrouselSectionBoxView2()
    let view2Carrousel2 = CarrouselSectionBoxView2()
    let view3Carrousel2 = CarrouselSectionBoxView2()
    let view4Carrousel2 = CarrouselSectionBoxView2()
    var viewsCarrousel2: [UIView] = []

    let view1Carrousel3 = CarrouselSectionBoxView3()
    let view2Carrousel3 = CarrouselSectionBoxView3()
    let view3Carrousel3 = CarrouselSectionBoxView3()
    let view4Carrousel3 = CarrouselSectionBoxView3()
    var viewsCarrousel3: [UIView] = []

    let view1Carrousel4 = CarrouselSectionBoxView4()
    let view2Carrousel4 = CarrouselSectionBoxView4()
    let view3Carrousel4 = CarrouselSectionBoxView4()
    let view4Carrousel4 = CarrouselSectionBoxView4()
    let view5Carrousel4 = CarrouselSectionBoxView4()
    var viewsCarrousel4: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getViews()

        let actions1 = [clickCellAction1, clickCellAction2, clickCellAction3, clickCellAction4, clickCellAction5]

        carrouselSectionBox1.setupCarrouselSectionBox(views: viewsCarrousel1, actions: actions1)
        carrouselSectionBox2.setupCarrouselSectionBox(views: viewsCarrousel2, actions: actions1)
        carrouselSectionBox3.setupCarrouselSectionBox(views: viewsCarrousel3, actions: actions1)
        carrouselSectionBox4.setupCarrouselSectionBox(views: viewsCarrousel4, actions: actions1)
    }

    public func getViews() {
        self.view1Carrousel1.setupView(title: "Cuenta A", iban: "**** **** **** 8391")
        self.viewsCarrousel1.append(self.view1Carrousel1)
        self.view2Carrousel1.setupView(title: "Cuenta B", iban: "**** **** **** 1131")
        self.viewsCarrousel1.append(self.view2Carrousel1)
        self.view3Carrousel1.setupView(title: "Cuenta C", iban: "**** **** **** 0924")
        self.viewsCarrousel1.append(self.view3Carrousel1)

        self.view1Carrousel2.setupView(title: "Tarjeta Visa", iban: "836,93€", otherLabel: "Crédito", number2: "43,93€")
        self.viewsCarrousel2.append(self.view1Carrousel2)
        self.view2Carrousel2.setupView(title: "Tarjeta Pay&Rest", iban: "8236,93€", otherLabel: "Prepago", number2: "93,13€")
        self.viewsCarrousel2.append(self.view2Carrousel2)
        self.view3Carrousel2.setupView(title: "Tarjeta Go", iban: "23,09€", otherLabel: "Crédito", number2: "24,93€")
        self.viewsCarrousel2.append(self.view3Carrousel2)
        self.view4Carrousel2.setupView(title: "Tarjeta 4O Principales", iban: "0,39€", otherLabel: "Prepago", number2: "12,93€")
        self.viewsCarrousel2.append(self.view4Carrousel2)

        self.view1Carrousel3.setupView(title: "MyBox Auto", iban: "Llama al 999 999 999", otherLabel: "Incluye grúa")
        self.viewsCarrousel3.append(self.view1Carrousel3)
        self.view2Carrousel3.setupView(title: "MyBox Vida", iban: "Llama al 999 999 999", otherLabel: "Siempre a salvo")
        self.viewsCarrousel3.append(self.view2Carrousel3)
        self.view3Carrousel3.setupView(title: "MyBox Hogar", iban: "Llama al 999 999 999", otherLabel: "Te limpiamos la casa")
        self.viewsCarrousel3.append(self.view3Carrousel3)
        self.view4Carrousel3.setupView(title: "MyBox Salud", iban: "Llama al 999 999 999", otherLabel: "Test COVID-19 incluido")
        self.viewsCarrousel3.append(self.view4Carrousel3)

        self.view1Carrousel4.setupView(title: "Audi A4", iban: "87.929,09€", otherLabel: "Incluye volante")
        self.viewsCarrousel4.append(self.view1Carrousel4)
        self.view2Carrousel4.setupView(title: "McLaren Senna", iban: "297.929,90€", otherLabel: "4 ruedas incluidas")
        self.viewsCarrousel4.append(self.view2Carrousel4)
        self.view3Carrousel4.setupView(title: "Ferrari LaFerrari", iban: "357.929,00€", otherLabel: "Incluye motor")
        self.viewsCarrousel4.append(self.view3Carrousel4)
        self.view4Carrousel4.setupView(title: "Mercedes Clase E", iban: "7.929,90€", otherLabel: "Razón aquí")
        self.viewsCarrousel4.append(self.view4Carrousel4)
        self.view5Carrousel4.setupView(title: "Seat Panda", iban: "2,99€", otherLabel: "Ventanas incluidas")
        self.viewsCarrousel4.append(self.view5Carrousel4)
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func clickCellAction(index: Int) {
        let alertController = UIAlertController(title: "Carrousel Section Box", message: "Has pulsado en \(index)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }


    func clickCellAction1() {
        clickCellAction(index: 1)
    }

    func clickCellAction2() {
        clickCellAction(index: 2)
    }

    func clickCellAction3() {
        clickCellAction(index: 3)
    }

    func clickCellAction4() {
        clickCellAction(index: 4)
    }

    func clickCellAction5() {
        clickCellAction(index: 5)
    }
}
