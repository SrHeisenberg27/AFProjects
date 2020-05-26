//
//  MapKitVC.swift
//  AFProjects
//
//  Created by Álvaro Ferrández Gómez on 26/05/2020.
//  Copyright © 2020 Álvaro Ferrández Gómez. All rights reserved.
//

import UIKit
import MapKit

class MapKitVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    //MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!

    //MARK: Map variables
    fileprivate var locationManager: CLLocationManager?
    fileprivate var annotation: MKAnnotation?
    fileprivate var isCurrentLocation: Bool = false

    //MARK: Shearch variables
    fileprivate var searchController: UISearchController?
    fileprivate var localSearchRequest: MKLocalSearch.Request?
    fileprivate var localSearch: MKLocalSearch?
    fileprivate var localSearchResponse: MKLocalSearch.Response?

    //MARK: Indicator variables
    fileprivate var activityIndicator: UIActivityIndicatorView?

    //MARK: Lyfe cicle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let backbutton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backAction(_:)))

        let currentLocationButton = UIBarButtonItem(title: "Current location", style: .plain, target: self, action: #selector(currentLocationButtonAction(_:)))
        self.navigationItem.leftBarButtonItems = [backbutton, currentLocationButton]

        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = searchButton

        mapView.delegate = self
        mapView.mapType = .hybrid

        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator?.hidesWhenStopped = true
        self.view.addSubview(activityIndicator ?? UIActivityIndicatorView())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        activityIndicator?.center = self.view.center
        self.navigationController?.navigationBar.isHidden = false
    }

    //MARK: Private methods
    @objc func currentLocationButtonAction(_ sender: UIBarButtonItem) {
        if CLLocationManager.locationServicesEnabled() {
            if locationManager == nil {
                locationManager = CLLocationManager()
            }

            if let locationManager = locationManager {
                locationManager.requestWhenInUseAuthorization()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                isCurrentLocation = true
            }
        }
    }

    @objc func searchButtonAction(_ button: UIBarButtonItem) {
        if searchController == nil {
            searchController = UISearchController(searchResultsController: nil)
        }

        if let searchController = searchController {
            searchController.hidesNavigationBarDuringPresentation = false
            self.searchController?.searchBar.delegate = self
            present(searchController, animated: true, completion: nil)
        }
    }

    private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            self.mapView.setRegion(region, animated: true)

            if self.mapView.annotations.count != 0 {
                annotation = self.mapView.annotations[0]

                if let annotation = annotation {
                    self.mapView.removeAnnotation(annotation)
                }
            }

            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = location.coordinate
            pointAnnotation.title = ""
            mapView.addAnnotation(pointAnnotation)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)

        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]

            if let annotation = annotation {
                self.mapView.removeAnnotation(annotation)
            }
        }

        localSearchRequest = MKLocalSearch.Request()

        if let localSearchRequest = localSearchRequest {
            localSearchRequest.naturalLanguageQuery = searchBar.text
            localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch?.start { [weak self] (localSearchResponse, error) -> Void in

                if localSearchResponse == nil {
                    let alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                    alert.show()
                    return
                }

                if let localSearchResponse = localSearchResponse {
                    let pointAnnotation = MKPointAnnotation()
                    pointAnnotation.title = searchBar.text
                    pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude: localSearchResponse.boundingRegion.center.longitude)

                    let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
                    if let annotation = pinAnnotationView.annotation {
                        self?.mapView.centerCoordinate = pointAnnotation.coordinate
                        self?.mapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if !isCurrentLocation {
            return
        }

        isCurrentLocation = false

        let location = locations.last
        if let location = location {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            self.mapView.setRegion(region, animated: true)

            if self.mapView.annotations.count != 0 {
                annotation = self.mapView.annotations[0]

                if let annotation = annotation {
                    self.mapView.removeAnnotation(annotation)
                }
            }

            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = location.coordinate
            pointAnnotation.title = ""
            mapView.addAnnotation(pointAnnotation)
        }
    }

    @objc func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
