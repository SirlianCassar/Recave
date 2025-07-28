import SwiftUI

/// Vue de configuration pour l’imprimante (placeholder pour l’instant)
struct VueConfigurationImprimante: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "printer.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)

            Text("Configuration de l’imprimante")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Tu pourras bientôt entrer ici les infos de ton imprimante (IP, port, modèle…).")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Imprimante")
        .navigationBarTitleDisplayMode(.inline)
    }
}
