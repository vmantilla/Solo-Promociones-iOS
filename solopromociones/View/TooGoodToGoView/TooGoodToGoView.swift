import SwiftUI
import CachedAsyncImage

struct TooGoodToGoView: View {
    @StateObject private var viewModel = ProductViewModel()
    @State private var searchText = ""
    @State private var selectedCategory: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    SearchBar(text: $searchText, shouldFocus: false)
                        .opacity(0.8)
                    
                    CategoryScrollView(categories: viewModel.categories, selectedCategory: $selectedCategory)
                    
                    ExplanationText()
                    
                    LazyVStack(spacing: 12) {
                        ForEach(filteredProducts()) { product in
                            ProductCard(product: product)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Eco Ofertas")
            .navigationBarTitleDisplayMode(.inline)
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
            HStack(spacing: 10) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = selectedCategory == category ? nil : category
                    }) {
                        Text(category)
                            .font(.footnote)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedCategory == category ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                            .foregroundColor(selectedCategory == category ? .blue : .primary)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
}

struct ExplanationText: View {
    var body: some View {
        Text("Estos productos están cerca de su fecha de caducidad o son considerados demasiado valiosos para desechar. ¡Aprovecha estas ofertas y ayuda a reducir el desperdicio!")
            .font(.caption2)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                CachedAsyncImage(url: URL(string: product.imageURL)) { image in
                    image.resizable().aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 80, height: 80)
                .cornerRadius(6)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(product.storeName)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(product.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(product.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Precio original: \(product.originalPrice, specifier: "%.2f")€")
                        .strikethrough()
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text("Precio Eco: \(product.discountedPrice, specifier: "%.2f")€")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Recoger antes de:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(product.expirationDate, style: .time)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                }
            }
            
            HStack {
                Image(systemName: "location")
                    .font(.caption2)
                Text("\(product.distance, specifier: "%.1f") km")
                    .font(.caption2)
                Spacer()
                Text(product.category)
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(4)
            }
            .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct TooGoodToGoView_Previews: PreviewProvider {
    static var previews: some View {
        TooGoodToGoView()
    }
}
