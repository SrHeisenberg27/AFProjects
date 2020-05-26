//
//  FullScreenViewController.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/04/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

open class FullScreenViewController: UIPageViewController, UIPageViewControllerDelegate {

    public var imageScrollView: ZoomController!
    public var items: [UIViewController] = []

    public var imageUIImage: UIImage?
    public var arrayUIImage: [UIImage]?
    public var imageURL: String?
    public var arrayImageURL: [String]?
    public var arrayDownloadedImages: [UIImage] = []

    var delegateCBK: CBKImageViewerDelegate?

    var typeImageViewer: TypeOfImageViewer?

    let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var collectionViewCell = UICollectionViewCell()
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()

    public var nextIndex: Int?
    public var currentIndex: Int?
    public var previousIndex: Int?

    let backButton = UIButton(type: .custom)
    let closeButton = UIButton(type: .custom)

    let safeArea = UIView()
    let safeAreaBottom = UIView()
    public var showHUDBool: Bool = true
    public var closeBool: Bool = true

    var firstTime: Bool = true
    var maxCells: Int = 0

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.createNavBar()
        self.previousIndex = self.currentIndex

        getTypeImageViewer()

        dataSource = self
        delegate = self

        hidePageControl()
        getPages()

        createCollectionView()

        setViewControllers([items[currentIndex ?? 0]], direction: .forward, animated: true, completion: nil)

        collectionViewCell = loadCollectionFromNib()
        collectionView.register(UINib(nibName: PhotoCarrousel.nibName, bundle: nil), forCellWithReuseIdentifier: PhotoCarrousel.reuserIdentifier)

