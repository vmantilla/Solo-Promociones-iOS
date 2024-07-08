import SwiftUI

struct CategoryFilterButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? Color.blue.opacity(0.2) : Color.white)
                        .frame(width: 50, height: 50)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : category.color, lineWidth: 2)
                        .frame(width: 54, height: 54)
                    
                    Image(systemName: category.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(isSelected ? .blue : category.color)
                }
                
                Text(category.name)
                    .font(.system(size: 10))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: 80)
            }
            .frame(height: 110)
        }
    }
}
