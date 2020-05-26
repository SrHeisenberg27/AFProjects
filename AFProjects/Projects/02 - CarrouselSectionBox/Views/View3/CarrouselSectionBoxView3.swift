//
//  CarrouselSectionBoxView3.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 12/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

@IBDesignable public class CarrouselSectionBoxView3: UIView {

    @IBOutlet public weak var contentView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var ibanLabel: UILabel!
    @IBOutlet public weak var otherLabel: UILabel!

    // MARK: - Load from xib
    open override func awakeFromNib() {
        super.awakeFromNib()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        commonInit()
    }

    fileprivate func xibSetup() {
        contentView = loadViewFromNib()
        self.frame = loadViewFromNib().frame
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
    }

    fileprivate func commonInit() {
        contentView.accessibilityTraits = UIAccessibilityTraits.allowsDirectInteraction
    }

    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CarrouselSectionBoxView3", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view ?? UIView()
    }

    public func setupView(title: String, iban: String, otherLabel: String) {
        self.titleLabel.text = title
        self.ibanLabel.text = iban
        self.otherLabel.text = otherLabel

        self.setLabels()
    }

    public func setLabels() {
        self.titleLabel.font = UIFont(name: "Avenir", size: 22.0)
        self.ibanLabel.font = UIFont(name: "Avenir", size: 20.0)
        self.otherLabel.font = UIFont(name: "Avenir", size: 20.0)
    }
}
