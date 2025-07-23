// MARK: - GestionnaireReapprovisionnement (ObservableObject principal)

import Foundation
import SwiftUI

/// Classe qui gère les sessions, les sauvegardes, et les catégories personnalisées
class GestionnaireReapprovisionnement: ObservableObject {
    @Published var sessions: [SessionReapprovisionnement] = []
    @Published var categoriesPersonnalisees: [CategoriePersonnalisee] = []

    private let cleUserDefaults = "sessions_reapprovisionnement"
    private let cleCategories = "categories_personnalisees"

    /// Catégories par défaut non modifiables
    let categoriesParDefaut = [
        CategoriePersonnalisee(nom: "Canettes", articles: ["Coca-Cola","Coca-Cola Zero","Fanta","Orangina","Perrier","Fuze Tea","Schweppes Agrumes","Schweppes Tonic","Oasis"]),
        CategoriePersonnalisee(nom: "Jus de Fruits", articles: ["Pomme","Orange","Abricot","Ananas","Fraise","Mangue","Multifruits","Passion","Banane","Pamplemouse","Tomate"]),
        CategoriePersonnalisee(nom: "Sirops", articles: ["Fraise","Grenadine","Framboise","Cassis","Cerise","Menthe","Citron","Passion","Orgeat","Banane","Kiwi","Pêche","Violette","Pastèque","Coco","Gingembre","Vanille","Caramel","Noisette"]),
        CategoriePersonnalisee(nom: "Bouteilles", articles: ["Coca","Perrier","Symples Detox","Symples Relax","symples Energie","Maté","Ginger Beer","Plancoët Gazeuse","Cidre","Bière Zéro"]),
        CategoriePersonnalisee(nom: "Chaud", articles: ["Café","Déca","Sucrettes","Spéculos","Lait","Lait d'Avoine","Miel"]),
        CategoriePersonnalisee(nom: "Alcools", articles: ["Rhum","Vodka","Gin","Ricard","Tequila"]),
        CategoriePersonnalisee(nom: "Vins", articles: ["Faugère","Saint Nicolas","Blaye","Elégance","Sauvignon","Chardonnay","Tendresse","Cheverny","Rosé"]),
        CategoriePersonnalisee(nom: "Autres", articles: ["Serviettes","Pailles","Gobelets"])
    ]

    /// Toutes les catégories (par défaut + personnalisées)
    var toutesCategories: [CategoriePersonnalisee] {
        return categoriesParDefaut + categoriesPersonnalisees
    }

    init() {
        chargerSessions()
        chargerCategories()
    }

    // MARK: - Gestion des sessions

    func creerNouvelleSession() -> SessionReapprovisionnement {
        let nouvelleSession = SessionReapprovisionnement(
            date: Date(),
            statut: .enCours,
            produits: [],
            dateCreation: Date()
        )
        sessions.insert(nouvelleSession, at: 0)
        sauvegarderSessions()
        return nouvelleSession
    }

    func sessionAujourdhui() -> SessionReapprovisionnement? {
        let aujourd_hui = Calendar.current.startOfDay(for: Date())
        return sessions.first {
            Calendar.current.isDate($0.date, inSameDayAs: aujourd_hui) && $0.statut == .enCours
        }
    }

    func mettreAJourSession(_ session: SessionReapprovisionnement) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
            sauvegarderSessions()
        }
    }

    func sauvegarderSessions() {
        if let donnees = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(donnees, forKey: cleUserDefaults)
        }
    }

    func chargerSessions() {
        if let donnees = UserDefaults.standard.data(forKey: cleUserDefaults),
           let sessionsChargees = try? JSONDecoder().decode([SessionReapprovisionnement].self, from: donnees) {
            self.sessions = sessionsChargees
        }
    }
    func supprimerSession(_ session: SessionReapprovisionnement) {
        sessions.removeAll { $0.id == session.id }
        sauvegarderSessions()
    }
    


    // MARK: - Gestion des catégories personnalisées

    func ajouterCategorie(_ categorie: CategoriePersonnalisee) {
        categoriesPersonnalisees.append(categorie)
        sauvegarderCategories()
    }

    func supprimerCategorie(_ categorie: CategoriePersonnalisee) {
        categoriesPersonnalisees.removeAll { $0.id == categorie.id }
        sauvegarderCategories()
    }

    func mettreAJourCategorie(_ categorie: CategoriePersonnalisee) {
        if let index = categoriesPersonnalisees.firstIndex(where: { $0.id == categorie.id }) {
            categoriesPersonnalisees[index] = categorie
            sauvegarderCategories()
        }
    }

    func sauvegarderCategories() {
        if let donnees = try? JSONEncoder().encode(categoriesPersonnalisees) {
            UserDefaults.standard.set(donnees, forKey: cleCategories)
        }
    }

    func chargerCategories() {
        if let donnees = UserDefaults.standard.data(forKey: cleCategories),
           let categoriesChargees = try? JSONDecoder().decode([CategoriePersonnalisee].self, from: donnees) {
            self.categoriesPersonnalisees = categoriesChargees
        }
    }
}
