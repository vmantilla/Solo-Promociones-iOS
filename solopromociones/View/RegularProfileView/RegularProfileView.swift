import SwiftUI

struct RegularProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                Color.clear.preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named("scroll")).origin.y)
            }
            .frame(height: 0)
            
            VStack(spacing: 20) {
                // Profile Header
                HStack(alignment: .top, spacing: 20) {
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.user.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(viewModel.user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("Usuario")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingEditProfile = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // Stats
                HStack {
                    Spacer()
                    StatView(title: "Favoritos", value: "15")
                    Spacer()
                    StatView(title: "Reseñas", value: "8")
                    Spacer()
                    StatView(title: "Puntos", value: "350")
                    Spacer()
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // Favorite Merchants
                VStack(alignment: .leading, spacing: 10) {
                    Text("Comercios Favoritos")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(1...5, id: \.self) { _ in
                                FavoriteMerchantCell()
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                // Become a Merchant Banner
                BecomeAMerchantBanner(viewModel: viewModel)
            }
            .padding()
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingSettings = true
                }) {
                    Image(systemName: "gear")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle(scrollOffset < -50 ? viewModel.user.name : "")
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct FavoriteMerchantCell: View {
    var body: some View {
        VStack {
            Image(systemName: "storefront")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            Text("Tienda Ejemplo")
                .font(.caption)
        }
        .frame(width: 80, height: 80)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

import SwiftUI

struct BecomeAMerchantBanner: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingMerchantFlow = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("¿Tienes un negocio?")
                .font(.headline)
                .fontWeight(.bold)
            
            Text("Conviértete en comerciante y comienza a publicar tus promociones hoy mismo.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                showingMerchantFlow = true
            }) {
                Text("Convertirme en comerciante")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
        .fullScreenCover(isPresented: $showingMerchantFlow) {
            MerchantFlowView(viewModel: viewModel)
        }
    }
}

import SwiftUI

struct MerchantFlowView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var currentStep = 0
    @State private var businessName = ""
    @State private var businessAddress = ""
    @State private var businessPhone = ""
    @State private var selectedSpots = 0
    @State private var showingAlert = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer().frame(height: 20)
                TabView(selection: $currentStep) {
                    BusinessInfoView(businessName: $businessName, businessAddress: $businessAddress, businessPhone: $businessPhone)
                        .tag(0)
                    
                    SpotSelectionView(selectedSpots: $selectedSpots)
                        .tag(1)
                    
                    PaymentView(selectedSpots: selectedSpots, totalAmount: calculatePrice(for: selectedSpots), onPaymentComplete: completeConversion)
                                            .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
                .transition(.slide)
                .gesture(DragGesture())
                
                HStack {
                    if currentStep > 0 {
                        Button("Anterior") {
                            withAnimation {
                                currentStep -= 1
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if currentStep < 2 {
                        Button("Siguiente") {
                            if currentStep == 1 && selectedSpots == 0 {
                                showingAlert = true
                            } else {
                                withAnimation {
                                    currentStep += 1
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button("Cancelar") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Selección requerida"),
                    message: Text("Por favor, selecciona el número de spots antes de continuar."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    var navigationTitle: String {
        switch currentStep {
        case 0: return "Información del Negocio"
        case 1: return "Selección de Spots"
        case 2: return "Pago"
        default: return ""
        }
    }
    
    func completeConversion() {
        viewModel.convertToMerchant(with: selectedSpots)
        presentationMode.wrappedValue.dismiss()
    }
    
    func calculatePrice(for spots: Int) -> Int {
            switch spots {
            case 1: return 100
            case 3: return 270
            case 10: return 800
            case 20: return 1400
            default: return spots * 100
            }
        }
}

struct BusinessInfoView: View {
    @Binding var businessName: String
    @Binding var businessAddress: String
    @Binding var businessPhone: String
    
    var body: some View {
        Form {
            Section(header: Text("Información del Negocio")) {
                TextField("Nombre del Negocio", text: $businessName)
                TextField("Dirección", text: $businessAddress)
                TextField("Teléfono", text: $businessPhone)
                    .keyboardType(.phonePad)
            }
        }
    }
}

struct SpotSelectionView: View {
    @Binding var selectedSpots: Int
    
    let spotOptions = [1, 3, 10, 20]
    
    // Función para calcular el precio total basado en la cantidad de spots
    func calculatePrice(for spots: Int) -> Int {
        switch spots {
        case 1:
            return 100 // $100 por 1 spot
        case 3:
            return 270 // $90 por spot
        case 10:
            return 800 // $80 por spot
        case 20:
            return 1400 // $70 por spot
        default:
            return spots * 100 // Precio base por si se añaden más opciones en el futuro
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Selecciona el número de spots publicitarios:")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(spotOptions, id: \.self) { spots in
                Button(action: {
                    selectedSpots = spots
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(spots) spot\(spots > 1 ? "s" : "")")
                            Text("$\(calculatePrice(for: spots))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if selectedSpots == spots {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(selectedSpots == spots ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            
            Spacer()
            
            VStack(alignment: .center, spacing: 10) {
                Text("¿Necesitas más de 20 spots?")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                Text("Contáctanos por WhatsApp para opciones personalizadas")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button(action: openWhatsApp) {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Contactar por WhatsApp")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    func openWhatsApp() {
        if let whatsappURL = URL(string: "https://wa.me/573012107478") {
            UIApplication.shared.open(whatsappURL)
        }
    }
}

struct PaymentView: View {
    let selectedSpots: Int
    let totalAmount: Int
    let onPaymentComplete: () -> Void
    @State private var cardNumber = ""
    @State private var expirationDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var isProcessingPayment = false
    @State private var showingSuccessMessage = false
    @State private var agreedToTerms = false
    @State private var showingTerms = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Resumen de compra")
                    .font(.headline)
                
                Text("Spots seleccionados: \(selectedSpots)")
                Text("Total a pagar: $\(totalAmount)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Detalles de la Tarjeta")
                    .font(.headline)
                
                TextField("Número de Tarjeta", text: $cardNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                HStack {
                    TextField("MM/YY", text: $expirationDate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    TextField("CVV", text: $cvv)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                TextField("Nombre del Titular", text: $cardholderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Acepto los términos y condiciones", isOn: $agreedToTerms)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                    Button("Ver términos y condiciones") {
                        showingTerms = true
                    }
                    .foregroundColor(.blue)
                }
                
                Button(action: processPayment) {
                    Text("Pagar $\(totalAmount)")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(agreedToTerms ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!agreedToTerms)
            }
            .padding()
        }
        .alert(isPresented: $showingSuccessMessage) {
            Alert(
                title: Text("¡Felicidades!"),
                message: Text("Ya eres un merchant. Ahora puedes publicar promociones."),
                dismissButton: .default(Text("OK")) {
                    onPaymentComplete()
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .sheet(isPresented: $showingTerms) {
            TermsAndConditionsView(agreedToTerms: $agreedToTerms)
        }
        .overlay(
            ZStack {
                if isProcessingPayment {
                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Procesando pago...")
                            .font(.headline)
                            .padding(.top)
                    }
                    .frame(width: 200, height: 200)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
        )
    }
    
    func processPayment() {
        isProcessingPayment = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessingPayment = false
            showingSuccessMessage = true
        }
    }
}

struct TermsAndConditionsView: View {
    @Binding var agreedToTerms: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Términos y Condiciones")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("1. Uso del servicio")
                        .font(.headline)
                    Text("Al utilizar nuestro servicio, usted acepta cumplir con estos términos y condiciones...")
                    
                    Text("2. Responsabilidades del usuario")
                        .font(.headline)
                    Text("El usuario es responsable de mantener la confidencialidad de su cuenta...")
                    
                    Text("3. Política de privacidad")
                        .font(.headline)
                    Text("Nuestra política de privacidad describe cómo recopilamos y utilizamos la información...")
                    
                    // Añade más secciones según sea necesario
                    
                    Toggle("Acepto los términos y condiciones", isOn: $agreedToTerms)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding(.top)
                }
                .padding()
            }
            .navigationBarTitle("Términos y Condiciones", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct RegularProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RegularProfileView(viewModel: ProfileViewModel(user: User(id: "1", name: "Raul Mantilla", email: "rmantilla26@gmail.com", isMerchant: false)))
        }
    }
}
