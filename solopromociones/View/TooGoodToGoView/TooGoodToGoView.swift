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
    let distance: Double
}

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = [
        Product(id: "1", title: "Pan Artesanal", description: "Baguette recién horneada", expirationDate: Date().addingTimeInterval(3600), originalPrice: 2.50, discountedPrice: 1.25, imageURL: "https://example.com/bread.jpg", category: "Panadería", storeName: "Panadería Aurora", storeLogoURL: "https://example.com/aurora-logo.jpg", distance: 0.5),
        Product(id: "2", title: "Ensalada César", description: "Ensalada fresca con pollo y aderezo", expirationDate: Date().addingTimeInterval(7200), originalPrice: 8.99, discountedPrice: 4.50, imageURL: "https://example.com/salad.jpg", category: "Comida Preparada", storeName: "Deli Express", storeLogoURL: "https://example.com/deli-logo.jpg", distance: 1.2),
        Product(id: "3", title: "Yogur Griego", description: "Pack de 4 yogures naturales", expirationDate: Date().addingTimeInterval(86400), originalPrice: 3.99, discountedPrice: 2.00, imageURL: "https://example.com/yogurt.jpg", category: "Lácteos", storeName: "Supermercado Fresco", storeLogoURL: "https://example.com/fresco-logo.jpg", distance: 0.8),
        Product(id: "4", title: "Sushi Variado", description: "Bandeja de 12 piezas variadas", expirationDate: Date().addingTimeInterval(10800), originalPrice: 15.99, discountedPrice: 8.00, imageURL: "https://example.com/sushi.jpg", category: "Comida Preparada", storeName: "Sushi Fusion", storeLogoURL: "https://example.com/sushi-logo.jpg", distance: 2.5),
        Product(id: "5", title: "Manzanas Orgánicas", description: "Bolsa de 1kg de manzanas frescas", expirationDate: Date().addingTimeInterval(172800), originalPrice: 4.50, discountedPrice: 2.25, imageURL: "https://example.com/apples.jpg", category: "Frutas y Verduras", storeName: "Mercado Ecológico", storeLogoURL: "https://example.com/eco-logo.jpg", distance: 1.7),
        Product(id: "6", title: "Pizza Margarita", description: "Pizza mediana recién horneada", expirationDate: Date().addingTimeInterval(5400), originalPrice: 10.99, discountedPrice: 5.50, imageURL: "https://example.com/pizza.jpg", category: "Comida Preparada", storeName: "Pizzería Bella", storeLogoURL: "https://example.com/bella-logo.jpg", distance: 1.0),
        Product(id: "7", title: "Croissants", description: "Pack de 3 croissants de mantequilla", expirationDate: Date().addingTimeInterval(21600), originalPrice: 3.75, discountedPrice: 1.90, imageURL: "https://example.com/croissants.jpg", category: "Panadería", storeName: "Panadería Aurora", storeLogoURL: "https://example.com/aurora-logo.jpg", distance: 0.5),
        Product(id: "8", title: "Leche Desnatada", description: "Botella de 1L de leche fresca", expirationDate: Date().addingTimeInterval(259200), originalPrice: 1.20, discountedPrice: 0.80, imageURL: "https://example.com/milk.jpg", category: "Lácteos", storeName: "Supermercado Fresco", storeLogoURL: "https://example.com/fresco-logo.jpg", distance: 0.8),
        Product(id: "9", title: "Hamburguesa Vegana", description: "Hamburguesa de soja con pan integral", expirationDate: Date().addingTimeInterval(14400), originalPrice: 7.50, discountedPrice: 3.75, imageURL: "https://example.com/vegan-burger.jpg", category: "Comida Preparada", storeName: "Veggie Delight", storeLogoURL: "https://example.com/veggie-logo.jpg", distance: 3.0),
        Product(id: "10", title: "Tomates Cherry", description: "Bandeja de 250g de tomates cherry", expirationDate: Date().addingTimeInterval(129600), originalPrice: 2.99, discountedPrice: 1.50, imageURL: "https://example.com/tomatoes.jpg", category: "Frutas y Verduras", storeName: "Mercado Ecológico", storeLogoURL: "https://example.com/eco-logo.jpg", distance: 1.7)
    ]
    
    var categories: [String] {
        Array(Set(products.map { $0.category })).sorted()
    }
}

struct TooGoodToGoView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    SearchBar(text: $searchText)
                    
                    CategoryScrollView(categories: viewModel.categories, selectedCategory: $selectedCategory)
                    
                    ExplanationText()
                    
                    LazyVStack(spacing: 16) {
                        ForEach(filteredProducts()) { product in
                            ProductCard(product: product)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Eco Ofertas")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemBackground))
        }
    }
    
    private func filteredProducts() -> [Product] {
        viewModel.products.filter { product in
            (searchText.isEmpty || product.title.localizedCaseInsensitiveContains(searchText)) &&
            (selectedCategory == nil || product.category == selectedCategory)
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
    }
}

struct CategoryScrollView: View {
    let categories: [String]
    @Binding var selectedCategory: String?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = selectedCategory == category ? nil : category
                    }) {
                        Text(category)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
        }
    }
}

struct ExplanationText: View {
    var body: some View {
        Text("Estos productos están cerca de su fecha de caducidad o son considerados demasiado valiosos para desechar. ¡Aprovecha estas ofertas y ayuda a reducir el desperdicio!")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
}

// El ProductCard permanece igual

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

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct TooGoodToGoView_Previews: PreviewProvider {
    static var previews: some View {
        TooGoodToGoView()
    }
}
