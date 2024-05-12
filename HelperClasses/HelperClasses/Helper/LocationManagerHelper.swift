//
//  LocationManagerHelper.swift
//  HelperClasses
//
//  Created by Meet Appmatictech on 25/03/24.
//

import Foundation
import CoreLocation

class LocationManagerHelper : NSObject{
    
    static let shared = LocationManagerHelper()
    private var locationManager : CLLocationManager!
    var lastLocation : CLLocation? = nil
    var lastLocationPlaceMark: PlaceMark? = nil {
        didSet{
            if lastLocationPlaceMark != nil{
                NotificationCenter.default.post(name: .Locations.didUpdatedPlaceMark, object: nil)
            }
        }
    }
    
    private var getLastLocatinDetails : ((PlaceMark) -> Void)? = nil
    
    private override init() {
        super.init()
        configureLocationManager()
    }
    
    private func configureLocationManager(){
        locationManager = CLLocationManager()
        DispatchQueue.global(qos: .background).async {
            self.checkLocationAuthorization()
        }
    }
  
    func checkLocationAuthorization(){
        DispatchQueue.main.async { [weak self] in
            guard let _ = self else { return }
//            AppDelegate.getAppDelegateRef()?.getActiveVC()?.removeLocationAccessDeniedPopUp()
        }
        
        switch locationManager.authorizationStatus {
            
        case.authorizedAlways, .authorizedWhenInUse :
            setLocationManager()
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            DispatchQueue.main.async { [weak self] in
                guard let _ = self else { return }
//                AppDelegate.getAppDelegateRef()?.getActiveVC()?.showLocationAccessDeniedPopUp()
            }
            
        @unknown default:
            fatalError()
        }
    }
    
    func setLocationManager(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func isLocationAvailable() -> Bool{
        return (locationManager?.authorizationStatus == .authorizedWhenInUse) || (locationManager?.authorizationStatus == .authorizedAlways)
    }
    
    func fetchLastLoationPlacemarkDetails(completion : ((PlaceMark) -> Void)? = nil ){
        guard let lastLocation else {
            configureLocationManager()
            getLastLocatinDetails = completion
            return
        }
        
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            getLocationDetailsByCoords(coords: lastLocation.coordinate, completion: { pm in
                self.lastLocationPlaceMark = pm
                completion?(pm)
            })
        }else{
            checkLocationAuthorization()
        }
    }
    
    func getLocationDetailsByCoords(coords: CLLocationCoordinate2D, completion : ((PlaceMark) -> Void)? = nil ){
        let location = CLLocation(latitude: coords.latitude, longitude: coords.longitude)
        let coder = CLGeocoder()
        
        coder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, error)->Void in
            guard let _ = self, let placemarks, placemarks.count > 0, error == nil else{
                print("Reverse geocoder failed with error ", error?.localizedDescription ?? "")
                return
            }
            let pm = placemarks[0].toPlacemark()
            completion?(pm)
        })  // CLGeocoder().reverseGeocodeLocation
    }   // getLocationDetailsByCoords
}

extension LocationManagerHelper : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed with Error : ", error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else {
            print("Not found Location")
            return
        }
        self.lastLocation = location
        if lastLocationPlaceMark == nil, let coords = lastLocation?.coordinate{
            getLocationDetailsByCoords(coords: coords, completion: { [weak self] pm in
                guard let self else { return }
                lastLocationPlaceMark = pm
                getLastLocatinDetails?(pm)
            })
        }
    }   // locationManager
    
}   // LocationManagerHelper

extension CLPlacemark {
    func toPlacemark() -> PlaceMark {
        PlaceMark(name: self.name, subLocality: self.subLocality, locality: self.locality, administrativeArea: self.administrativeArea, subAdministrativeArea: self.subAdministrativeArea, country: self.country, postalCode:  self.postalCode, coordinates: self.location?.coordinate)
        
    }   // toPlacemark
}

struct PlaceMark{
    var name : String?
    var subLocality : String?
    var locality : String?
    var administrativeArea: String?  // state
    var subAdministrativeArea: String?  // could be capital
    var country : String?
    var postalCode : String?
    var coordinates : CLLocationCoordinate2D?
    
    func toString() -> String{
        var finalText : String = ""
        
        if let name = self.name {
            finalText.append(name)
        }
        
        if let subLocality = self.subLocality, subLocality != (self.name ?? ""){
            
            if finalText != ""{
                finalText.append(", ")
            }
            finalText.append(subLocality)
        }
        
        if let locality = self.locality {
            
            if finalText != ""{
                finalText.append(", ")
            }
            finalText.append(locality)
        }
        
        if let administrativeArea = self.administrativeArea{
            
            if finalText != ""{
                finalText.append(", ")
            }
            finalText.append(administrativeArea)
        }
        
        if let postalCode = self.postalCode{
            
            if finalText != ""{
                finalText.append(", ")
            }
            finalText.append(postalCode)
        }
        
        if let country = self.country{
            
            if finalText != ""{
                finalText.append(", ")
            }
            finalText.append(country)
        }   // if let country
        
        return finalText
    }   // toString
}   // PlaceMark


