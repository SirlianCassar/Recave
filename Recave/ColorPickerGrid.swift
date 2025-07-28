import SwiftUI

struct ColorPickerGrid: View {
    @Binding var selectedColor: String?

    let colors: [String] = [
        "#F44336", "#E91E63", "#9C27B0", "#673AB7", "#3F51B5",
        "#2196F3", "#03A9F4", "#00BCD4", "#009688", "#4CAF50",
        "#8BC34A", "#CDDC39", "#FFEB3B", "#FFC107", "#FF9800",
        "#FF5722", "#795548", "#9E9E9E", "#607D8B", "#000000"
    ]

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5)) {
            ForEach(colors, id: \.self) { hex in
                Circle()
                    .fill(Color(hex: hex))
                    .frame(width: 34, height: 34)
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white, lineWidth: selectedColor == hex ? 3 : 0)
                    )
                    .onTapGesture {
                        selectedColor = hex
                    }
            }
        }
        .padding(.horizontal)
    }
}
