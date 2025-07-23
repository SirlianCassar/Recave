import SwiftUI

/// Vue d’accueil avec navigation vers les différentes fonctionnalités
struct MenuPrincipalView: View {
    @EnvironmentObject var gestionnaire: GestionnaireReapprovisionnement
    @State private var afficherAlerte = false
    @State private var sessionExistante: SessionReapprovisionnement?
    @State private var navigerVersReapprovisionnement = false

    @State private var tapCount = 0
    @State private var estEasterEggActif = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // MARK: - Logo et titre
                VStack(spacing: 8) {
                    Group {
                        if estEasterEggActif {
                            Text("🤮")
                        } else {
                            Image(systemName: "wineglass")
                                .foregroundColor(.blue)
                        }
                    }
                    .font(.system(size: 80))
                    .onTapGesture {
                        tapCount += 1
                        if estEasterEggActif {
                            estEasterEggActif = false
                            tapCount = 0
                        } else if tapCount == 4 {
                            estEasterEggActif = true
                            tapCount = 0
                        }
                    }

                    Text(estEasterEggActif ? "Brieg" : "Recave")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Gestion de réapprovisionnement")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)

                Spacer()

                // MARK: - Boutons principaux
                VStack(spacing: 20) {
                    Button(action: {
                        verifierSessionExistante()
                    }) {
                        BoutonPrincipal(titre: "Nouvelle Recave", icone: "plus.circle.fill", couleur: .blue)
                    }

                    NavigationLink(destination: HistoriqueView()) {
                        BoutonPrincipal(titre: "Historique", icone: "clock.fill", couleur: .green)
                    }

                    NavigationLink(destination: VueParametres()) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                            Text("Paramètres")
                        }
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                // MARK: - Footer
                Text("fait par Siri avec 💚")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 16)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .alert("Session existante", isPresented: $afficherAlerte) {
                Button("Rouvrir") {
                    navigerVersReapprovisionnement = true
                }
                Button("Nouvelle", role: .destructive) {
                    sessionExistante = gestionnaire.creerNouvelleSession()
                    navigerVersReapprovisionnement = true
                }
                Button("Annuler", role: .cancel) { }
            } message: {
                if let session = sessionExistante {
                    Text("Une session existe déjà pour aujourd'hui avec \(session.produits.count) produits. Voulez-vous la rouvrir ?")
                }
            }
            .navigationDestination(isPresented: $navigerVersReapprovisionnement) {
                VueReapprovisionnement(
                    session: sessionExistante ?? SessionReapprovisionnement(date: Date(), statut: .enCours, produits: [], dateCreation: Date())
                )
            }
        }
    }

    // MARK: - Vérifie si une session est déjà en cours pour aujourd'hui
    private func verifierSessionExistante() {
        if let session = gestionnaire.sessionAujourdhui() {
            sessionExistante = session
            afficherAlerte = true
        } else {
            sessionExistante = gestionnaire.creerNouvelleSession()
            navigerVersReapprovisionnement = true
        }
    }
}
