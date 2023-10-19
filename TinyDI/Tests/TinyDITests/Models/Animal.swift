//
//  File.swift
//  
//
//  Created by Aleksandr Fedorov on 19.10.23.
//

import Foundation

class Animal: Equatable {
    let id = UUID()
    let name: String?
    let house: House?
    
    init(name: String? = nil, house: House? = nil) {
        self.name = name
        self.house = house
    }
    
    static func == (lhs: Animal, rhs: Animal) -> Bool {
        return lhs.id == rhs.id
    }
}
