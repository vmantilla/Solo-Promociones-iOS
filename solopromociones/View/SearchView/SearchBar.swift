import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @State var isKeyboardEnabled = true
    @FocusState private var isFocused: Bool

    var shouldFocus: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Buscar productos", text: $text)
                .focused($isFocused)
                .disabled(!isKeyboardEnabled)
                .onAppear {
                    if shouldFocus && isKeyboardEnabled {
                        isFocused = true
                    }
                }
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

#Preview {
    SearchBar(text: .constant(""), shouldFocus: true)
}
