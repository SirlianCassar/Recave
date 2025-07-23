// MARK: - VueParametres.swift

import SwiftUI

/// Vue des paramètres pour gérer les catégories personnalisées
struct VueParametres: View {
    @EnvironmentObject var gestionnaire: GestionnaireReapprovisionnement
    @State private var afficherAjoutCategorie = false

    var body: some View {
        List {
            // Section des catégories par défaut (non modifiables)
            Section("Catégories par défaut") {
                ForEach(gestionnaire.categoriesParDefaut) { categorie in
                    NavigationLink(destination: VueEditionCategorie(categorie: .constant(categorie), estParDefaut: true)) {
                        HStack {
                            Text(categorie.nom)
                            Spacer()
                            Text("\(categorie.articles.count) articles")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .disabled(true)
                }
            }

            // Section des catégories personnalisées (modifiables)
            Section("Catégories personnalisées") {
                ForEach($gestionnaire.categoriesPersonnalisees) { $categorie in
                    NavigationLink(destination: VueEditionCategorie(categorie: $categorie, estParDefaut: false)) {
                        HStack {
                            Text(categorie.nom)
                            Spacer()
                            Text("\(categorie.articles.count) articles")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: supprimerCategorie)

                // Bouton d'ajout
                Button(action: {
                    afficherAjoutCategorie = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                        Text("Ajouter une catégorie")
                    }
                }
            }
        }
        .navigationTitle("Paramètres")
        .sheet(isPresented: $afficherAjoutCategorie) {
            VueNouvelleCategorie()
        }
    }

    /// Supprimer une ou plusieurs catégories personnalisées
    private func supprimerCategorie(at offsets: IndexSet) {
        for index in offsets {
            gestionnaire.supprimerCategorie(gestionnaire.categoriesPersonnalisees[index])
        }
    }
}
