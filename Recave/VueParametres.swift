import SwiftUI

/// Vue des paramètres avec deux sections : Contenu (catégories) et Imprimante
struct VueParametres: View {
    @EnvironmentObject var gestionnaire: GestionnaireReapprovisionnement
    @State private var afficherAjoutCategorie = false

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Section Contenu
                Section("Contenu") {
                    ForEach($gestionnaire.categoriesPersonnalisees) { $categorie in
                        NavigationLink(destination: VueDetailCategorie(categorie: $categorie)) {
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

                // MARK: - Section Imprimante
                Section("Imprimante") {
                    NavigationLink(destination: VueConfigurationImprimante()) {
                        Label("Configurer l'imprimante", systemImage: "printer.fill")
                    }
                }
            }
            .navigationTitle("Paramètres")
            .sheet(isPresented: $afficherAjoutCategorie) {
                VueNouvelleCategorie()
            }
        }
    }

    /// Supprimer une ou plusieurs catégories
    private func supprimerCategorie(at offsets: IndexSet) {
        for index in offsets {
            gestionnaire.supprimerCategorie(gestionnaire.categoriesPersonnalisees[index])
        }
    }
}
