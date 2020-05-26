//
//  PhotoCarrousel.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/04/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

class PhotoCarrousel: UICollectionViewCell {

    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var borderBlack: UIView!
    @IBOutlet public weak var borderWhite: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class var reuserIdentifier: String {
        return "PhotoCarrouselID"
    }

    class var nibName: String {
        return "PhotoCarrousel"
    }

    func configureCell(image: UIImage) {
        self.imageView.image = image
    }

    public func selectCell() {
        borderBlack.backgroundColor = .black
        borderWhite.backgroundColor = .white
    }

    public func unselectCell() {
        borderBlack.backgroundColor = .clear
        borderWhite.backgroundColor = .clear
    }
}
