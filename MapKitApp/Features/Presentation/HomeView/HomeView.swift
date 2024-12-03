//
//  HomeView.swift
//  MapKitApp
//
//  Created by Antonio Hernández Barbadilla on 2/12/24.
//
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var manager: LocationManager
    
    var body: some View {
        if let location = manager.location,
           let region = manager.region {
            MapView(viewModel: MapViewModel(location: location, region: region))

        } else {
            ProgressView() // -> Vista predefinida que muestra un Loader
        }
    }
}

#Preview {
    ContentView()
}
