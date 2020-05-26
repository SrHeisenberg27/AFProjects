//
//  PagesController.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/04/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

@IBDesignable class PagesController: UIView {
    static let PagesController_NIB = "PagesController"

    @IBOutlet var contentView: UIView!
    @IBOutlet var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
        self.contentView.backgroundColor = UIColor.black
        self.imageView.backgroundColor = UIColor.black
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }

    convenience init(image: UIImage) {
        self.init()
        self.imageView.image = image
    }

    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed(PagesController.PagesController_NIB, owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}
