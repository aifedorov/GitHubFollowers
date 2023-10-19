//
//  ServiceKey.swift
//
//
//  Created by Aleksandr Fedorov on 18.10.23.
//

import Foundation

internal struct ServiceKey {
    internal let serviceType: Any.Type
    internal let name: String
    
    internal init(serviceType: Any.Type, name: String) {
        self.serviceType = serviceType
        self.name = name
    }
}

extension ServiceKey: Equatable {
    static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        return lhs.serviceType == rhs.serviceType && lhs.name == rhs.name
    }
}

extension ServiceKey: Hashable {
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(serviceType).hash(into: &hasher)
        name.hash(into: &hasher)
    }
}
