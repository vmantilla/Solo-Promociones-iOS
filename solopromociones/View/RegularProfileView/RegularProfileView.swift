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
                    
                    PaymentView(selectedSpots: selectedSpots, onPaymentComplete: completeConversion)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut)
                .transition(.slide)
                
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
                        Text("\(spots) spot\(spots > 1 ? "s" : "")")
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
    let onPaymentComplete: () -> Void
    @State private var cardNumber = ""
    @State private var expirationDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var isProcessingPayment = false
    @State private var showingSuccessMessage = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Form {
                Section(header: Text("Detalles de la Tarjeta")) {
                    TextField("Número de Tarjeta", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Fecha de Expiración (MM/YY)", text: $expirationDate)
                        .keyboardType(.numberPad)
                    TextField("CVV", text: $cvv)
                        .keyboardType(.numberPad)
                    TextField("Nombre del Titular", text: $cardholderName)
                }
                
                Section {
                    Button(action: processPayment) {
                        Text("Pagar")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(isProcessingPayment)
                }
            }
            .blur(radius: isProcessingPayment ? 3 : 0)
            
            if isProcessingPayment {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Procesando pago...")
                        .font(.headline)
                        .padding()
                }
                .frame(width: 200, height: 200)
                .background(Color.white.opacity(0.8))
                .cornerRadius(20)
                .shadow(radius: 10)
            }
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
    }
    
    func processPayment() {
        isProcessingPayment = true
        
        // Simulamos un proceso de pago que toma 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessingPayment = false
            showingSuccessMessage = true
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
