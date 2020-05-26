//
//  CarrouselSectionBoxComponent.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 11/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

@IBDesignable public class CarrouselSectionBoxComponent: UIView {

    @IBOutlet public weak var contentView: UIView!
    @IBOutlet public weak var backgroundBlue: UIView!
    @IBOutlet public weak var collectionViewCarrousel: UICollectionView!
    @IBOutlet public weak var heightCollectionView: NSLayoutConstraint!
    @IBOutlet public weak var totalHeight: NSLayoutConstraint!
    @IBOutlet public weak var blueHeight: NSLayoutConstraint!

    public var innerViews: [UIView]?
    public var collectionViewCell = UICollectionViewCell()
    public let layout: CarrouselSectionBoxFlowlayout = CarrouselSectionBoxFlowlayout.init()
    public var execClickButton: [(() -> Void)?]?

    public var heightCell: CGFloat = CGFloat(0)
    public let shadowHeight: CGFloat = CGFloat(3)
    public var currentPage: Int = 0
    public var totalPages: Int = 0
    public var literal = "[X] de [Y]"

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
        contentView.frame = bounds
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)

        collectionViewCell = loadCollectionFromNib()
        collectionViewCarrousel.register(UINib(nibName: CarrouselSectionBoxCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: CarrouselSectionBoxCollectionViewCell.reuserIdentifier)

        self.collectionViewCarrousel.collectionViewLayout = self.layout

        collectionViewCarrousel.delegate = self
        collectionViewCarrousel.dataSource = self
    }

    fileprivate func commonInit() {
        contentView.accessibilityTraits = UIAccessibilityTraits.allowsDirectInteraction
    }

    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CarrouselSectionBoxComponent", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view ?? UIView()
    }

    public func loadCollectionFromNib() -> UICollectionViewCell {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: CarrouselSectionBoxCollectionViewCell.nibName, bundle: bundle)
        let collectionCell = nib.instantiate(withOwner: self, options: nil).first as? UICollectionViewCell
        return collectionCell ?? UICollectionViewCell()
    }

    public func createCollectionView() {
        if let layout = self.collectionViewCarrousel.collectionViewLayout as? CarrouselSectionBoxFlowlayout {

            collectionViewCarrousel.showsHorizontalScrollIndicator = false
            collectionViewCarrousel.showsVerticalScrollIndicator = false
            layout.collectionView?.backgroundColor = .clear
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 4

            let cellWidth = CGFloat(305)
            let cellHeight = self.heightCell

            layout.itemSize = CGSize(width: cellWidth, height: cellHeight + CGFloat(10))
            layout.spacingMode = CarrouselSectionBoxFlowlayoutMode.fixed(spacing: 18)
            collectionViewCarrousel.contentInsetAdjustmentBehavior = .never
        }
    }

    // MARK: - Setups
    public func setupCarrouselSectionBox(views: [UIView], actions: [(() -> Void)?]?) {
        self.innerViews = views
        self.heightCell = views[0].frame.height
        self.totalPages = views.count
        self.heightCollectionView.constant = self.heightCell
        self.blueHeight.constant = 0.7 * self.contentView.frame.height
        self.totalHeight.constant = self.heightCell + CGFloat(80)
        self.createCollectionView()
        self.currentPage = 0
        self.execClickButton = actions
    }

    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(view: subview)
            }
        }
        return results
    }
}

extension CarrouselSectionBoxComponent: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let innerViews = innerViews {
            return innerViews.count
        }
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let innerViews = innerViews, let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                CarrouselSectionBoxCollectionViewCell.reuserIdentifier, for: indexPath) as? CarrouselSectionBoxCollectionViewCell {
            var labelAcc = ""
            cell.configureCell(view: innerViews[indexPath.row])

            let labels = getLabelsInView(view: cell.innerView.subviews[0])
            for label in labels {
                labelAcc += ",. " + (label.text ?? "")
            }

            labelAcc = literal.replacingOccurrences(of: "[X]", with: String(self.currentPage + 1)).replacingOccurrences(of: "[Y]", with: String(self.totalPages))

            cell.contentViewCell.isAccessibilityElement = true
            cell.shadow.isAccessibilityElement = false
            cell.innerView.isAccessibilityElement = false

            cell.contentViewCell.accessibilityElementsHidden = false
            cell.shadow.accessibilityElementsHidden = true
            cell.innerView.accessibilityElementsHidden = true

            cell.contentViewCell.accessibilityLabel = labelAcc
            cell.contentViewCell.accessibilityTraits = .button

            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let execClickButton = execClickButton {
            if execClickButton.count > indexPath.row {
                execClickButton[indexPath.row]?()
            }
        }
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let layout = self.collectionViewCarrousel.collectionViewLayout as? CarrouselSectionBoxFlowlayout {
            let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

            var offset = targetContentOffset.pointee
            let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
            let roundedIndex = round(index)

            offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)

            targetContentOffset.pointee = offset
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {

    }
}


