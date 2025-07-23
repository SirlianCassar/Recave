// MARK: - Modèles de données

import Foundation

/// Représente une session de réapprovisionnement
struct SessionReapprovisionnement: Identifiable, Codable {
    var id: UUID
    var date: Date
    var statut: StatutSession
    var produits: [ProduitStock]
    let dateCreation: Date

    init(date: Date, statut: StatutSession, produits: [ProduitStock], dateCreation: Date) {
        self.id = UUID()
        self.date = date
        self.statut = statut
        self.produits = produits
        self.dateCreation = dateCreation
    }

    enum StatutSession: String, Codable, CaseIterable {
        case enCours = "en_cours"
        case terminee = "terminee"

        var description: String {
            switch self {
            case .enCours: return "En cours"
            case .terminee: return "Terminée"
            }
        }
    }
}

/// Représente un produit ajouté à une session
struct ProduitStock: Identifiable, Codable {
    var id: UUID
    var nom: String
    var quantite: Int
    var categorie: String

    init(nom: String, quantite: Int, categorie: String) {
        self.id = UUID()
        self.nom = nom
        self.quantite = quantite
        self.categorie = categorie
    }
}

/// Représente une catégorie personnalisée d’articles
struct CategoriePersonnalisee: Identifiable, Codable {
    var id: UUID
    var nom: String
    var articles: [String]

    init(nom: String, articles: [String] = []) {
        self.id = UUID()
        self.nom = nom
        self.articles = articles
    }
}
