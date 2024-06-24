//
//  AddPromotionCell.swift
//  solopromociones
//
//  Created by RAVIT Admin on 24/06/24.
//

import SwiftUI

struct AddPromotionCell: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: "plus.circle")
                    .font(.system(size: 40))
                Text("Agregar")
                    .font(.caption)
            }
            .frame(width: 150, height: 150)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .foregroundColor(.primary)
    }
}


struct AddPromotionCell_Previews: PreviewProvider {
    static var previews: some View {
        AddPromotionCell(action: {
            
        })
    }
}
