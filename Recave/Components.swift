// MARK: - Components.swift

import SwiftUI

// MARK: BoutonPrincipal
struct BoutonPrincipal: View {
    let titre: String
    let icone: String
    let couleur: Color

    var body: some View {
        HStack {
            Image(systemName: icone)
                .font(.title2)
            Text(titre)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(couleur)
        .cornerRadius(12)
        .padding(.horizontal, 30)
    }
}

// MARK: OverlayAjoutArticle
struct OverlayAjoutArticle: View {
    @Binding var nomArticle: String
    var onAjouter: () -> Void
    var onAnnuler: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Nouvel article")
                .font(.headline)

            TextField("Nom de l'article", text: $nomArticle)
                .textFieldStyle(.roundedBorder)
                .frame(width: 250)

            HStack(spacing: 30) {
                Button("Annuler", action: onAnnuler)
                Button("Ajouter", action: onAjouter)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
}

// MARK: OverlayModifierQuantite
struct OverlayModifierQuantite: View {
    @Binding var quantite: String
    var onValider: () -> Void
    var onAnnuler: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Modifier la quantité")
                .font(.headline)

            TextField("Quantité", text: $quantite)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 100)

            HStack(spacing: 30) {
                Button("Annuler", action: onAnnuler)
                Button("Valider", action: onValider)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
}

// MARK: - ShareSheet (pour export / partage)
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
