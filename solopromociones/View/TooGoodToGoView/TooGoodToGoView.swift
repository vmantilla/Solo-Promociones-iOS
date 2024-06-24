import SwiftUI
import CachedAsyncImage

struct Product: Identifiable {
    let id: String
    let title: String
    let description: String
    let expirationDate: Date
    let originalPrice: Double
    let discountedPrice: Double
    let imageURL: String
    let category: String
    let storeName: String
    let storeLogoURL: String
    let distance: Double // en kilómetros
}

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = [
        Product(id: "1", title: "Pan fresco", description: "Baguette recién horneada", expirationDate: Date().addingTimeInterval(3600), originalPrice: 2.0, discountedPrice: 1.0, imageURL: "https://example.com/bread.jpg", category: "Panadería", storeName: "Panadería Central", storeLogoURL: "https://example.com/bakery-logo.jpg", distance: 0.5),
        Product(id: "2", title: "Ensalada César", description: "Ensalada fresca con pollo", expirationDate: Date().addingTimeInterval(7200), originalPrice: 8.0, discountedPrice: 5.0, imageURL: "https://example.com/salad.jpg", category: "Comida preparada", storeName: "Deli Express", storeLogoURL: "https://example.com/deli-logo.jpg", distance: 1.2)
    ]
}

struct TooGoodToGoView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredProducts()) { product in
                            ProductCard(product: product)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Eco Ofertas")
        }
    }
    
    private func filteredProducts() -> [Product] {
        viewModel.products.filter { product in
            searchText.isEmpty || product.title.localizedCaseInsensitiveContains(searchText)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Buscar productos", text: $text)
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                CachedAsyncImage(url: URL(string: product.imageURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 100, height: 100)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.storeName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(product.title)
                        .font(.headline)
                    Text(product.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Precio original: \(product.originalPrice, specifier: "%.2f")€")
                        .strikethrough()
                        .foregroundColor(.secondary)
                    Text("Precio Eco: \(product.discountedPrice, specifier: "%.2f")€")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Recoger antes de:")
                    Text(product.expirationDate, style: .time)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                Image(systemName: "location")
                Text("\(product.distance, specifier: "%.1f") km")
                Spacer()
                Text(product.category)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct TooGoodToGoView_Previews: PreviewProvider {
    static var previews: some View {
        TooGoodToGoView()
    }
}
