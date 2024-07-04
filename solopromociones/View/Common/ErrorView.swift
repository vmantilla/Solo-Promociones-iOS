import SwiftUI

struct ErrorView: View {
    let message: String
    let imageName: String = "exclamationmark.triangle.fill" // Puedes cambiar esto a una imagen personalizada si tienes una

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding(.bottom, 20)
            Text(message)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "Ha ocurrido un error. Estamos trabajando para solucionarlo.")
    }
}
