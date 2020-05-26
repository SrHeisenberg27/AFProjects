//
//  ImageViewerComponent.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/04/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit
//import aarqCore

public enum TypeOfImageViewer {
    case UIImage
    case arrayUIImage
    case url
    case arrayUrl
}

public protocol CBKImageViewerDelegate: class {
    func eliminateImage()
}

public extension CBKImageViewerDelegate {
    func eliminateImage() { }
}

@IBDesignable public class ImageViewerComponent: UIView {

    @IBOutlet public weak var contentView: UIView!
    @IBOutlet public weak var subView: UIView!
    @IBOutlet public weak var mainImage: UIImageView!
    @IBOutlet public weak var subImage1: UIImageView!
    @IBOutlet public weak var subImage2: UIImageView!
    @IBOutlet public weak var subImage3: UIImageView!
    @IBOutlet public weak var mainHeight: NSLayoutConstraint!
    @IBOutlet public weak var mainWidth: NSLayoutConstraint!
    @IBOutlet public weak var totalHeight: NSLayoutConstraint!
    @IBOutlet public weak var totalWidth: NSLayoutConstraint!
//    @IBOutlet public weak var shadow: CBKViewCornerBorderShadow!

    weak var delegate: CBKImageViewerDelegate?

    public var typeImageViewer: TypeOfImageViewer?

    var view = UIView()
    let backButton = UIButton(type: .custom)
    let closeButton = UIButton(type: .custom)

    var closeBool: Bool = true
    var shadowBool: Bool = true

    public var eliminateImage: Bool = false
    let cornerRadius: CGFloat = 8.0
    var auxHeight = CGFloat()

    public var imageUIImage: UIImage?
    public var arrayUIImage: [UIImage]?
    public var imageURL: String?
    public var arrayImageURL: [String]?
    public var arrayImageURLAux: [String]?
    public var arrayDownloadedImages: [UIImage] = []

    public var imageTapped0: UITapGestureRecognizer?
    public var imageTapped1: UITapGestureRecognizer?
    public var imageTapped2: UITapGestureRecognizer?
    public var imageTapped3: UITapGestureRecognizer?

    public var nextIndex: Int?
    public var currentIndex: Int?
    public var previousIndex: Int?

