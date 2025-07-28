import Foundation
import SwiftUI

/// Classe qui gère les sessions, les sauvegardes, et les catégories personnalisées
class GestionnaireReapprovisionnement: ObservableObject {
    @Published var sessions: [SessionReapprovisionnement] = []
    @Published var categoriesPersonnalisees: [CategoriePersonnalisee] = []
    @Published var couleursPersonnalisees: [String: String] = [:]

    private let cleUserDefaults = "sessions_reapprovisionnement"
    private let cleCategories = "categories_personnalisees"
    private let cleCouleurs = "couleurs_articles"

    /// Toutes les catégories utilisées dans l'app
    var toutesCategories: [CategoriePersonnalisee] {
        return categoriesPersonnalisees
    }

    init() {
        chargerSessions()
        chargerCategories()
        chargerCouleurs()

        // Ajout initial des catégories par défaut si aucune catégorie sauvegardée
        if categoriesPersonnalisees.isEmpty {
            categoriesPersonnalisees = [
                CategoriePersonnalisee(nom: "Canettes", articles: ["Coca-Cola","Coca-Cola Zero","Fanta","Orangina","Perrier","Fuze Tea","Schweppes Agrumes","Schweppes Tonic","Oasis"]),
                CategoriePersonnalisee(nom: "Jus de Fruits", articles: ["Pomme","Orange","Abricot","Ananas","Fraise","Mangue","Multifruits","Passion","Banane","Pamplemouse","Tomate"]),
                CategoriePersonnalisee(nom: "Sirops", articles: ["Fraise","Grenadine","Framboise","Cassis","Cerise","Menthe","Citron","Passion","Orgeat","Banane","Kiwi","Pêche","Violette","Pastèque","Coco","Gingembre","Vanille","Caramel","Noisette"]),
                CategoriePersonnalisee(nom: "Bouteilles", articles: ["Coca","Perrier","Symples Detox","Symples Relax","Symples Energie","Maté","Ginger Beer","Plancoët Gazeuse","Cidre","Bière Zéro"]),
                CategoriePersonnalisee(nom: "Chaud", articles: ["Café","Déca","Sucrettes","Spéculos","Lait","Lait d'Avoine","Miel"]),
                CategoriePersonnalisee(nom: "Alcools", articles: ["Rhum","Vodka","Gin","Ricard","Tequila"]),
                CategoriePersonnalisee(nom: "Vins", articles: ["Faugère","Saint Nicolas","Blaye","Elégance","Sauvignon","Chardonnay","Tendresse","Cheverny","Rosé"]),
                CategoriePersonnalisee(nom: "Autres", articles: ["Serviettes","Pailles","Gobelets"])
            ]
            sauvegarderCategories()
        }

        // Si aucune couleur n'est sauvegardée, injecter la palette par défaut
        if couleursPersonnalisees.isEmpty {
            couleursPersonnalisees = [ // Canettes
                "Coca-Cola": "#FF3B30",
                "Coca-Cola Zero": "#000000",
                "Fanta": "#FFA500",
                "Orangina": "#FF9500",
                "Perrier": "#34C759",
                "Fuze Tea": "#A3D977",
                "Schweppes Agrumes": "#FFD60A",
                "Schweppes Tonic": "#FFE55C",
                "Oasis": "#FF2D55",

                // Jus de Fruits
                "Pomme": "#A3C72D",
                "Orange": "#FF9500",
                "Abricot": "#F8A055",
                "Ananas": "#FFE162",
                "Fraise": "#FF3B30",
                "Mangue": "#FFB347",
                "Multifruits": "#DA70D6",
                "Passion": "#FFCC00",
                "Banane": "#FFF275",
                "Pamplemouse": "#FF6F61",
                "Tomate": "#D81F26",

                // Sirops
                "Grenadine": "#C2185B",
                "Framboise": "#E91E63",
                "Cassis": "#8E24AA",
                "Cerise": "#D32F2F",
                "Menthe": "#26A69A",
                "Citron": "#FFEB3B",
                "Orgeat": "#FFF8E1",
                "Kiwi": "#A3D977",
                "Pêche": "#FFB347",
                "Violette": "#9C27B0",
                "Pastèque": "#FF6F91",
                "Coco": "#E0E0E0",
                "Gingembre": "#D4AF37",
                "Vanille": "#F5DEB3",
                "Caramel": "#C49E6C",
                "Noisette": "#A0522D",

                // Bouteilles
                "Coca": "#FF3B30",
                "Symples Detox": "#00C7BE",
                "Symples Relax": "#8E8E93",
                "symples Energie": "#FF9500",
                "Maté": "#8BC34A",
                "Ginger Beer": "#D2691E",
                "Plancoët Gazeuse": "#00BFFF",
                "Cidre": "#FFD700",
                "Bière Zéro": "#F4A460",

                // Chaud
                "Café": "#4E342E",
                "Déca": "#6D4C41",
                "Sucrettes": "#FFF",
                "Spéculos": "#D2691E",
                "Lait": "#FAFAFA",
                "Lait d'Avoine": "#EDE7F6",
                "Miel": "#FFC107",

                // Alcools
                "Rhum": "#A0522D",
                "Vodka": "#E0E0E0",
                "Gin": "#ADD8E6",
                "Ricard": "#FFDE59",
                "Tequila": "#F5A623",

                // Vins
                "Faugère": "#8B0000",
                "Saint Nicolas": "#B22222",
                "Blaye": "#A52A2A",
                "Elégance": "#DAA520",
                "Sauvignon": "#F5DEB3",
                "Chardonnay": "#FFE4B5",
                "Tendresse": "#FFDAB9",
                "Cheverny": "#D2B48C",
                "Rosé": "#FFC0CB",

                // Autres
                "Serviettes": "#DCDCDC",
                "Pailles": "#C0C0C0",
                "Gobelets": "#B0BEC5"
                // ... tes couleurs déjà présentes (tu peux les coller ici si tu veux toutes les récupérer)
            ]
            sauvegarderCouleurs()
        }
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

    // MARK: - Gestion des catégories

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

    // MARK: - Gestion des couleurs

    func couleurPourArticle(_ nom: String) -> String {
        couleursPersonnalisees[nom] ?? "#007AFF"
    }

    func definirCouleur(_ hex: String, pour article: String) {
        couleursPersonnalisees[article] = hex
        sauvegarderCouleurs()
    }

    func sauvegarderCouleurs() {
        if let donnees = try? JSONEncoder().encode(couleursPersonnalisees) {
            UserDefaults.standard.set(donnees, forKey: cleCouleurs)
        }
    }

    func chargerCouleurs() {
        if let donnees = UserDefaults.standard.data(forKey: cleCouleurs),
           let couleursChargees = try? JSONDecoder().decode([String: String].self, from: donnees) {
            self.couleursPersonnalisees = couleursChargees
        }
    }
}
