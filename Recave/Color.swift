import SwiftUI

extension Color {
  

    /// Retourne .black ou .white selon la lisibilité
    func readableTextColor() -> Color {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        #if canImport(UIKit)
        if UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
            return brightness > 0.5 ? .black : .white
        }
        #endif
        return .white
    }
}
