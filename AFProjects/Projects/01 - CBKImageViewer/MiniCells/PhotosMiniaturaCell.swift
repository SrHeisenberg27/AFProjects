////
//  PhotosMiniaturaCell.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 21/04/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

class PhotosMiniaturaCell: UICollectionViewCell {

    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var borderBlack: UIView!
    @IBOutlet public weak var borderWhite: UIView!

    public var selectedCell: Bool = false
    public var auxImage = UIImage()
    public var downloadead: Bool = false

    public var imageViewer: CBKImageViewer?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    class var reuserIdentifier: String {
        return "PhotosMiniaturaCellID"
    }

    class var nibName: String {
        return "PhotosMiniaturaCell"
    }

    func configureCell(image: String, imageViewer: CBKImageViewer) {
        self.imageViewer = imageViewer
        guard let auxIndexPath = imageViewer.auxIndexPath else { return }

        if !downloadead {
            self.imageView.downloadAnyIMG(image)
        } else {
            self.imageView.image = imageViewer.arrayDownloadedImages[auxIndexPath]
        }
    }

    func configureCe(image: String) {
        self.imageView.image = UIImage(named: image)
    }

    public func selectCell() {
        borderBlack.backgroundColor = .black
        borderWhite.backgroundColor = .white
    }

    public func unselectCell() {
        borderBlack.backgroundColor = .clear
        borderWhite.backgroundColor = .clear
    }

    func downloadImageFromServer(image: String, index: Int) {
        if let url = URL(string: image) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                guard
                    let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let dataImg = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async {
                    self.imageViewer?.arrayDownloadedImages[index] = dataImg
                }
            }.resume()
        }
    }
}
