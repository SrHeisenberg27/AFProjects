//
//  ImageViewerExternalVC.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/04/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit
//import MCAIUCOMPS
//import Kingfisher
//import Commons_APPCBK

class ImageViewerExternalVC: UIViewController {

    @IBOutlet public weak var scrollView: UIScrollView!
    @IBOutlet public weak var viewS: UIView!
    @IBOutlet public weak var imageViewer1: ImageViewerComponent!
    @IBOutlet public weak var imageViewer2: ImageViewerComponent!
    @IBOutlet public weak var imageViewer3: ImageViewerComponent!
    @IBOutlet public weak var imageViewer4: ImageViewerComponent!
    @IBOutlet public weak var imageViewer5: ImageViewerComponent!
    @IBOutlet public weak var imageViewer6: ImageViewerComponent!
    @IBOutlet public weak var imageViewer7: ImageViewerComponent!
    @IBOutlet public weak var imageViewer8: ImageViewerComponent!
    @IBOutlet public weak var imageViewer9: ImageViewerComponent!
    @IBOutlet public weak var imageViewer10: ImageViewerComponent!
    @IBOutlet public weak var imageViewer11: ImageViewerComponent!

    let photo0 = "https://int.loc1.caixabank.es/imatge/renting/imagen0_925x480.jpg"
    let photo1 = "https://int.loc1.caixabank.es/imatge/renting/imagen1_925x480.jpg"
    let photo2 = "https://int.loc1.caixabank.es/imatge/renting/imagen2_925x480.jpg"
    let photo3 = "https://int.loc1.caixabank.es/imatge/renting/imagen3_925x480.jpg"
    let photo4 = "https://int.loc1.caixabank.es/imatge/renting/imagen4_925x480.jpg"
    let photo5 = "https://int.loc1.caixabank.es/imatge/renting/imagen0_925x480.jpg"
    let photo6 = "https://int.loc1.caixabank.es/imatge/renting/imagen1_925x480.jpg"
    let photo7 = "https://int.loc1.caixabank.es/imatge/renting/imagen2_925x480.jpg"
    let photo8 = "https://int.loc1.caixabank.es/imatge/renting/imagen3_925x480.jpg"
    let photo9 = "https://int.loc1.caixabank.es/imatge/renting/imagen4_925x480.jpg"

    public var testUIImage: UIImage?
    public var arraytestUIImage: [UIImage]?
    public var url: String?
    public var arrayURLOnly1: [String]?
    public var arrayURLOnly3: [String]?
    public var arrayURLOnly4: [String]?
    public var arrayPhotosURL: [String]?
    public var arrayPhotosURLExt: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()

        testUIImage = UIImage(named: "rr114") ?? UIImage()
        arraytestUIImage = [UIImage(named: "rr11") ?? UIImage(), UIImage(named: "rr112") ?? UIImage(), UIImage(named: "rr113") ?? UIImage(), UIImage(named: "rr114") ?? UIImage(), UIImage(named: "rr114") ?? UIImage()]
        url = photo0
        arrayURLOnly1 = [photo0]
        arrayURLOnly3 = [photo0, photo1, photo2]
        arrayURLOnly4 = [photo0, photo1, photo2, photo3]
        arrayPhotosURL = [photo0, photo1, photo2, photo3, photo4]
        arrayPhotosURLExt = [photo0, photo1, photo2, photo3, photo4, photo5, photo6, photo7, photo8, photo9]

        imageViewer1.setupImageViewerUIImage(image: testUIImage ?? UIImage(), closeButton: true, delegate: self)
        imageViewer2.setupImageViewerArrayUIImage(image: arraytestUIImage ?? [UIImage()], height: CGFloat(280), width: CGFloat(315), closeButton: true, delegate: self)
        imageViewer3.setupImageViewerArrayUIImage(image: arraytestUIImage ?? [UIImage()], height: CGFloat(200), width: CGFloat(200), delegate: self)
        imageViewer4.setupImageViewerComponentFromURL(image: url ?? "", delegate: self)
        imageViewer5.setupImageViewerComponentFromArrayURL(image: arrayURLOnly1 ?? [], delegate: self)
        imageViewer6.setupImageViewerComponentFromArrayURL(image: arrayURLOnly1 ?? [], delegate: self)
        imageViewer7.setupImageViewerComponentFromArrayURL(image: arrayURLOnly3 ?? [], delegate: self)
        imageViewer8.setupImageViewerComponentFromArrayURL(image: arrayURLOnly4 ?? [], delegate: self)
        imageViewer9.setupImageViewerComponentFromArrayURL(image: arrayPhotosURL ?? [], delegate: self)
        imageViewer10.setupImageViewerComponentFromArrayURL(image: arrayPhotosURL ?? [], height: CGFloat(200), width: CGFloat(200), delegate: self)
        imageViewer11.setupImageViewerComponentFromArrayURL(image: arrayPhotosURLExt ?? [], height: CGFloat(150), width: CGFloat(200), closeButton: true, delegate: self)
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageViewerExternalVC: CBKImageViewerDelegate {
    func eliminateImage() {
        print("borrando")
    }
}
