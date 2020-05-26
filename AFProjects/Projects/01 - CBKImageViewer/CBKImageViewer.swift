//
//  CBKImageViewer.swift
//
//
//  Created by Alvaro Ferrandez Gomez on 30/01/2020.
//  Copyright © 2020. All rights reserved.
//

import UIKit

enum TypeImageViewer {
    case typeUIImage
    case typeURL
}

@IBDesignable open class CBKImageViewer: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var subImage1: UIImageView!
    @IBOutlet weak var subImage2: UIImageView!
    @IBOutlet weak var subImage3: UIImageView!
    @IBOutlet weak var mainHeight: NSLayoutConstraint!
    @IBOutlet weak var mainWidth: NSLayoutConstraint!
    @IBOutlet weak var totalHeight: NSLayoutConstraint!
    @IBOutlet weak var totalWidth: NSLayoutConstraint!

    var scrollView = UIScrollView()
    var newImageView = UIImageView()

    let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var collectionViewCell = UICollectionViewCell()
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()

    var view = UIView()
    let backButton = UIButton(type: .custom)

    var widthImage = CGFloat()
    var heightImage = CGFloat()
    var semiHeightScreen = CGFloat()
    var semiWidthScreen = CGFloat()
    var newHeight = CGFloat()
    var newWidth = CGFloat()
    var showOptions: Bool = true

    var arrayImage = [UIImage]()
    var arrayImageURL = [String]()

    let cornerRadius: CGFloat = 8.0

    var currentImage = 0

    let safeArea = UIView()
    let safeArea2 = UIView()
    let safeAreaBottom = UIView()

    var arrayDownloadedImages: [UIImage] = []

    var typeImageViewer: TypeImageViewer?

    var selectedImage: Int = 0
    var auxIndexPath: Int?

    public var eliminateImage: Bool = false

    var fullscreen: Bool = true
    var fullscreen1: Bool = true
    var fullscreen2: Bool = true
    var fullscreen3: Bool = true
    var fullscreenMore: Bool = true
    var fullscreenMultiple: Bool = true

    var multipleScreen = false

    var lastIndexPath = IndexPath()

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
        collectionView.register(UINib(nibName: PhotosMiniaturaCell.nibName, bundle: nil), forCellWithReuseIdentifier: PhotosMiniaturaCell.reuserIdentifier)
    }

    fileprivate func commonInit() {
        contentView.accessibilityTraits = UIAccessibilityTraits.allowsDirectInteraction
    }

    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CBKImageViewer", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view ?? UIView()
    }

    fileprivate func loadCollectionFromNib() -> UICollectionViewCell {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: PhotosMiniaturaCell.nibName, bundle: bundle)
        let collectionCell = nib.instantiate(withOwner: self, options: nil).first as? UICollectionViewCell
        return collectionCell ?? UICollectionViewCell()
    }

    public func setupCBKImageViewer(image: UIImage, titleEliminate: String? = nil, okEliminate: String? = nil, koEliminate: String? = nil, height: CGFloat? = nil, width: CGFloat? = nil) {
        setView(number: 1)
        self.mainImage.image = image
        self.mainImage.contentMode = .scaleAspectFill

        self.mainHeight.constant = height ?? self.mainImage.frame.height
        self.mainWidth.constant = width ?? self.mainImage.frame.width

        self.totalHeight.constant = height ?? self.mainImage.frame.height
        self.totalWidth.constant = width ?? self.mainImage.frame.width

        let imageViewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        mainImage.isUserInteractionEnabled = true
        mainImage.addGestureRecognizer(imageViewTap)

        getDimensions()
        getCorners()
    }

    public func setupCBKImageViewerFromArray(image: [UIImage], titleEliminate: String? = nil, okEliminate: String? = nil, koEliminate: String? = nil, height: CGFloat? = nil, width: CGFloat? = nil) {
        setView(number: image.count)

        self.typeImageViewer = TypeImageViewer.typeUIImage
        self.arrayImage = image
        self.mainImage.image = arrayImage[0]
        self.mainImage.contentMode = .scaleAspectFill

        self.mainHeight.constant = height ?? self.mainImage.frame.height
        self.mainWidth.constant = width ?? self.mainImage.frame.width

        self.totalHeight.constant = height ?? self.mainImage.frame.height
        self.totalWidth.constant = width ?? self.mainImage.frame.width

        if arrayImageURL.count > 3 {
            let imageViewMultiple: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTappedMultiple))
            mainImage.isUserInteractionEnabled = true
            mainImage.addGestureRecognizer(imageViewMultiple)

            self.subImage1.downloadAnyIMG(self.arrayImageURL[1])
            self.subImage2.downloadAnyIMG(self.arrayImageURL[2])
            self.subImage3.downloadAnyIMG(self.arrayImageURL[3])

            subImage1.layer.cornerRadius = self.cornerRadius
            subImage2.layer.cornerRadius = self.cornerRadius
            subImage3.layer.cornerRadius = self.cornerRadius

            self.subImage1.contentMode = .scaleAspectFill
            self.subImage2.contentMode = .scaleAspectFill
            self.subImage3.contentMode = .scaleAspectFill

            self.totalHeight.constant = (height ?? self.mainImage.frame.height) + CGFloat(110)
            self.totalWidth.constant = CGFloat(330)

            let imageViewTap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped1))
            let imageViewTap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped2))
            subImage1.isUserInteractionEnabled = true
            subImage1.addGestureRecognizer(imageViewTap1)
            subImage2.isUserInteractionEnabled = true
            subImage2.addGestureRecognizer(imageViewTap2)
        } else {
            let imageViewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
            mainImage.isUserInteractionEnabled = true
            mainImage.addGestureRecognizer(imageViewTap)
        }

        checkMorePhotos(number: arrayImage.count)

        getDimensions()
        getCorners()
    }

    public func setupCBKImageViewerFromURL(image: [String], titleEliminate: String? = nil, okEliminate: String? = nil, koEliminate: String? = nil, height: CGFloat? = nil, width: CGFloat? = nil) {
        setView(number: image.count)

        self.typeImageViewer = TypeImageViewer.typeURL
        self.arrayImageURL = image
        self.mainImage.downloadAnyIMG(self.arrayImageURL[0])
        self.mainImage.contentMode = .scaleAspectFit

        for _ in image {
            self.arrayDownloadedImages.append(UIImage())
        }

        self.mainHeight.constant = height ?? self.mainImage.frame.height
        self.mainWidth.constant = width ?? self.mainImage.frame.width

        self.totalHeight.constant = height ?? self.mainImage.frame.height
        self.totalWidth.constant = width ?? self.mainImage.frame.width

        if arrayImageURL.count > 3 {
            let imageViewMultiple: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTappedMultiple))
            mainImage.isUserInteractionEnabled = true
            mainImage.addGestureRecognizer(imageViewMultiple)

            self.subImage1.downloadAnyIMG(self.arrayImageURL[1])
            self.subImage2.downloadAnyIMG(self.arrayImageURL[2])
            self.subImage3.downloadAnyIMG(self.arrayImageURL[3])

            subImage1.layer.cornerRadius = self.cornerRadius
            subImage2.layer.cornerRadius = self.cornerRadius
            subImage3.layer.cornerRadius = self.cornerRadius

            self.subImage1.contentMode = .scaleAspectFill
            self.subImage2.contentMode = .scaleAspectFill
            self.subImage3.contentMode = .scaleAspectFill

            self.totalHeight.constant = (height ?? self.mainImage.frame.height) + CGFloat(110)
            self.totalWidth.constant = CGFloat(330)

            let imageViewTap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped1))
            let imageViewTap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped2))
            let imageViewTap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped3))
            subImage1.isUserInteractionEnabled = true
            subImage1.addGestureRecognizer(imageViewTap1)
            subImage2.isUserInteractionEnabled = true
            subImage2.addGestureRecognizer(imageViewTap2)
            subImage3.isUserInteractionEnabled = true
            subImage3.addGestureRecognizer(imageViewTap3)
        } else {
            let imageViewTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
            mainImage.isUserInteractionEnabled = true
            mainImage.addGestureRecognizer(imageViewTap)
        }

        checkMorePhotos(number: arrayImageURL.count)

        getDimensions()
        getCorners()
    }

    func getCorners() {
        contentView.layer.cornerRadius = self.cornerRadius
        mainImage.layer.cornerRadius = self.cornerRadius
    }

    func setView(number: Int) {
        switch number {
        case 1:
            self.subView.removeFromSuperview()
        default:
            break
        }
    }

    func checkMorePhotos(number: Int) {
        guard let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        flowLayout.estimatedItemSize = CGSize(width: 84, height: 84)
        flowLayout.minimumLineSpacing = 4
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        flowLayout.collectionView?.backgroundColor = .clear
        flowLayout.scrollDirection = .horizontal

        if number > 4 {
            let layerView = UIView()
            layerView.frame = subImage3.frame
            layerView.backgroundColor = UIColor.gray
            layerView.alpha = 0.5

            self.subView.addSubview(layerView)

            let labelNumber = UILabel()
            labelNumber.frame = subImage3.frame
            labelNumber.textAlignment = .center
            labelNumber.text = "+\(number - 4)"
            labelNumber.textColor = UIColor.white
            labelNumber.font = UIFont(name: "Helvetica-Bold", size: 23.0)
            self.subView.addSubview(labelNumber)

            let imageViewTapMore: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTappedMore))
            layerView.isUserInteractionEnabled = true
            layerView.addGestureRecognizer(imageViewTapMore)

            layerView.layer.cornerRadius = self.cornerRadius
        }

        if number == 4 {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)
        }
    }

    @objc func respondToSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        switch typeImageViewer {
        case .typeUIImage:
            if arrayImage.count != 1 {
                if let swipeGesture = sender as? UISwipeGestureRecognizer {
                    switch swipeGesture.direction {
                    case UISwipeGestureRecognizer.Direction.left:
                        if currentImage == arrayImage.count - 1 {
                            break
                        } else {
                            currentImage += 1
                        }
                        newImageView.image = arrayImage[currentImage]

                    case UISwipeGestureRecognizer.Direction.right:
                        if currentImage == 0 {
                            break
                        } else {
                            currentImage -= 1
                        }
                        newImageView.image = arrayImage[currentImage]
                    default:
                        break
                    }
                }
            }
        case .typeURL:
            if arrayImageURL.count != 1 {
                if let swipeGesture = sender as? UISwipeGestureRecognizer {
                    switch swipeGesture.direction {
                    case UISwipeGestureRecognizer.Direction.left:
                        if currentImage == arrayImageURL.count - 1 {
                            break
                        } else {
                            currentImage += 1
                        }
                        newImageView.downloadAnyIMG(arrayImageURL[currentImage])
                    case UISwipeGestureRecognizer.Direction.right:
                        if currentImage == 0 {
                            break
                        } else {
                            currentImage -= 1
                        }
                        newImageView.downloadAnyIMG(arrayImageURL[currentImage])
                    default:
                        break
                    }
                }
            }
        default:

            break
        }
    }

    fileprivate func getDimensions() {
        semiHeightScreen = UIScreen.main.bounds.midY
        semiWidthScreen = UIScreen.main.bounds.midX

        widthImage = self.mainImage.frame.width
        heightImage = self.mainImage.frame.height

        newHeight = 2 * self.semiWidthScreen / (self.widthImage / self.heightImage)
        newWidth = 2 * semiWidthScreen
    }

    @objc func imageViewTapped() {
        guard UIApplication.shared.keyWindow != nil else { return }
        fullscreen ? inImage() : outImage()
    }

    @objc func imageViewTapped1() {
        guard UIApplication.shared.keyWindow != nil else { return }
        fullscreen1 ? inImage1() : outImage()
    }

    @objc func imageViewTapped2() {
        guard UIApplication.shared.keyWindow != nil else { return }
        fullscreen2 ? inImage2() : outImage()
    }

    @objc func imageViewTapped3() {
        guard UIApplication.shared.keyWindow != nil else { return }
        fullscreen3 ? inImage3() : outImage()
    }

    @objc func imageViewTappedMore() {
        guard UIApplication.shared.keyWindow != nil else { return }
        fullscreenMore ? inImageMore() : outImage()
    }

    @objc func imageViewTappedMultiple() {
        guard UIApplication.shared.keyWindow != nil else { return }
        fullscreenMultiple ? inImageMultiple() : outImage()
    }

    func viewWillLayoutSubviews() {
        setZoomScale()
    }

    func setZoomScale() {
        var minZoom = min(self.view.bounds.size.width / newImageView.bounds.size.width, self.view.bounds.size.height / newImageView.bounds.size.height)

        if (minZoom > 1.0) {
            minZoom = 1.0
        }

        scrollView.minimumZoomScale = minZoom
        scrollView.maximumZoomScale = 5 * minZoom
        scrollView.zoomScale = minZoom
    }

    fileprivate func inImage() {
        view.frame = self.window?.frame ?? CGRect()

        newImageView = UIImageView(image: mainImage.image)
        scrollView = UIScrollView(frame: view.bounds)

        newImageView.frame = CGRect(x: 0.0, y: semiHeightScreen - newHeight / 2, width: newWidth, height: newHeight)

        newImageView.alpha = 0.0
        scrollView.alpha = 0.0

        UIView.animate(withDuration: 0.01, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.newImageView.alpha = 1.0

            self.view.backgroundColor = .black
            self.scrollView.alpha = 1.0
            self.scrollView.backgroundColor = .black
            self.scrollView.contentSize = self.newImageView.frame.size
            self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.scrollView.addSubview(self.newImageView)
            self.view.addSubview(self.scrollView)
            self.window?.addSubview(self.view)

            self.scrollView.delegate = self as UIScrollViewDelegate

            self.setZoomScale()
            self.setupGestureRecognizer()
            self.newImageView.contentMode = .scaleAspectFit

            self.createNavBar()
            self.fullscreen = false
            self.currentImage = 0
        }, completion: { _ in
            })
    }

    fileprivate func inImageMultiple() {
        self.collectionView.visibleCells.forEach { selectedCell in
            if let sCell = selectedCell as? PhotosMiniaturaCell {
                sCell.layer.borderWidth = 0
            }
        }

        view.frame = self.window?.frame ?? CGRect()

        newImageView = UIImageView(image: mainImage.image)
        scrollView = UIScrollView(frame: view.bounds)

        newImageView.frame = CGRect(x: 0.0, y: semiHeightScreen - newHeight / 2, width: newWidth, height: newHeight)

        newImageView.alpha = 0.0
        scrollView.alpha = 0.0

        UIView.animate(withDuration: 0.01, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.newImageView.alpha = 1.0

            self.view.backgroundColor = .black
            self.scrollView.alpha = 1.0
            self.scrollView.backgroundColor = .black
            self.scrollView.contentSize = self.newImageView.frame.size
            self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.scrollView.addSubview(self.newImageView)
            self.view.addSubview(self.scrollView)
            self.window?.addSubview(self.view)

            self.scrollView.delegate = self as UIScrollViewDelegate

            self.setZoomScale()
            self.setupGestureRecognizer()
            self.newImageView.contentMode = .scaleAspectFit

            self.createNavBar()
            self.createCollectionView()
            self.fullscreenMultiple = false
            self.currentImage = 0
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentImage, section: 0), at: .centeredHorizontally, animated: true)
        }, completion: { _ in
            })
    }


    fileprivate func inImage1() {
        self.collectionView.visibleCells.forEach { selectedCell in
            if let sCell = selectedCell as? PhotosMiniaturaCell {
                sCell.layer.borderWidth = 0
            }
        }

        view.frame = self.window?.frame ?? CGRect()

        newImageView = UIImageView(image: subImage1.image)
        scrollView = UIScrollView(frame: view.bounds)

        newImageView.frame = CGRect(x: 0.0, y: semiHeightScreen - newHeight / 2, width: newWidth, height: newHeight)

        newImageView.alpha = 0.0
        scrollView.alpha = 0.0

        UIView.animate(withDuration: 0.05, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.newImageView.alpha = 1.0

            self.view.backgroundColor = .black
            self.scrollView.alpha = 1.0
            self.scrollView.backgroundColor = .black
            self.scrollView.contentSize = self.newImageView.frame.size
            self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.scrollView.addSubview(self.newImageView)
            self.view.addSubview(self.scrollView)
            self.window?.addSubview(self.view)

            self.scrollView.delegate = self as UIScrollViewDelegate

            self.setZoomScale()
            self.setupGestureRecognizer()
            self.newImageView.contentMode = .scaleAspectFit

            self.createNavBar()
            self.fullscreen1 = false
            self.createCollectionView()
            self.currentImage = 1
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentImage, section: 0), at: .centeredHorizontally, animated: true)
        }, completion: { _ in
            })
    }

    fileprivate func inImage2() {
        self.collectionView.visibleCells.forEach { selectedCell in
            if let sCell = selectedCell as? PhotosMiniaturaCell {
                sCell.layer.borderWidth = 0
            }
        }

        view.frame = self.window?.frame ?? CGRect()

        newImageView = UIImageView(image: subImage2.image)
        scrollView = UIScrollView(frame: view.bounds)

        newImageView.frame = CGRect(x: 0.0, y: semiHeightScreen - newHeight / 2, width: newWidth, height: newHeight)

        newImageView.alpha = 0.0
        scrollView.alpha = 0.0

        UIView.animate(withDuration: 0.01, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.newImageView.alpha = 1.0

            self.view.backgroundColor = .black
            self.scrollView.alpha = 1.0
            self.scrollView.backgroundColor = .black
            self.scrollView.contentSize = self.newImageView.frame.size
            self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.scrollView.addSubview(self.newImageView)
            self.view.addSubview(self.scrollView)
            self.window?.addSubview(self.view)

            self.scrollView.delegate = self as UIScrollViewDelegate

            self.setZoomScale()
            self.setupGestureRecognizer()
            self.newImageView.contentMode = .scaleAspectFit

            self.createNavBar()
            self.fullscreen2 = false
            self.createCollectionView()
            self.currentImage = 2
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentImage, section: 0), at: .centeredHorizontally, animated: true)
        }, completion: { _ in
            })
    }

    fileprivate func inImage3() {
        self.collectionView.visibleCells.forEach { selectedCell in
            if let sCell = selectedCell as? PhotosMiniaturaCell {
                sCell.layer.borderWidth = 0
            }
        }

        view.frame = self.window?.frame ?? CGRect()

        newImageView = UIImageView(image: subImage3.image)
        scrollView = UIScrollView(frame: view.bounds)

        newImageView.frame = CGRect(x: 0.0, y: semiHeightScreen - newHeight / 2, width: newWidth, height: newHeight)

        newImageView.alpha = 0.0
        scrollView.alpha = 0.0

        UIView.animate(withDuration: 0.01, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.newImageView.alpha = 1.0

            self.view.backgroundColor = .black
            self.scrollView.alpha = 1.0
            self.scrollView.backgroundColor = .black
            self.scrollView.contentSize = self.newImageView.frame.size
            self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.scrollView.addSubview(self.newImageView)
            self.view.addSubview(self.scrollView)
            self.window?.addSubview(self.view)

            self.scrollView.delegate = self as UIScrollViewDelegate

            self.setZoomScale()
            self.setupGestureRecognizer()
            self.newImageView.contentMode = .scaleAspectFit

            self.createNavBar()
            self.fullscreen3 = false
            self.createCollectionView()
            self.currentImage = 3
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentImage, section: 0), at: .centeredHorizontally, animated: true)
        }, completion: { _ in
            })
    }


    fileprivate func inImageMore() {
        self.collectionView.visibleCells.forEach { selectedCell in
            if let sCell = selectedCell as? PhotosMiniaturaCell {
                sCell.layer.borderWidth = 0
            }
        }

        view.frame = self.window?.frame ?? CGRect()

        newImageView = UIImageView(image: mainImage.image)
        scrollView = UIScrollView(frame: view.bounds)

        newImageView.frame = CGRect(x: 0.0, y: semiHeightScreen - newHeight / 2, width: newWidth, height: newHeight)

        newImageView.alpha = 0.0
        scrollView.alpha = 0.0

        UIView.animate(withDuration: 0.01, delay: 0.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.newImageView.alpha = 1.0

            self.view.backgroundColor = .black
            self.scrollView.alpha = 1.0
            self.scrollView.backgroundColor = .black
            self.scrollView.contentSize = self.newImageView.frame.size
            self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            self.scrollView.addSubview(self.newImageView)
            self.view.addSubview(self.scrollView)
            self.window?.addSubview(self.view)

            self.scrollView.delegate = self as UIScrollViewDelegate

            self.setZoomScale()
            self.setupGestureRecognizer()
            self.newImageView.contentMode = .scaleAspectFit

            self.createNavBar()
            self.fullscreen = false
            self.createCollectionView()
            self.currentImage = 0
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentImage, section: 0), at: .centeredHorizontally, animated: true)
        }, completion: { _ in
            })
    }

    func createNavBar() {
        safeArea.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: UIScreen.main.bounds.width, height: CGFloat(96))
        safeArea2.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: UIScreen.main.bounds.width, height: CGFloat(63))
        safeArea.backgroundColor = .black
        safeArea2.backgroundColor = .black

        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 66, width: self.view.frame.size.width, height: 30))
        navBar.backgroundColor = UIColor.black
        navBar.tintColor = UIColor.clear
        navBar.barTintColor = UIColor.clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = false
        navBar.delegate = self as? UINavigationBarDelegate

        backButton.setTitle("S", for: .normal)
        backButton.frame = CGRect(x: 15, y: 66, width: 22, height: 20)
        backButton.titleLabel?.font = UIFont(name: "caixabank", size: 20.0)
        backButton.addTarget(self, action: #selector(self.dismissFullscreenImage), for: .touchUpInside)
        backButton.isHidden = false
        backButton.alpha = 1
        backButton.backgroundColor = .clear

        self.view.addSubview(self.safeArea)
        self.view.addSubview(self.safeArea2)
        self.view.addSubview(self.backButton)
    }

    func createCollectionView() {
        collectionView.reloadData()

        collectionView.delegate = self as UICollectionViewDelegate
        collectionView.dataSource = self as UICollectionViewDataSource

        collectionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 120, width: UIScreen.main.bounds.width, height: 84)
        safeAreaBottom.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 120, width: UIScreen.main.bounds.width, height: 120)
        safeAreaBottom.backgroundColor = .black

        self.view.addSubview(safeAreaBottom)
        self.view.addSubview(collectionView)

        self.multipleScreen = true
    }

    public func outImage() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.newImageView.alpha = 0.0
            self.scrollView.alpha = 0.0
            self.newImageView.backgroundColor = .clear
            self.view.backgroundColor = .clear
            self.scrollView.backgroundColor = .clear
            self.newImageView.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }, completion: { _ in
                self.collectionView.removeFromSuperview()

                for view in self.view.subviews {
                    view.removeFromSuperview()
                }

                self.window?.removeFromSuperview()
                self.view.removeFromSuperview()
                self.fullscreen = true
                self.fullscreen1 = true
                self.fullscreen2 = true
                self.fullscreen3 = true
                self.fullscreenMore = true
                self.fullscreenMultiple = true
                self.multipleScreen = false
            })
    }

    @objc func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        self.outImage()
        self.collectionView.reset()
    }

    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))

        singleTap.numberOfTapsRequired = 1
        doubleTap.numberOfTapsRequired = 2
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left

        scrollView.addGestureRecognizer(singleTap)
        scrollView.addGestureRecognizer(doubleTap)
        scrollView.addGestureRecognizer(swipeRight)
        scrollView.addGestureRecognizer(swipeLeft)
    }

    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        hud()
    }

    func hud() {
        if self.showOptions {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.backButton.isHidden = true
                self.collectionView.isHidden = true

                self.safeArea.alpha = 0.0
                self.safeAreaBottom.alpha = 0.0
            }, completion: { _ in
                    self.showOptions = false
                })
        } else {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.backButton.isHidden = false
                self.collectionView.isHidden = false

                self.safeArea.alpha = 1.0
                self.safeAreaBottom.alpha = 1.0
            }, completion: { _ in
                    self.showOptions = true
                })
        }
    }

    func hideHUD() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.backButton.isHidden = true
            self.collectionView.isHidden = true

            self.safeArea.alpha = 0.0
            self.safeAreaBottom.alpha = 0.0
        }, completion: { _ in
            })
    }

    @objc func handleDoubleTap(_ recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
}

