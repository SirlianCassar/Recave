import SwiftUI

/// Affiche le logo clair ou sombre selon le mode du système
struct LogoAdaptatif: View {
    @Environment(\.colorScheme) var scheme

    var body: some View {
        Image(scheme == .dark ? "LogoRecaveSombre" : "LogoRecaveClair")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 120, height: 120)
    }
}
