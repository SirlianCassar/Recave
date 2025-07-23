// MARK: - ContentView.swift

import SwiftUI

/// Vue principale qui injecte l’environnement du gestionnaire
struct ContentView: View {
    var body: some View {
        MenuPrincipalView()
            .environmentObject(GestionnaireReapprovisionnement())
    }
}