        self.addGesturesToImageScrollView()
    }

    public func loadCollectionFromNib() -> UICollectionViewCell {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: PhotoCarrousel.nibName, bundle: bundle)
        let collectionCell = nib.instantiate(withOwner: self, options: nil).first as? UICollectionViewCell
        return collectionCell ?? UICollectionViewCell()
    }

    public func addGesturesToImageScrollView() {
        let scrollTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollTapped(_:)))
        self.imageScrollView.isUserInteractionEnabled = true
        self.imageScrollView.addGestureRecognizer(scrollTap)
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
    }

    @objc public func scrollTapped(_ recognizer: UITapGestureRecognizer) {
        self.showHUD()
    }

    public func hidePageControl() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [FullScreenViewController.self])
        pageControl.isHidden = true
    }

    public override func viewDidLayoutSubviews() {
        for view in self.view.subviews {
            if view.isKind(of: UIScrollView.self) {
//                view.frame = CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            } else if view.isKind(of: UIPageControl.self) {
                view.backgroundColor = .clear
            }
        }

        createCollectionView()
    }

    public func getTypeImageViewer() {
        if self.imageUIImage != nil {
            self.typeImageViewer = TypeOfImageViewer.UIImage
        }

        if self.arrayUIImage != nil {
            self.typeImageViewer = TypeOfImageViewer.arrayUIImage
        }

        if self.imageURL != nil {
            self.typeImageViewer = TypeOfImageViewer.url
        }

        if self.arrayImageURL != nil {
            self.typeImageViewer = TypeOfImageViewer.arrayUrl
        }
    }

    public func getPages() {
        switch typeImageViewer {
        case .UIImage:
            if let image = imageUIImage {
                let page = createPage(image: image)
                items.append(page)
            }
        case .arrayUIImage:
            if let arrayImages = arrayUIImage {
                for image in arrayImages {
                    let page = createPage(image: image)
                    items.append(page)
                }
            }
        case .url:
            for image in arrayDownloadedImages {
                let page = createPage(image: image)
                items.append(page)
            }
        case .arrayUrl:
            for image in arrayDownloadedImages {
                let page = createPage(image: image)
                items.append(page)
            }
        default:
            break
        }
    }

    public func createPage(image: UIImage) -> UIViewController {
        let scrollTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scrollTapped(_:)))

        let viewController = UIViewController()
        imageScrollView = ZoomController(frame: CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y - (84 / 2), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        viewController.view.addSubview(imageScrollView)

        imageScrollView.set(image: image)

        imageScrollView.isUserInteractionEnabled = true
        imageScrollView.addGestureRecognizer(scrollTap)

        imageScrollView.translatesAutoresizingMaskIntoConstraints = true

        imageScrollView.fullScreenVC = self

        return viewController
    }

    public func createCollectionView() {
        guard let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        var numberUIImage = 0
        var numberURLS = 0

        safeAreaBottom.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 160, width: UIScreen.main.bounds.width, height: 130)
        safeAreaBottom.backgroundColor = .black

        switch typeImageViewer {
        case .arrayUIImage:
            numberUIImage = arrayUIImage?.count ?? -1
        case .arrayUrl:
            numberURLS = arrayDownloadedImages.count
        default:
            break
        }

        if numberUIImage > 3 || numberURLS > 3 {
            flowLayout.estimatedItemSize = CGSize(width: 84, height: 84)
            flowLayout.minimumLineSpacing = 4
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            flowLayout.collectionView?.backgroundColor = .clear
            flowLayout.scrollDirection = .horizontal

            collectionView.delegate = self as UICollectionViewDelegate
            collectionView.dataSource = self as UICollectionViewDataSource

            collectionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 150, width: UIScreen.main.bounds.width, height: 84)

            self.view.addSubview(safeAreaBottom)
            self.view.addSubview(collectionView)

            if firstTime {
                self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex ?? -1, section: 0), at: .centeredHorizontally, animated: true)
                firstTime = false
            }
        }

        if numberUIImage > 3 || numberURLS > 3 {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)
        }
    }

    public func showHUD() {
        if self.showHUDBool {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.backButton.isHidden = true
                self.collectionView.isHidden = true

                self.safeArea.alpha = 0.0
                self.safeAreaBottom.alpha = 0.0
            }, completion: { _ in
                    self.showHUDBool = false
                })
        } else {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.backButton.isHidden = false
                self.collectionView.isHidden = false

                self.safeArea.alpha = 1.0
                self.safeAreaBottom.alpha = 1.0
            }, completion: { _ in
                    self.showHUDBool = true
                })
        }
    }

    func createNavBar() {
        safeArea.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: UIScreen.main.bounds.width, height: CGFloat(44))
        safeArea.backgroundColor = .black

        let navBar = UINavigationBar(frame: CGRect(x: 0, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: 30))
        navBar.backgroundColor = UIColor.black
        navBar.tintColor = UIColor.clear
        navBar.barTintColor = UIColor.clear
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = false
        navBar.delegate = self as? UINavigationBarDelegate

        backButton.setTitle("S", for: .normal)
        backButton.frame = CGRect(x: 15, y: self.view.frame.origin.y + 12, width: 22, height: 20)
        backButton.titleLabel?.font = UIFont(name: "caixabank", size: 20.0)
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        backButton.isHidden = false
        backButton.alpha = 1
        backButton.backgroundColor = .clear

        closeButton.setTitle("S", for: .normal)
        closeButton.frame = CGRect(x: UIScreen.main.bounds.width - 39, y: self.view.frame.origin.y + 12, width: 22, height: 20)
        closeButton.titleLabel?.font = UIFont(name: "caixabank", size: 20.0)
        closeButton.addTarget(self, action: #selector(self.closeFullscreenImage), for: .touchUpInside)
        closeButton.isHidden = false
        closeButton.alpha = 1
        closeButton.backgroundColor = .clear

        self.view.addSubview(self.safeArea)
        self.view.addSubview(self.backButton)
        if self.closeBool {
            self.view.addSubview(self.closeButton)
        }
    }

    @objc fileprivate func backButtonPressed() {
        self.dismiss(animated: false, completion: nil)
        self.collectionView.reset()
        self.imageScrollView.reset()
        self.firstTime = true
    }

    @objc func closeFullscreenImage(sender: UITapGestureRecognizer) {
        if maxCells <= 4 {
            delegateCBK?.eliminateImage()
        } else {
            self.removeImage(index: currentIndex ?? -1)
            DispatchQueue.main.async {
                self.checkButtonRubber()
            }
        }
    }

    public func resetZoom() {
        UIView.animate(withDuration: 0.05, animations: { () -> Void in
            for i in 0...self.items.count - 1 {
                let page = self.items[i]

                for view in page.view.subviews {
                    if let view = view as? ZoomController {
                        view.setZoomScale(view.minimumZoomScale, animated: false)
                    }
                }
            }
        })
    }

    public func removeImage(index: Int) {
        switch typeImageViewer {
        case .arrayUIImage:
            arrayUIImage?.remove(at: index)
        case .arrayUrl:
            arrayDownloadedImages.remove(at: index)
        default:
            break
        }

        items.remove(at: index)

        if index == maxCells - 1 {
            self.goToPage(nextIndex: index - 1, previousIndex: index)
            self.currentIndex = index - 1
        } else {
            self.goToPage(nextIndex: index, previousIndex: index - 1)
            self.currentIndex = index 
        }
        
        collectionView.reloadData()
    }

    public func checkButtonRubber() {
        if maxCells <= 4 {
            closeButton.removeFromSuperview()
        }
    }
}

