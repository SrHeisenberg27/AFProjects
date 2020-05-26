//
//  CarrouselSectionBoxCollectionViewCell.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 11/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

public class CarrouselSectionBoxCollectionViewCell: UICollectionViewCell {

    @IBOutlet public weak var contentViewCell: UIView!
    @IBOutlet public weak var shadow: UIView!
    @IBOutlet public weak var innerView: UIView!

    public override func awakeFromNib() {
        super.awakeFromNib()

        self.contentViewCell.layer.cornerRadius = 8.0
        self.innerView.layer.cornerRadius = 8.0
        self.shadow.layer.cornerRadius = 8.0
        self.layer.cornerRadius = 8.0
    }

    class var reuserIdentifier: String {
        return "CarrouselSectionBoxCollectionViewCellID"
    }

    class var nibName: String {
        return "CarrouselSectionBoxCollectionViewCell"
    }

    public func configureCell(view: UIView) {

//        self.frame = CGRect(x: min(UIScreen.main.bounds.origin.x, view.frame.origin.x), y: min(UIScreen.main.bounds.origin.y, view.frame.origin.y), width: min(UIScreen.main.bounds.width, view.frame.width), height: min(UIScreen.main.bounds.height, view.frame.height))


        self.contentViewCell.layer.cornerRadius = 18.0
        self.innerView.layer.cornerRadius = 18.0
        self.shadow.layer.cornerRadius = 0.0
        self.layer.cornerRadius = 12.0

        self.innerView.addSubview(view)
    }
}
