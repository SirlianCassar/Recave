import SwiftUI

struct VueEditionArticle: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var quantity: Int = 1
    @State private var selectedColor: String? = nil

    var item: StockItem?

    var body: some View {
        Form {
            Section(header: Text("Article")) {
                TextField("Nom", text: $name)
                Stepper("Quantité : \(quantity)", value: $quantity, in: 0...999)
            }

            Section(header: Text("Couleur")) {
                ColorPickerGrid(selectedColor: $selectedColor)

                if let hex = selectedColor {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: hex))
                            .frame(height: 50)
                        Text("Aperçu")
                            .foregroundColor(Color(hex: hex).readableTextColor())
                            .bold()
                    }
                }
            }

            Button("Enregistrer") {
                save()
                dismiss()
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(item == nil ? "Nouvel Article" : "Modifier Article")
        .onAppear {
            if let item = item {
                name = item.name ?? ""
                quantity = Int(item.quantity)
                selectedColor = item.colorHex
            }
        }
    }

    func save() {
        let article = item ?? StockItem(context: viewContext)
        article.name = name
        article.quantity = Int16(quantity)
        article.colorHex = selectedColor

        do {
            try viewContext.save()
        } catch {
            print("Erreur de sauvegarde : \(error)")
        }
    }
}
