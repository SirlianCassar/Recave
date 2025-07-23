import SwiftUI

struct VueReapprovisionnement: View {
    @EnvironmentObject var gestionnaire: GestionnaireReapprovisionnement
    @Environment(\.dismiss) private var dismiss
    @State var session: SessionReapprovisionnement

    @State private var categorieSelectionnee = "Canettes"
    @State private var produitSelectionne: ProduitStock?
    @State private var afficherExport = false
    @State private var afficherModificationQuantite = false
    @State private var nouvelleQuantite = ""
    @State private var afficherSaisieArticle = false
    @State private var nouvelArticleSaisi = ""

    @State private var panneauGaucheVisible = true
    @GestureState private var dragOffset: CGSize = .zero

    private let largeurPanneauGauche: CGFloat = 0.25
    private let largeurPanneauDroit: CGFloat = 0.2

    var categorieActuelle: CategoriePersonnalisee? {
        gestionnaire.toutesCategories.first { $0.nom == categorieSelectionnee }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // MARK: - Barre du haut
                HStack {
                    Button("Retour") { dismiss() }
                    Spacer()
                    Text("Réapprovisionnement")
                        .font(.headline)
                    Spacer()
                    Text(formaterDate(session.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(radius: 2)

                // MARK: - Panneaux principaux
                ZStack(alignment: .leading) {
                    HStack(spacing: 0) {

                        // MARK: - Panel Gauche (Liste)
                        if panneauGaucheVisible {
                            VStack(alignment: .leading) {
                                HStack {
                                    Spacer()
                                    Text("Liste")
                                        .font(.headline)
                                    Spacer()
                                }
                                .padding(.top)

                                ScrollView {
                                    ForEach(session.produits) { produit in
                                        Button(action: {
                                            produitSelectionne = produit
                                        }) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(produit.nom)
                                                        .font(.system(size: 11)) // réduit
                                                        .fontWeight(.medium)
                                                    Text("Qté: \(produit.quantite)")
                                                        .font(.system(size: 9)) // encore plus petit
                                                        .foregroundColor(.secondary)
                                                }
                                                Spacer()
                                            }
                                            .padding(12) // plus large
                                            .background(produitSelectionne?.id == produit.id ? Color.blue.opacity(0.2) :  Color(.systemBackground))
                                            .cornerRadius(8)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .padding(.horizontal)
                                }

                                HStack {
                                    Spacer()
                                    Button(action: {
                                        session.produits.removeAll()
                                        produitSelectionne = nil // <- important pour vider la sélection
                                        gestionnaire.mettreAJourSession(session)
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.white)
                                            .padding(10)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                    }
                                    Spacer()
                                }
                                .padding([.horizontal, .bottom])
                            }
                            .frame(width: geometry.size.width * largeurPanneauGauche)
                            .background(Color(.secondarySystemBackground))
                            .transition(.move(edge: .leading))
                        }

                        // MARK: - Panel Central (Articles)
                        VStack {
                            Text(categorieSelectionnee)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.top, 12)

                            ScrollView {
                                LazyVGrid(
                                    columns: [GridItem(.adaptive(minimum: panneauGaucheVisible ? 80 : 60), spacing: 14)],
                                    spacing: 14
                                ) {
                                    if let categorie = categorieActuelle {
                                        ForEach(categorie.articles, id: \.self) { produit in
                                            Button(action: {
                                                ajouterProduit(produit)
                                            }) {
                                                VStack(spacing: 6) {
                                                    Text(produit)
                                                        .font(.system(size: panneauGaucheVisible ? 16 : 14, weight: .semibold))
                                                        .multilineTextAlignment(.center)
                                                        .lineLimit(2)
                                                        .minimumScaleFactor(0.6)

                                                    if let qte = session.produits.first(where: { $0.nom == produit })?.quantite, qte > 0 {
                                                        Text("x\(qte)")
                                                            .font(.system(size: 12, weight: .bold))
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal, 6)
                                                            .padding(.vertical, 3)
                                                            .background(Color.red)
                                                            .cornerRadius(8)
                                                    }
                                                }
                                                .frame(height: panneauGaucheVisible ? 90 : 75)
                                                .frame(maxWidth: .infinity)
                                                .padding(6)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                            }
                                        }

                                        if categorie.nom == "Autres" {
                                            Button(action: {
                                                afficherSaisieArticle = true
                                            }) {
                                                VStack {
                                                    Image(systemName: "plus")
                                                        .font(.title2)
                                                    Text("Ajouter")
                                                        .font(.system(size: 14, weight: .medium))
                                                }
                                                .frame(height: panneauGaucheVisible ? 90 : 75)
                                                .frame(maxWidth: .infinity)
                                                .padding(6)
                                                .background(Color.gray)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .layoutPriority(1)
                        .background(Color(.systemGroupedBackground))

                        // MARK: - Panel Droit (Catégories)
                        VStack {
                            Text("Catégories")
                                .font(.footnote)
                                .padding(.vertical, 6)

                            ScrollView {
                                ForEach(gestionnaire.toutesCategories) { categorie in
                                    Button(action: {
                                        categorieSelectionnee = categorie.nom
                                    }) {
                                        Text(categorie.nom)
                                            .font(.system(size: 10))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .padding(.vertical, 18)
                                            .padding(.horizontal, 6)
                                            .frame(maxWidth: .infinity)
                                            .background(categorieSelectionnee == categorie.nom ? Color.orange : Color(.systemGray5))
                                            .foregroundColor(categorieSelectionnee == categorie.nom ? .white : .primary)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                        .frame(width: geometry.size.width * largeurPanneauDroit)
                        .background(Color(.tertiarySystemBackground))
                    }

                    // MARK: - Encoche
                    if !panneauGaucheVisible {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 8, height: 60)
                            .padding(.leading, 2)
                            .onTapGesture {
                                withAnimation { panneauGaucheVisible = true }
                            }
                    }
                }
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { value in
                            if value.translation.width < -50 {
                                withAnimation { panneauGaucheVisible = false }
                            } else if value.translation.width > 50 {
                                withAnimation { panneauGaucheVisible = true }
                            }
                        }
                )

                // MARK: - Barre du bas
                HStack(spacing: 24) {
                    if let produit = produitSelectionne {
                        Button("Supprimer") {
                            supprimerProduit(produit)
                        }
                        .foregroundColor(.red)

                        Button("Modifier") {
                            nouvelleQuantite = String(produit.quantite)
                            afficherModificationQuantite = true
                        }
                        .foregroundColor(.blue)
                    }

                    Spacer()

                    Button("Exporter") {
                        terminerSession()
                        afficherExport = true
                    }
                    .disabled(session.produits.isEmpty)
                }
                .padding()
                .background(Color(.systemBackground))
                .shadow(radius: 2)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $afficherExport) {
            VueExport(session: session)
        }
        .overlay(
            ZStack {
                if afficherModificationQuantite {
                    OverlayModifierQuantite(
                        quantite: $nouvelleQuantite,
                        onValider: {
                            if let quantite = Int(nouvelleQuantite),
                               let produit = produitSelectionne,
                               let index = session.produits.firstIndex(where: { $0.id == produit.id }) {
                                session.produits[index].quantite = quantite
                                gestionnaire.mettreAJourSession(session)
                            }
                            afficherModificationQuantite = false
                            nouvelleQuantite = ""
                        },
                        onAnnuler: {
                            afficherModificationQuantite = false
                            nouvelleQuantite = ""
                        }
                    )
                }

                if afficherSaisieArticle {
                    OverlayAjoutArticle(
                        nomArticle: $nouvelArticleSaisi,
                        onAjouter: {
                            if !nouvelArticleSaisi.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                ajouterProduit(nouvelArticleSaisi)
                            }
                            afficherSaisieArticle = false
                            nouvelArticleSaisi = ""
                        },
                        onAnnuler: {
                            afficherSaisieArticle = false
                            nouvelArticleSaisi = ""
                        }
                    )
                }
            }
        )
    }

    // MARK: - Fonctions internes

    private func ajouterProduit(_ nomProduit: String) {
        if let index = session.produits.firstIndex(where: { $0.nom == nomProduit }) {
            session.produits[index].quantite += 1
        } else {
            let produit = ProduitStock(nom: nomProduit, quantite: 1, categorie: categorieSelectionnee)
            session.produits.append(produit)
        }
        gestionnaire.mettreAJourSession(session)
    }

    private func supprimerProduit(_ produit: ProduitStock) {
        session.produits.removeAll { $0.id == produit.id }
        produitSelectionne = nil
        gestionnaire.mettreAJourSession(session)
    }

    private func terminerSession() {
        session.statut = .terminee
        gestionnaire.mettreAJourSession(session)
    }

    private func formaterDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
}
