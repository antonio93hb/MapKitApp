//
//  MapView.swift
//  MapKitApp
//
//  Created by Antonio Hernández Barbadilla on 2/12/24.
//

import SwiftUI
import Observation
import MapKit

struct MapView: View {
    
    @Bindable var viewModel: MapViewModel
    @State var showErrorAlert = false
    @State var lookAroundViewIsExpanded: Bool = false
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            mapView
            if viewModel.lookAroundScene != nil {
                lookAroundPreviewView
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text("Error inesperado."), dismissButton: .default(Text("Aceptar")))
        }
    }
    
    var mapView: some View {
        Map(position: $viewModel.cameraPosition,
            selection: $viewModel.mapSelection) {
            UserAnnotation() //Muestra la ubicación del usuario con un punto azul
            
            if viewModel.lookAroundScene != nil {
                if let coordinate = viewModel.viewingRegion?.center {
                    Annotation("Library", coordinate: coordinate) {
                        AnimatedMarker(systemName: "binoculars.fill", imageColor: .red, backgroundColor: .clear)
                    }.annotationTitles(.hidden)
                }
            }
//                if let coordinate = viewModel.viewingRegion?.center {
//                    Annotation("Library", coordinate: coordinate) {
//                        IconView(systemName:"map.fill")
//                    }
//                }
        }
            .mapStyle(viewModel.mapStyle.toMapStyle())
            .onMapCameraChange { contexto in
                viewModel.viewingRegion = contexto.region
            }
            .overlay(alignment: .topTrailing) {
                topTrailingOverlayView
            }
            .overlay(alignment: .bottomTrailing) {
                bottomTrailingOverlayView
            }
            .overlay(alignment: .bottomLeading) {
                if !viewModel.routeDisplaying {
                    bottomLeadingOverlayView
                }
            }
    }
}

extension MapView {
    var lookAroundPreviewView: some View {
        VStack {
            LookAroundPreview(scene: $viewModel.lookAroundScene)
                .frame(height: lookAroundViewIsExpanded ? UIScreen.main.bounds.height - 32 : 300)
                .animation(.easeInOut, value: viewModel.lookAroundScene)
                .overlay(alignment: .topTrailing, content: {
                    VStack{
                        IconView(systemName: "xmark.circle.fill")
                            .frame(width: 62, height: 46)
                            .onTapGesture {
                                Task {
                                    viewModel.lookAroundScene = nil
                                    lookAroundViewIsExpanded = false
                                }
                            }
                        IconView(systemName: lookAroundViewIsExpanded ? "arrow.down.right.and.arrow.up.left" : "arrow.up.backward.and.arrow.down.forward")
                            .frame(width: 62, height: 46)
                            .onTapGesture {
                                Task {
                                    lookAroundViewIsExpanded.toggle()
                                }
                            }
                    }.padding(.vertical)
                }).padding(.horizontal, 4)
            Spacer()
        }
    }
}
