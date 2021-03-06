//
//  ZoomController.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/04/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit

public class ZoomController: UIScrollView, UIScrollViewDelegate {

    var imageZoomView: UIImageView?
    var fullScreenVC: FullScreenViewController?

    lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false

        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(image: UIImage) {
        imageZoomView?.removeFromSuperview()
        imageZoomView = nil
        imageZoomView = UIImageView(image: image)
        self.addSubview(imageZoomView ?? UIImageView())

        configurateFor(imageSize: image.size)
    }

    func configurateFor(imageSize: CGSize) {
        self.contentSize = imageSize

        setCurrentMaxandMinZoomScale()
        self.zoomScale = self.minimumZoomScale

        self.imageZoomView?.addGestureRecognizer(self.zoomingTap)
        self.imageZoomView?.isUserInteractionEnabled = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.centerImage()
    }

    func setCurrentMaxandMinZoomScale() {
        let boundsSize = self.bounds.size
        if let imageSize = imageZoomView?.bounds.size {
            let xScale = boundsSize.width / imageSize.width
            let yScale = boundsSize.height / imageSize.height
            let minScale = min(xScale, yScale)

            var maxScale: CGFloat = 1.0
            if minScale < 0.1 {
                maxScale = 2.0
            }
            if minScale >= 0.1 && minScale < 0.5 {
                maxScale = 2.0
            }
            if minScale >= 0.5 {
                maxScale = max(2.0, minScale)
            }

            self.minimumZoomScale = minScale
            self.maximumZoomScale = maxScale
        }
    }

    func centerImage() {
        let boundsSize = self.bounds.size
        if var frameToCenter = imageZoomView?.frame {

            if frameToCenter.size.width < boundsSize.width {
                frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
            } else {
                frameToCenter.origin.x = 0
            }

            if frameToCenter.size.height < boundsSize.height {
                frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
            } else {
                frameToCenter.origin.y = 0
            }

            imageZoomView?.frame = frameToCenter
        }
    }

    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        self.zoom(point: location, animated: true)
    }

    func zoom(point: CGPoint, animated: Bool) {
        let currectScale = self.zoomScale
        let minScale = self.minimumZoomScale
        let maxScale = self.maximumZoomScale

        if (minScale == maxScale && minScale > 1) {
            return
        }

        let toScale = maxScale
        let finalScale = (currectScale == minScale) ? toScale : minScale
        let zoomRect = self.zoomRect(scale: finalScale, center: point)
        self.zoom(to: zoomRect, animated: animated)
    }

    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let bounds = self.bounds

        zoomRect.size.width = bounds.size.width / scale
        zoomRect.size.height = bounds.size.height / scale

        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageZoomView
    }

    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerImage()
    }

    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.fullScreenVC?.showHUDBool = false
        self.fullScreenVC?.showHUD()
    }

    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.fullScreenVC?.showHUDBool = true
        self.fullScreenVC?.showHUD()
    }
}
