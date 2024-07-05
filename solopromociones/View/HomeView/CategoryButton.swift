import SwiftUI
import CachedAsyncImage

struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let useIcons: Bool // Flag to toggle between icons and web images
    let action: () -> Void
    
    private func colorForCategory(_ category: Category) -> Color {
        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink]
        let index = abs(category.id.hashValue) % colors.count
        return colors[index]
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.blue.opacity(0.2) : Color.white)
                        .frame(width: isSelected ? 100 : 80, height: isSelected ? 120 : 100)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : colorForCategory(category), lineWidth: 2)
                        .frame(width: isSelected ? 104 : 84, height: isSelected ? 124 : 104)
                    
                    VStack {
                        if useIcons {
                            Image(systemName: category.iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(isSelected ? .blue : colorForCategory(category))
                        } else {
                            CachedAsyncImage(url: URL(string: getRandomImageURL())) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(isSelected ? .blue : colorForCategory(category))
                                case .failure:
                                    Image(systemName: "xmark.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.red)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        Text(category.name)
                            .font(.caption2)
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: 70) // Adjusted width
                    }
                    .padding(.vertical, 10) // Added padding
                }
            }
            .frame(height: 130) // Adjusted height
        }
    }
    
    private func getRandomImageURL() -> String {
        let imageSize = 100
        let randomInt = Int.random(in: 1...10)
        return "https://dummyimage.com/\(imageSize)x\(imageSize)/000/fff&text=\(randomInt)"
    }
}
