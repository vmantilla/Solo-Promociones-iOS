import SwiftUI
import CachedAsyncImage


struct TooGoodToGoView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    SearchBar(text: $searchText, shouldFocus: false)
                    
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

struct TooGoodToGoView_Previews: PreviewProvider {
    static var previews: some View {
        TooGoodToGoView()
    }
}
