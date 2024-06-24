import SwiftUI
import CachedAsyncImage

struct Product: Identifiable {
    let id: String
    let title: String
    let description: String
    let expirationDate: String
    let price: String
    let imageURL: String
    let category: String
}

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = [
        Product(id: "1", title: "Pan Fresco", description: "Pan fresco a punto de expirar", expirationDate: "24/06/2024", price: "$1.00", imageURL: "https://dummyimage.com/600x400/000/fff", category: "Comida"),
        Product(id: "2", title: "Laptop Reciclada", description: "Laptop en buen estado", expirationDate: "N/A", price: "$100.00", imageURL: "https://dummyimage.com/600x400/000/fff", category: "Tecnología")
    ]
}

struct TooGoodToGoView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: String?

    var body: some View {
        NavigationView {
            VStack {
                // Barra de búsqueda
                TextField("Buscar productos", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top)

                // Filtros de categoría
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(getUniqueCategories(), id: \.self) { category in
                            CategoryFilterButton(category: category,
                                                 isSelected: selectedCategory == category, useIcons: true,
                                                 action: {
                                selectedCategory = (selectedCategory == category) ? nil : category
                            })
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                
                // Lista de productos
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(filteredProducts(), id: \.id) { product in
                            ProductCell(product: product)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Too Good To Go")
        }
    }
    
    private func getUniqueCategories() -> [String] {
        let categories = viewModel.products.map { $0.category }
        return Array(Set(categories)).sorted()
    }
    
    private func filteredProducts() -> [Product] {
        viewModel.products.filter { product in
            (selectedCategory == nil || product.category == selectedCategory) &&
            (searchText.isEmpty || product.title.localizedCaseInsensitiveContains(searchText))
        }
    }
}

struct ProductCell: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            CachedAsyncImage(url: URL(string: product.imageURL), transaction: .init(animation: .default)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(colorForCategory(product.category), lineWidth: 2)
                        )
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(product.title)
                .font(.headline)
                .foregroundColor(colorForCategory(product.category))
            Text(product.description)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack {
                Text("Caduca: \(product.expirationDate)")
                    .font(.caption)
                Spacer()
                Text(product.price)
                    .font(.caption)
                    .bold()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
        .padding(.bottom, 10)
    }
}

struct TooGoodToGoView_Previews: PreviewProvider {
    static var previews: some View {
        TooGoodToGoView()
    }
}
