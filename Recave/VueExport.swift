// MARK: - VueExport.swift

import SwiftUI

struct VueExport: View {
    let session: SessionReapprovisionnement
    @Environment(\.dismiss) private var dismiss
    @State private var texteExport = ""
    @State private var afficherPartage = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Liste de Réapprovisionnement")
                    .font(.title2)
                    .padding()

                ScrollView {
                    Text(texteExport)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding()
                }

                Button("Partager") {
                    afficherPartage = true
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
                .padding()
            }
            .navigationTitle("Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            genererTexteExport()
        }
        .sheet(isPresented: $afficherPartage) {
            ShareSheet(activityItems: [texteExport])
        }
    }

    private func genererTexteExport() {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "fr_FR")

        var texte = "RECAVE - LISTE DE RÉAPPROVISIONNEMENT\n"
        texte += "=====================================\n\n"
        texte += "Date: \(formatter.string(from: session.date))\n"
        texte += "Nombre d'articles: \(session.produits.count)\n\n"

        let produitsParCategorie = Dictionary(grouping: session.produits) { $0.categorie }

        for (categorie, produits) in produitsParCategorie.sorted(by: { $0.key < $1.key }) {
            texte += "\(categorie.uppercased())\n"
            texte += String(repeating: "-", count: categorie.count) + "\n"

            for produit in produits.sorted(by: { $0.nom < $1.nom }) {
                texte += "• \(produit.nom) - Quantité: \(produit.quantite)\n"
            }
            texte += "\n"
        }

        self.texteExport = texte
    }
}
