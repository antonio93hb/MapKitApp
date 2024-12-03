//
//  MapViewModel.swift
//  MapKitApp
//
//  Created by Antonio Hernández Barbadilla on 2/12/24.
//

import Foundation
import Observation // -> Permite que todas las propiedades las escuche el mapView y las use como un published
import MapKit
import SwiftUI

enum MyMapStyle: Int {
    case standard = 0
    case imagery
    case hybrid
    
    func toMapStyle() -> MapStyle {
        switch self {
        case .standard: return .standard
        case .imagery: return .imagery
        case .hybrid: return .hybrid
        }
    }
    
    func toogle() -> MyMapStyle {
        switch self {
        case .standard: return .imagery
        case .imagery: return .hybrid
        case .hybrid: return .standard
        }
    }
    
}

@Observable class MapViewModel {
    var cameraPosition: MapCameraPosition
    var location: CLLocation?
    var region: MKCoordinateRegion
    var mapSelection: MKMapItem?
    
    var mapStyle: MyMapStyle = .standard
    
    var isLoading: Bool = false
    
    var viewingRegion: MKCoordinateRegion?
    
    var routeDisplaying: Bool = false
    
    var lookAroundScene: MKLookAroundScene? // -> Vista en 3d que hace mapKit
    
    init(location: CLLocation?, region: MKCoordinateRegion) {
        self.cameraPosition = .region(region)
        self.location = location
        self.region = region
    }
}

extension MapViewModel {
    func fetchLookAroundPreview(coordinate: CLLocationCoordinate2D) async {
        isLoading = true
        lookAroundScene = nil
        let request = MKLookAroundSceneRequest(coordinate: coordinate)
        lookAroundScene = try? await request.scene
    }
}
