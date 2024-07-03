//
//  MerchantFlowView.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

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
