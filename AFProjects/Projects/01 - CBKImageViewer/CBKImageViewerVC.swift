//
//  DMCBKImageViewer.swift
//  DEMO
//
//  Created by Alvaro Ferrandez Gomez on 03/01/2020.
//  Copyright © 2020 everis . All rights reserved.
//

import UIKit

class DMCBKImageViewer: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewS: UIView!
    @IBOutlet weak var imageViewer1: CBKImageViewer!
    @IBOutlet weak var imageViewer2: CBKImageViewer!
    @IBOutlet weak var imageViewer3: CBKImageViewer!
    @IBOutlet weak var imageViewer4: CBKImageViewer!

    let imageTest = UIImage(named: "rr11")

    let photo0 = "https://int.loc1.caixabank.es/imatge/renting/imagen0_925x480.jpg"
    let photo1 = "https://int.loc1.caixabank.es/imatge/renting/imagen1_925x480.jpg"
    let photo2 = "https://int.loc1.caixabank.es/imatge/renting/imagen2_925x480.jpg"
    let photo3 = "https://int.loc1.caixabank.es/imatge/renting/imagen3_925x480.jpg"
    let photo7 = "https://int.loc1.caixabank.es/imatge/renting/imagen4_925x480.jpg"
    let photo5 = "https://pbs.twimg.com/profile_images/2730605698/de2bb1ff51d1c00d1569a58888752495_400x400.jpeg"
    let photo6 = "https://phantom-elmundo.unidadeditorial.es/88f29b2896dce59b6bf88fbe22ab28af/crop/0x0/1024x682/resize/746/f/jpg/assets/multimedia/imagenes/2020/03/31/15856684500079.jpg"
    let photo4 = "https://okdiario.com/img/2019/04/02/fernando-alonso-presenciando-el-gp-de-bahreim-de-formula-1-el-pasado-fin-de-semana-afp-655x368.gif"
    let photo8 = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7OjrYPKvO4oXb-C9m1jXjqduSYo8nI5py-GQz7-_tsx7DFr7Z&s"
    let photo9 = "https://cflvdg.avoz.es/default/2019/02/15/00121550220541987906322/Foto/eup_20181023_160316864.jpg"

    var arrayPhoto1Url = [String()]
    var arrayPhotosURL = [String()]
    var arrayPhotosURL2 = [String()]

    override func viewDidLoad() {
        super.viewDidLoad()

        arrayPhoto1Url = [photo0]
        arrayPhotosURL = [photo0, photo1, photo2, photo3]
        arrayPhotosURL2 = [photo0, photo1, photo2, photo3, photo4, photo5, photo6, photo7, photo8, photo9]

        imageViewer1.setupCBKImageViewer(image: imageTest ?? UIImage())
        imageViewer2.setupCBKImageViewerFromURL(image: arrayPhoto1Url, height: CGFloat(200), width: CGFloat(200))
        imageViewer3.setupCBKImageViewerFromURL(image: arrayPhotosURL, height: CGFloat(200), width: CGFloat(315))
        imageViewer4.setupCBKImageViewerFromURL(image: arrayPhotosURL2, height: CGFloat(170), width: CGFloat(200))
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
