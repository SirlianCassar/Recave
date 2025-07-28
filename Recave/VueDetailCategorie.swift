import SwiftUI

struct VueDetailCategorie: View {
    @Binding var categorie: CategoriePersonnalisee
    @EnvironmentObject var gestionnaire: GestionnaireReapprovisionnement

    @State private var nouvelArticle = ""
    @State private var articleEnEdition: String? = nil
    @State private var nomTemporaire: String = ""

    var body: some View {
        Form {
            Section(header: Text("Articles de la catégorie")) {
                ForEach(categorie.articles, id: \.self) { article in
                    HStack {
                        Text(article)
                            .font(.body)
                        Spacer()
                        ColorPicker(
                            "",
                            selection: bindingPourCouleur(article),
                            supportsOpacity: false
                        )
                        .labelsHidden()
                        .frame(width: 35, height: 35)

                        Button(action: {
                            articleEnEdition = article
                            nomTemporaire = article
                        }) {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title3)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
                .onDelete(perform: supprimerArticle)
                .onMove(perform: deplacerArticle)
            }

            Section {
                HStack {
                    TextField("Ajouter un article", text: $nouvelArticle)
                    Button(action: ajouterArticle) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .disabled(nouvelArticle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .navigationTitle(categorie.nom)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            EditButton() // ➜ pour activer le mode édition et déplacer
        }
        .alert("Modifier le nom", isPresented: Binding<Bool>(
            get: { articleEnEdition != nil },
            set: { if !$0 { articleEnEdition = nil } }
        )) {
            TextField("Nom de l’article", text: $nomTemporaire)

            Button("Enregistrer", role: .none) {
                enregistrerModification()
            }
            Button("Annuler", role: .cancel) { }
        }
    }

    // MARK: - Modifier article
    func enregistrerModification() {
        guard let ancienNom = articleEnEdition else { return }
        let nouveauNom = nomTemporaire.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !nouveauNom.isEmpty, nouveauNom != ancienNom else { return }

        if let index = categorie.articles.firstIndex(of: ancienNom) {
            categorie.articles[index] = nouveauNom

            // transférer couleur si existante
            if let ancienneCouleur = gestionnaire.couleursPersonnalisees[ancienNom] {
                gestionnaire.couleursPersonnalisees[nouveauNom] = ancienneCouleur
                gestionnaire.couleursPersonnalisees.removeValue(forKey: ancienNom)
            }

            gestionnaire.mettreAJourCategorie(categorie)
        }
        articleEnEdition = nil
    }

    // MARK: - Ajouter article
    func ajouterArticle() {
        let propre = nouvelArticle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !propre.isEmpty else { return }

        if !categorie.articles.contains(propre) {
            categorie.articles.append(propre)
            gestionnaire.mettreAJourCategorie(categorie)
        }

        nouvelArticle = ""
    }

    // MARK: - Supprimer
    func supprimerArticle(at offsets: IndexSet) {
        for index in offsets {
            let article = categorie.articles[index]
            gestionnaire.couleursPersonnalisees.removeValue(forKey: article)
        }
        categorie.articles.remove(atOffsets: offsets)
        gestionnaire.mettreAJourCategorie(categorie)
    }

    // MARK: - Déplacer
    func deplacerArticle(from source: IndexSet, to destination: Int) {
        categorie.articles.move(fromOffsets: source, toOffset: destination)
        gestionnaire.mettreAJourCategorie(categorie)
    }

    // MARK: - Couleur article
    func bindingPourCouleur(_ article: String) -> Binding<Color> {
        let hex = gestionnaire.couleurPourArticle(article)
        let initial = Color(hex: hex)

        return Binding<Color>(
            get: { initial },
            set: { newColor in
                gestionnaire.definirCouleur(newColor.toHex(), pour: article)
            }
        )
    }
}
