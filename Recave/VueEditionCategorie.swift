// MARK: - VueEditionCategorie.swift

import SwiftUI



/// Vue de modification (ou consultation) d'une catégorie
struct VueEditionCategorie: View {
    @EnvironmentObject var gestionnaire: GestionnaireReapprovisionnement
    @Binding var categorie: CategoriePersonnalisee
    @Environment(\.dismiss) var dismiss
    let estParDefaut: Bool

    @State private var nomCategorie: String
    @State private var articles: [String]
    @State private var nouvelArticle = ""
    @State private var afficherAjoutArticle = false

    init(categorie: Binding<CategoriePersonnalisee>, estParDefaut: Bool) {
        self._categorie = categorie
        self.estParDefaut = estParDefaut
        self._nomCategorie = State(initialValue: categorie.wrappedValue.nom)
        self._articles = State(initialValue: categorie.wrappedValue.articles)
    }

    var body: some View {
        List {
            if !estParDefaut {
                Section("Nom de la catégorie") {
                    TextField("Nom", text: $nomCategorie)
                        .onSubmit {
                            sauvegarder()
                        }
                }
            }

            Section("Articles") {
                ForEach(Array(articles.enumerated()), id: \.offset) { index, article in
                    HStack {
                        TextField("Article", text: Binding(
                            get: { articles[index] },
                            set: { articles[index] = $0; sauvegarder() }
                        ))
                        .disabled(estParDefaut)

                        if !estParDefaut {
                            Button(action: {
                                articles.remove(at: index)
                                sauvegarder()
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }

                if !estParDefaut {
                    Button(action: {
                        afficherAjoutArticle = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                            Text("Ajouter un article")
                        }
                    }
                }
            }
        }
        .navigationTitle(nomCategorie)
        .navigationBarBackButtonHidden(estParDefaut ? false : true)
        .toolbar {
            if !estParDefaut {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") {
                        sauvegarder()
                        dismiss() // ferme la vue
                    }
                }
            }
        }
        .overlay(
            Group {
                if afficherAjoutArticle {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                afficherAjoutArticle = false
                                nouvelArticle = ""
                            }

                        OverlayAjoutArticle(
                            nomArticle: $nouvelArticle,
                            onAjouter: {
                                if !nouvelArticle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    articles.append(nouvelArticle)
                                    nouvelArticle = ""
                                    sauvegarder()
                                }
                                afficherAjoutArticle = false
                            },
                            onAnnuler: {
                                nouvelArticle = ""
                                afficherAjoutArticle = false
                            }
                        )
                    }
                }
            }
        )
    }

    /// Met à jour le modèle dès qu’un changement est effectué
    private func sauvegarder() {
        if !estParDefaut {
            categorie.nom = nomCategorie
            categorie.articles = articles
            gestionnaire.mettreAJourCategorie(categorie)
        }
    }
}
