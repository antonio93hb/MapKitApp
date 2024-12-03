//
//  MapViewComponents.swift
//  MapKitApp
//
//  Created by Antonio Hernández Barbadilla on 2/12/24.
//

import Foundation
import SwiftUI

extension MapView {
    var topTrailingOverlayView: some View {
        VStack(spacing: -5) {
            IconView(systemName: "map.fill")
                .onTapGesture {
                    self.viewModel.mapStyle = viewModel.mapStyle.toogle()
                }
            if viewModel.isLoading {
                ProgressView()
                    .font(.title3)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 44, height: 44)
                            .foregroundColor(.init(.systemBackground))
                    )
                    .padding()
            } else {
                IconView(systemName: "location.fill")
                    .onTapGesture {
                        withAnimation {
                            viewModel.cameraPosition = .region(viewModel.region)
                        }
                    }
            }
        }
    }
    
    var bottomTrailingOverlayView: some View {
        HStack(spacing: -10) {
            IconView(systemName: "sun.min.fill", imageColor: .yellow)
                .offset(x:-10)
            Text("14˚")
                .foregroundColor(.init(.gray))
                .font(.title3)
                .offset(x:-13)
        }.background(
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 62, height: 46)
                .foregroundColor(.init(.systemBackground))
        ).offset(y:-80)
    }
    
    var bottomLeadingOverlayView: some View {
        IconView(systemName: "binoculars.fill")
            .frame(width: 62, height: 46)
            .offset(y:-80)
            .onTapGesture {
                Task {
                    guard let coordinate = viewModel.viewingRegion?.center else {
                        showErrorAlert = true
                        return
                    }
                    await viewModel.fetchLookAroundPreview(coordinate: coordinate)
                    viewModel.isLoading = false
                }
            }
    }
}
