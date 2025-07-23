// MARK: - VueNouvelleCategorie.swift

import SwiftUI

/// Vue modale pour ajouter une nouvelle catégorie personnalisée
struct VueNouvelleCategorie: View {
    @EnvironmentObject var gestionnaire: GestionnaireReapprovisionnement
    @Environment(\.dismiss) private var dismiss
    @State private var nomCategorie = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nom de la catégorie", text: $nomCategorie)
            }
            .navigationTitle("Nouvelle Catégorie")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annuler") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Créer") {
                        let nouvelleCategorie = CategoriePersonnalisee(nom: nomCategorie)
                        gestionnaire.ajouterCategorie(nouvelleCategorie)
                        dismiss()
                    }
                    .disabled(nomCategorie.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
