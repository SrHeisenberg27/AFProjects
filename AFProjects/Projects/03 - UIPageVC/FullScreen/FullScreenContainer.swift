//
//  FullScreenContainer.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 22/03/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

open class FullScreenContainer: UIViewController {

    @IBOutlet public weak var pageControllerContainer: UIView!

    public var imageUIImage: UIImage?
    public var arrayUIImage: [UIImage]?
    public var imageURL: String?
    public var arrayImageURL: [String]?
    public var arrayDownloadedImages: [UIImage] = []

    public var currentIndex: Int?
    public var closeBool: Bool?

    public var delegateCBK: CBKImageViewerDelegate?

    var typeImageViewer: TypeOfImageViewer?

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControllerContainer.backgroundColor = UIColor.black
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FullScreenViewController {
            let vc = segue.destination as? FullScreenViewController
            vc?.typeImageViewer = self.typeImageViewer
            vc?.imageUIImage = self.imageUIImage
            vc?.arrayUIImage = self.arrayUIImage
            vc?.arrayImageURL = self.arrayImageURL
            vc?.arrayDownloadedImages = self.arrayDownloadedImages
            vc?.currentIndex = self.currentIndex ?? -1
            vc?.closeBool = self.closeBool ?? false
            vc?.delegateCBK = self.delegateCBK
        }
    }
}
