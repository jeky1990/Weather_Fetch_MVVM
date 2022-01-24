//
//  PlaceSelectionVC.swift
//  Jaykishan_Weather_App_Demo
//
//  Created by Chalo-MBP2 on 20/01/22.
//

import UIKit
import MapKit
import CoreLocation

protocol PlaceSelectionVCDelegate : AnyObject {
    func dataFatched(wData : weatherDataList?, paramData : urlParam?)
}

class PlaceSelectionVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var previousLocation: CLLocation?
    
    weak var delegate : PlaceSelectionVCDelegate?
    
    var weatherDataVM = WeatherDataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            self.setupLocationManager()
            self.checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    
    func startTackingUserLocation() {
        self.mapView.showsUserLocation = true
        self.centerViewOnUserLocation()
        self.locationManager.startUpdatingLocation()
        self.previousLocation = self.getCenterLocation(for: self.mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

//MARK:- Cllocation manager delegate
extension PlaceSelectionVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}

//MARK:- MK Mapkit delegate
extension PlaceSelectionVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            let city = placemark.locality ?? ""
            let state = placemark.administrativeArea ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(city) - \(state)"
            }
        }
    }
}

//MARK:- All Action
extension PlaceSelectionVC {
    
    @IBAction func saveLoc(_ sender : UIBarButtonItem) {
        self.callWeatherApi()
    }
    
    //Call weather api
    func callWeatherApi() {
        if self.previousLocation != nil {
            if CommonFunction.isInternetAvailable() {
                
                SKActivityIndicator.show()
                
                let param = [ "lat" : self.previousLocation?.coordinate.latitude ?? 0.0,
                              "lon" : self.previousLocation?.coordinate.longitude ?? 0.0,
                              "units" : "metric",
                              "cnt" : 15,
                              "appid" : VALIDATE_API_KEY] as [String : Any]
                
                self.weatherDataVM.fetchWeatherInfoAPI(params: param) { status, msg in
                    DispatchQueue.main.async {
                        SKActivityIndicator.dismiss()
                        if status {
                            do {
                                let data = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed)
                                self.delegate?.dataFatched(wData: self.weatherDataVM.weatherData,
                                paramData: urlParam(lat: self.previousLocation?.coordinate.latitude ?? 0.0, lng: self.previousLocation?.coordinate.longitude ?? 0.0))
                            }
                            
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            CommonFunction.showAlertMessageWithTitle(aStrTitle: "Alert",
                                                                     aStrMessage: msg,
                                                                     Oktitle: "Ok",
                                                                     CancelTitle: "",
                                                                     cancelHide: true,
                                                                     aViewController: self) { cancelAction in
                                //
                            } OKActionTap: { OkAction in
                                //
                            }
                        }
                    }
                }
                
                
            } else {
                CommonFunction.showAlertMessageWithTitle(aStrTitle: "Alert",
                                                         aStrMessage: "No internet available!",
                                                         Oktitle: "Ok",
                                                         CancelTitle: "",
                                                         cancelHide: true,
                                                         aViewController: self) { cancelAction in
                    //
                } OKActionTap: { OkAction in
                    //
                }

            }
        } else {
            CommonFunction.showAlertMessageWithTitle(aStrTitle: "Alert",
                                                     aStrMessage: "Please select location again",
                                                     Oktitle: "Ok",
                                                     CancelTitle: "",
                                                     cancelHide: true,
                                                     aViewController: self) { cancelAction in
                //
            } OKActionTap: { OkAction in
                //
            }
        }
    }
    
}
