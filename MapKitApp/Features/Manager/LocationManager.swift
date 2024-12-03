//
//  LocationManager.swift
//  MapKitApp
//
//  Created by Antonio Hernández Barbadilla on 1/12/24.
//

import Foundation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private var locationManager: CLLocationManager?
    
    @Published var location: CLLocation?
    @Published var error: Error?
    @Published var region: MKCoordinateRegion?
    
    override init() {
        super.init()
        requestLocation()
    }
    
    func requestLocation() {
        locationManager = CLLocationManager() //Objeto para empezar o detener la localización del user
        locationManager?.delegate = self // Es de tipo CLLocationManagerDelegate, así que puede ser self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest // Con esto le decimos que use la ubicación más precisa posible
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization() // Si no tiene autorización de ubicación la pide
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .restricted, .denied:
            print("Permiso denegado por el usuario.")
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last { // Asignamos las coordinadas actuales a nuestro objeto
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            self.location = location
            self.region = region
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.error = error //Con esto gestionamos si hay errores por ejemplo de conexión
    }
    
}
