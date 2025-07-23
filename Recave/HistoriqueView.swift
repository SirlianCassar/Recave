import SwiftUI

struct HistoriqueView: View {
    @EnvironmentObject var gestionnaire: GestionnaireReapprovisionnement

    var body: some View {
        List {
            ForEach(gestionnaire.sessions) { session in
                NavigationLink(destination: VueReapprovisionnement(session: session)) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(formaterDate(session.date))
                                .font(.headline)
                            Spacer()
                            Text(session.statut.description)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(session.statut == .enCours ? Color.orange : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        Text("\(session.produits.count) produits")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        if !session.produits.isEmpty {
                            Text(session.produits.prefix(3).compactMap { $0.nom }.joined(separator: ", "))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        gestionnaire.supprimerSession(session)
                    } label: {
                        Label("Supprimer", systemImage: "trash")
                    }
                }
            }
        }
        .navigationTitle("Historique")
    }

    private func formaterDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date)
    }
}
