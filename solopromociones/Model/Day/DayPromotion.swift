//
//  DayPromotion.swift
//  solopromociones
//
//  Created by Ravit dev on 4/07/24.
//

import Foundation

struct DayPromotion: Identifiable, Codable {
    var id: String { day }
    var day: String
    var date: String
    var categories: [Category]
    
    var formattedDay: String {
        return day
    }
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if let date = dateFormatter.date(from: self.date) {
            dateFormatter.dateFormat = "d"
            return dateFormatter.string(from: date)
        }
        return date
    }
}
