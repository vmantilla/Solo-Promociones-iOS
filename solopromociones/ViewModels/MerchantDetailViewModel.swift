//
//  MerchantDetailViewModel.swift
//  solopromociones
//
//  Created by RAVIT Admin on 3/07/24.
//

import Foundation
import Combine

class MerchantDetailViewModel: ObservableObject {
    @Published var merchant: MerchantDetail?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isFavorite = false

    private let merchantId: String
    private var cancellables = Set<AnyCancellable>()
    
    init(merchantId: String) {
        self.merchantId = merchantId
        loadMerchantDetail()
    }
    
    func loadMerchantDetail() {
        isLoading = true
        error = nil
        
        // Simulación de una llamada a API cargando datos del archivo JSON
        guard let url = Bundle.main.url(forResource: "merchantDetail", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Failed to load merchant detail data.")
            isLoading = false
            return
        }

        let decoder = JSONDecoder()
        if let jsonData = try? decoder.decode(MerchantDetail.self, from: data) {
            self.merchant = jsonData
            isLoading = false
        } else {
            isLoading = false
            error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode merchant detail data"])
        }
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        // Aquí puedes agregar la lógica para guardar el estado de favorito en tu base de datos o servidor
    }
    
    func openInMaps() {
        // Aquí puedes agregar la lógica para abrir la ubicación en Maps
    }
}

