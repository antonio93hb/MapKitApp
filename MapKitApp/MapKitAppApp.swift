//
//  MapKitAppApp.swift
//  MapKitApp
//
//  Created by Antonio Hernández Barbadilla on 29/11/24.
//

import SwiftUI

@main
struct MapKitAppApp: App {
    @StateObject var manager = LocationManager() //Objeto que depende de la clase observableObject (LocationManager)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(manager) // Con esto podremos usar el manager en toda la app
        }
    }
}
