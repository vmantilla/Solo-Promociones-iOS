import SwiftUI

struct ErrorView: View {
    let message: String
    let imageName: String = "exclamationmark.triangle"
    let webURL: URL?
    
    init(message: String, webURL: URL? = nil) {
        self.message = message
        self.webURL = webURL
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.orange)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            if let webURL = webURL {
                Button(action: {
                    UIApplication.shared.open(webURL)
                }) {
                    Text("Visita nuestra web")
                        .foregroundColor(.blue)
                        .underline()
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .padding()
    }
}
