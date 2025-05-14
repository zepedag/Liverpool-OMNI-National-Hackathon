//
//  ContentView.swift
//  HackLiverpool
//
//  Created by iOS Lab on 13/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showOverlay = true
    @State private var navigateToMain = false

    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink(
                    destination: NavigationBar(), // Vista con navigationBar
                    isActive: $navigateToMain,
                    label: { EmptyView() }
                )

                if showOverlay {
                    SelectExperienceOverlayView { action in
                        switch action {
                        case .close:
                            showOverlay = false
                        case .findProduct:
                            // ...
                            break
                        case .requestExpert:
                            // ...
                            break
                        case .exploreOnMyOwn:
                            // Cerrar overlay y navegar
                            showOverlay = false
                            navigateToMain = true
                        }
                    }
                } else {
                    // Opcionalmente muestra otra cosa debajo
                    Color.white.ignoresSafeArea()
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