extension CBKImageViewer: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.newImageView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if self.showOptions {
            self.hideHUD()
        }
        let boundsSize = scrollView.bounds.size
        var frameToCenter = newImageView.frame

        let widthDiff = boundsSize.width - frameToCenter.size.width
        let heightDiff = boundsSize.height - frameToCenter.size.height
        frameToCenter.origin.x = (widthDiff > 0) ? widthDiff / 2 : 0
        frameToCenter.origin.y = (heightDiff > 0) ? heightDiff / 2 : 0

        newImageView.frame = frameToCenter
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.showOptions = false
    }
}

extension UIImageView {
    func downloadAnyIMG(_ urlImage: String) {
        if let url = URL(string: urlImage) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                guard
                    let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let dataImg = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async {
                    self.image = dataImg
                }
            }.resume()
        }
    }
}

extension CBKImageViewer: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImageURL.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosMiniaturaCell.reuserIdentifier, for: indexPath) as? PhotosMiniaturaCell {
            self.auxIndexPath = indexPath.row
            let photo = arrayImageURL[indexPath.row]
            cell.configureCell(image: photo, imageViewer: self)
            cell.unselectCell()

            if currentImage == indexPath.row {
                cell.selectCell()
            }

            if !cell.downloadead {
                cell.downloadImageFromServer(image: photo, index: indexPath.row)
                cell.downloadead = true
            }

            cell.imageView.contentMode = .scaleAspectFill

            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as? PhotosMiniaturaCell) != nil {
            self.scrollView.setZoomScale(self.scrollView.minimumZoomScale, animated: false)
            self.showOptions = false
            hud()
            newImageView.image = arrayDownloadedImages[indexPath.row]
            currentImage = indexPath.row
            collectionView.reloadData()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PhotosMiniaturaCell {
            cell.unselectCell()
        }
    }
}

extension CBKImageViewer: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: PhotosMiniaturaCell = Bundle.main.loadNibNamed(PhotosMiniaturaCell.nibName, owner: self, options: nil)?.first as? PhotosMiniaturaCell else { return CGSize.zero }
        if !cell.downloadead {
            cell.configureCell(image: arrayImageURL[indexPath.row], imageViewer: self)
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
        }
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 90)
    }
}