    public var titleEliminateLit: String = ""
    public var okEliminateLit: String = ""
    public var koEliminateLit: String = ""
//    public var titleEliminateLit: String = ADAMLocalizedString("caixabank_visualizar_imagen_eliminar_pregunta", bundle: Bundle(for: MCAIUCOMPS.self))
//    public var okEliminateLit: String = ADAMLocalizedString("caixabank_visualizar_imagen_eliminar", bundle: Bundle(for: MCAIUCOMPS.self))
//    public var koEliminateLit: String = ADAMLocalizedString("caixabank_visualizar_imagem_eliminar_no", bundle: Bundle(for: MCAIUCOMPS.self))

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
    }

    fileprivate func commonInit() {
        contentView.accessibilityTraits = UIAccessibilityTraits.allowsDirectInteraction
    }

    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ImageViewerComponent", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view ?? UIView()
    }

    // MARK: - Setups
    public func setupImageViewerUIImage(image: UIImage, titleEliminate: String? = nil, okEliminate: String? = nil, koEliminate: String? = nil, height: CGFloat? = nil, width: CGFloat? = nil, contentMode: UIView.ContentMode? = nil, closeButton: Bool? = false, delegate: CBKImageViewerDelegate, shadow: Bool? = true) {
        self.delegate = delegate
        self.typeImageViewer = TypeOfImageViewer.UIImage
        self.closeBool = closeButton ?? false
        self.shadowBool = shadow ?? true
        self.setView(number: 1)
        self.imageUIImage = image
        self.mainImage.image = imageUIImage
        self.mainImage.contentMode = contentMode ?? .scaleAspectFill

        self.mainHeight.constant = height ?? self.mainImage.frame.height
        self.mainWidth.constant = width ?? self.mainImage.frame.width

        self.totalHeight.constant = height ?? self.mainImage.frame.height
        self.totalWidth.constant = width ?? self.mainImage.frame.width

        self.auxHeight = height ?? CGFloat(0)

        if titleEliminate != nil {
            self.titleEliminateLit = titleEliminate ?? ""
        }

        if okEliminate != nil {
            self.okEliminateLit = okEliminate ?? ""
        }

        if koEliminate != nil {
            self.koEliminateLit = koEliminate ?? ""
        }

        self.getCorners()
        self.addGestures(number: 1)
    }

    public func setupImageViewerArrayUIImage(image: [UIImage], titleEliminate: String? = nil, okEliminate: String? = nil, koEliminate: String? = nil, height: CGFloat? = nil, width: CGFloat? = nil, contentMode: UIView.ContentMode? = nil, closeButton: Bool? = false, delegate: CBKImageViewerDelegate, shadow: Bool? = true) {
        self.delegate = delegate
        self.typeImageViewer = TypeOfImageViewer.arrayUIImage
        self.closeBool = closeButton ?? false
        self.shadowBool = shadow ?? true
        self.arrayUIImage = image
        self.setView(number: arrayUIImage?.count ?? -1)
        self.mainImage.image = arrayUIImage?[0]
        self.mainImage.contentMode = contentMode ?? .scaleAspectFill

        self.mainHeight.constant = height ?? self.mainImage.frame.height
        self.mainWidth.constant = width ?? self.mainImage.frame.width

        self.totalHeight.constant = (height ?? self.mainImage.frame.height) + CGFloat(110)
        self.totalWidth.constant = CGFloat(330)

        self.auxHeight = height ?? CGFloat(0)

        if titleEliminate != nil {
            self.titleEliminateLit = titleEliminate ?? ""
        }

        if okEliminate != nil {
            self.okEliminateLit = okEliminate ?? ""
        }

        if koEliminate != nil {
            self.koEliminateLit = koEliminate ?? ""
        }


        self.getCorners()
        self.setupComplexView(number: arrayUIImage?.count ?? -1)
        self.addGestures(number: arrayUIImage?.count ?? -1)
    }

    public func setupImageViewerComponentFromURL(image: String, titleEliminate: String? = nil, okEliminate: String? = nil, koEliminate: String? = nil, height: CGFloat? = nil, width: CGFloat? = nil, contentMode: UIView.ContentMode? = nil, closeButton: Bool? = false, delegate: CBKImageViewerDelegate, shadow: Bool? = true) {
        self.delegate = delegate
        self.typeImageViewer = TypeOfImageViewer.url
        self.closeBool = closeButton ?? false
        self.shadowBool = shadow ?? true
        self.setView(number: 1)
        self.imageURL = image

        self.arrayDownloadedImages.append(UIImage())
        self.downloadImageFromServer(image: self.imageURL ?? "", index: 0)

        self.mainImage.downloadAnyIMG(self.imageURL ?? "")
        self.mainImage.contentMode = contentMode ?? .scaleAspectFit

        self.mainHeight.constant = height ?? self.mainImage.frame.height
        self.mainWidth.constant = width ?? self.mainImage.frame.width

        self.auxHeight = height ?? CGFloat(0)

        self.totalHeight.constant = height ?? self.mainImage.frame.height
        self.totalWidth.constant = width ?? self.mainImage.frame.width

        if titleEliminate != nil {
            self.titleEliminateLit = titleEliminate ?? ""
        }

        if okEliminate != nil {
            self.okEliminateLit = okEliminate ?? ""
        }

        if koEliminate != nil {
            self.koEliminateLit = koEliminate ?? ""
        }


        self.getCorners()
        self.addGestures(number: 1)
    }

    public func setupImageViewerComponentFromArrayURL(image: [String], titleEliminate: String? = nil, okEliminate: String? = nil, koEliminate: String? = nil, height: CGFloat? = nil, width: CGFloat? = nil, contentMode: UIView.ContentMode? = nil, closeButton: Bool? = false, delegate: CBKImageViewerDelegate, shadow: Bool? = true) {
        self.delegate = delegate
        self.typeImageViewer = TypeOfImageViewer.arrayUrl
        self.closeBool = closeButton ?? false
        self.shadowBool = shadow ?? true

        if image.count < 4 {
            self.arrayImageURL = [image[0]]
            if let arrayImageURL = arrayImageURL {
                for _ in arrayImageURL {
                    self.arrayDownloadedImages.append(UIImage())
                }

                for (index, url) in arrayImageURL.enumerated() {
                    self.downloadImageFromServer(image: url, index: index)
                }
            }

            self.setView(number: arrayImageURL?.count ?? -1)

            self.mainImage.downloadAnyIMG(self.arrayImageURL?[0] ?? "")
            self.mainImage.contentMode = contentMode ?? .scaleAspectFit

            self.mainHeight.constant = height ?? self.mainImage.frame.height
            self.mainWidth.constant = width ?? self.mainImage.frame.width

            self.auxHeight = height ?? CGFloat(0)

            self.totalWidth.constant = CGFloat(330)
            if image.count > 3 {
                self.totalHeight.constant = (height ?? self.mainImage.frame.height) + CGFloat(110)
            } else {
                self.totalHeight.constant = height ?? self.mainImage.frame.height
            }

            if titleEliminate != nil {
                self.titleEliminateLit = titleEliminate ?? ""
            }

            if okEliminate != nil {
                self.okEliminateLit = okEliminate ?? ""
            }

            if koEliminate != nil {
                self.koEliminateLit = koEliminate ?? ""
            }

            self.getCorners()
            self.addGestures(number: arrayImageURL?.count ?? -1)
        } else {
            self.arrayImageURL = image

            for _ in image {
                self.arrayDownloadedImages.append(UIImage())
            }

            for (index, url) in image.enumerated() {
                self.downloadImageFromServer(image: url, index: index)
            }

            self.setView(number: arrayImageURL?.count ?? -1)

            self.mainImage.downloadAnyIMG(self.arrayImageURL?[0] ?? "")
            self.mainImage.contentMode = contentMode ?? .scaleAspectFit

            self.mainHeight.constant = height ?? self.mainImage.frame.height
            self.mainWidth.constant = width ?? self.mainImage.frame.width

            self.auxHeight = height ?? CGFloat(0)

            self.totalWidth.constant = CGFloat(330)
            if image.count > 3 {
                self.totalHeight.constant = (height ?? self.mainImage.frame.height) + CGFloat(110)
            } else {
                self.totalHeight.constant = height ?? self.mainImage.frame.height
            }

            if titleEliminate != nil {
                self.titleEliminateLit = titleEliminate ?? ""
            }

            if okEliminate != nil {
                self.okEliminateLit = okEliminate ?? ""
            }

            if koEliminate != nil {
                self.koEliminateLit = koEliminate ?? ""
            }

            self.getCorners()
            self.addGestures(number: arrayImageURL?.count ?? -1)
        }
    }

    func addGestures(number: Int) {
        self.imageTapped0 = UITapGestureRecognizer(target: self, action: #selector(imageTappedFunction(sender:)))
        self.imageTapped1 = UITapGestureRecognizer(target: self, action: #selector(imageTappedFunction(sender:)))
        self.imageTapped2 = UITapGestureRecognizer(target: self, action: #selector(imageTappedFunction(sender:)))
        self.imageTapped3 = UITapGestureRecognizer(target: self, action: #selector(imageTappedFunction(sender:)))

        if number > 3 {
            self.subView.isUserInteractionEnabled = true
            self.subImage1.isUserInteractionEnabled = true
            self.subImage2.isUserInteractionEnabled = true
            self.subImage3.isUserInteractionEnabled = true

            self.subImage1.addGestureRecognizer(imageTapped1 ?? UITapGestureRecognizer())
            self.subImage2.addGestureRecognizer(imageTapped2 ?? UITapGestureRecognizer())
            self.subImage3.addGestureRecognizer(imageTapped3 ?? UITapGestureRecognizer())

            self.subImage1.tag = 1
            self.subImage2.tag = 2
            self.subImage3.tag = 3
        }

        self.mainImage.tag = 0

        self.mainImage.isUserInteractionEnabled = true
        self.mainImage.addGestureRecognizer(imageTapped0 ?? UITapGestureRecognizer())
    }

    func setupComplexView(number: Int) {
        if number > 3 {
            if self.imageUIImage != nil || self.arrayUIImage != nil {
                self.subImage1.image = self.arrayUIImage?[1]
                self.subImage2.image = self.arrayUIImage?[2]
                self.subImage3.image = self.arrayUIImage?[3]
            } else {
                self.subImage1.image = self.arrayDownloadedImages[1]
                self.subImage2.image = self.arrayDownloadedImages[2]
                self.subImage3.image = self.arrayDownloadedImages[3]
            }

            self.subImage1.contentMode = .scaleAspectFill
            self.subImage2.contentMode = .scaleAspectFill
            self.subImage3.contentMode = .scaleAspectFill

            self.subImage1.layer.cornerRadius = self.cornerRadius
            self.subImage2.layer.cornerRadius = self.cornerRadius
            self.subImage3.layer.cornerRadius = self.cornerRadius

            self.checkMorePhotosLayer(number: number)
        }
    }

    func checkMorePhotosLayer (number: Int) {
        let imageTapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTappedFunction))

        if number > 4 {
            let layerView = UIView()
            layerView.frame = self.subImage3.frame
            layerView.backgroundColor = UIColor.gray
            layerView.alpha = 0.5

            self.subView.addSubview(layerView)

            let labelNumber = UILabel()
            labelNumber.frame = self.subImage3.frame
            labelNumber.textAlignment = .center
            labelNumber.text = "+\(number - 3)"
            labelNumber.textColor = UIColor.white
            labelNumber.font = UIFont(name: "Helvetica-Bold", size: 23.0)
            self.subView.addSubview(labelNumber)

            layerView.isUserInteractionEnabled = true
            layerView.addGestureRecognizer(imageTapped)

            layerView.layer.cornerRadius = self.cornerRadius
        }
    }

    func getCorners() {
        switch self.mainImage.contentMode {
        case .scaleAspectFit:
            self.mainImage.roundCornersForAspectFit(radius: self.cornerRadius)
        default:
            self.contentView.layer.cornerRadius = self.cornerRadius
            self.mainImage.layer.cornerRadius = self.cornerRadius
        }
    }

    func setView(number: Int) {
        switch number {
        case 1, 2, 3:
            self.subView.removeFromSuperview()
        default:
            break
        }
    }

    @objc func imageTappedFunction(sender: UITapGestureRecognizer) {
        guard var topVC = UIApplication.shared.keyWindow?.rootViewController else { return }
        while((topVC.presentedViewController) != nil) {
            topVC = topVC.presentedViewController ?? UIViewController()
        }
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FullScreenContainer") as? FullScreenContainer else { return }

        self.currentIndex = sender.view?.tag ?? -1

        vc.delegateCBK = self.delegate
        vc.typeImageViewer = self.typeImageViewer
        vc.modalPresentationStyle = .fullScreen

        switch self.typeImageViewer {
        case .UIImage:
            vc.imageUIImage = self.imageUIImage
        case .arrayUIImage:
            vc.arrayUIImage = self.arrayUIImage
        case .url:
            vc.imageURL = self.imageURL
            vc.arrayDownloadedImages = self.arrayDownloadedImages
        case .arrayUrl:
            vc.arrayDownloadedImages = self.arrayDownloadedImages
        default:
            break
        }
        vc.currentIndex = self.currentIndex
        vc.closeBool = self.closeBool
        topVC.present(vc, animated: false, completion: nil)
    }

    public func downloadImageFromServer(image: String, index: Int) {
        DispatchQueue(label: "concurrent", qos: .userInteractive, attributes: .concurrent).async {
            let downloadGroup = DispatchGroup()

            downloadGroup.enter()
            if let url = URL(string: image) {
                URLSession.shared.dataTask(with: url) {
                    (data, response, error) in
                    guard
                        let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let dataImg = UIImage(data: data)
                        else { return }

                    self.arrayDownloadedImages[index] = dataImg
                    downloadGroup.leave()
                    
                    downloadGroup.wait()

                    DispatchQueue.main.async {
                        if index == (self.arrayImageURL?.count ?? -1) - 1 {
                            self.setupComplexView(number: self.arrayDownloadedImages.count)
                        }
                    }
                }.resume()
            }
        }
    }
}

extension UIImageView {
    func roundCornersForAspectFit(radius: CGFloat) {
        if let image = self.image {
            let boundsScale = self.bounds.size.width / self.bounds.size.height
            let imageScale = image.size.width / image.size.height

            var drawingRect: CGRect = self.bounds

            if boundsScale > imageScale {
                drawingRect.size.width = drawingRect.size.height * imageScale
                drawingRect.origin.x = (self.bounds.size.width - drawingRect.size.width) / 2
            } else {
                drawingRect.size.height = drawingRect.size.width / imageScale
                drawingRect.origin.y = (self.bounds.size.height - drawingRect.size.height) / 2
            }
            let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}