extension FullScreenViewController: UIPageViewControllerDataSource {
    public func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else { return nil }
        if viewControllerIndex != 0 {
            self.currentIndex = viewControllerIndex
            self.previousIndex = viewControllerIndex - 1
            guard (previousIndex ?? -1) >= 0 else { return items.last }
            guard items.count > (previousIndex ?? -1) else { return nil }
            return items[previousIndex ?? -1]
        }
        return nil
    }

    public func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = items.firstIndex(of: viewController) else { return nil }
        if viewControllerIndex != items.count - 1 {
            self.currentIndex = viewControllerIndex
            self.nextIndex = viewControllerIndex + 1
            guard items.count != nextIndex else { return items.first }
            guard items.count > (nextIndex ?? -1) else { return nil }
            return items[nextIndex ?? -1]
        }
        return nil
    }

    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.resetZoom()

        if completed {
            if let currentViewController = pageViewController.viewControllers?.first,
                let index = items.firstIndex(of: currentViewController) {

                currentIndex = index

                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCarrousel.reuserIdentifier, for: IndexPath(row: currentIndex ?? -1, section: 0)) as? PhotoCarrousel {

                    for _ in collectionView.visibleCells {
                        cell.unselectCell()
                    }

                    cell.unselectCell()

                    self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex ?? -1, section: 0), at: .centeredHorizontally, animated: true)

                    collectionView.reloadData()
                }
            }
        }
    }

    public func presentationCount(for page: UIPageViewController) -> Int {
        if items.count == 1 {
            dataSource = nil
            delegate = nil
        }
        return items.count
    }

    public func presentationIndex(for page: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = items.firstIndex(of: firstViewController) else {
            return 0
        }
        return nextIndex ?? -1
    }
}

extension FullScreenViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch typeImageViewer {
        case .arrayUIImage:
            maxCells = arrayUIImage?.count ?? -1
            return maxCells
        case .arrayUrl:
            maxCells = arrayDownloadedImages.count
            return maxCells
        default:
            return 1
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCarrousel.reuserIdentifier, for: indexPath) as? PhotoCarrousel {

            self.previousIndex = self.currentIndex

            var photo: UIImage = UIImage()

            switch typeImageViewer {
            case .arrayUIImage:
                photo = arrayUIImage?[indexPath.row] ?? UIImage()
            case .arrayUrl:
                photo = arrayDownloadedImages[indexPath.row]
            default:
                break
            }

            cell.configureCell(image: photo)
            cell.unselectCell()

            if currentIndex == indexPath.row {
                cell.selectCell()
                self.collectionView.scrollToItem(at: IndexPath(item: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            }

            cell.imageView.contentMode = .scaleAspectFill

            self.collectionView.isUserInteractionEnabled = true

            return cell
        }
        return UICollectionViewCell()
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCarrousel.reuserIdentifier, for: indexPath) as? PhotoCarrousel {
            currentIndex = indexPath.row

            if (collectionView.cellForItem(at: indexPath) as? PhotoCarrousel) != nil {
                for _ in collectionView.visibleCells {
                    cell.unselectCell()
                }

                nextIndex = indexPath.row

                cell.isSelected = true

                self.goToPage(nextIndex: nextIndex ?? -1, previousIndex: previousIndex ?? -1)

                self.collectionView.reloadData()
                self.resetZoom()
            }
        }
    }

    public func goToPage(nextIndex: Int, previousIndex: Int) {
        if nextIndex < items.count {
            if nextIndex > previousIndex {
                self.setViewControllers([items[nextIndex]], direction: .forward, animated: true, completion: nil)
            } else {
                self.setViewControllers([items[nextIndex]], direction: .reverse, animated: true, completion: nil)
            }
        }
    }
}

extension FullScreenViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell: PhotoCarrousel = Bundle.main.loadNibNamed(PhotoCarrousel.nibName, owner: self, options: nil)?.first as? PhotoCarrousel else { return CGSize.zero }

        var photoCollection: UIImage = UIImage()

        switch typeImageViewer {
        case .arrayUIImage:
            photoCollection = arrayUIImage?[indexPath.row] ?? UIImage()
        case .arrayUrl:
            photoCollection = arrayDownloadedImages[indexPath.row]
        default:
            break
        }

        cell.configureCell(image: photoCollection)
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: 90)
    }
}

extension UIScrollView {
    func reset() {
        self.contentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
    }
}
