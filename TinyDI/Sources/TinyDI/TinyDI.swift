//
//  TinyDI.swift
//
//
//  Created by Aleksandr Fedorov on 18.10.23.
//

import Foundation

public final class DIContainer {
        
    private var services: [ServiceKey: Any] = [:]
    private var serviceFactories: [ServiceKey: Any] = [:]
    
    public init() {}
    
    public func register<Service>(_ serviceType: Service.Type,
                                  name: String? = nil,
                                  factory: @escaping () -> Service) {
        
        let key = makeServiceKey(serviceType, name: name)
        services[key] = factory()
    }
    
    public func register<Service>(_ serviceType: Service.Type,
                                  name: String? = nil,
                                  factory: @escaping (DIContainer) -> Service) {
        
        let key = makeServiceKey(serviceType, name: name)
        services[key] = factory(self)
    }
    
    public func register<Service, Arg>(_ serviceType: Service.Type,
                                       name: String? = nil,
                                       factory: @escaping (Arg) -> Service) {
        
        let key = makeServiceKey(serviceType, name: name)
        serviceFactories[key] = factory
    }
    
    public func resolve<Service>(_ serviceType: Service.Type,
                                      name: String? = nil) -> Service? {
        
        let key = makeServiceKey(serviceType, name: name)
        return services[key] as? Service
    }
    
    public func resolve<Service, Arg>(_ serviceType: Service.Type,
                                      name: String? = nil,
                                      argument: Arg) -> Service {
        
        let key = makeServiceKey(serviceType, name: name)
        let factory = serviceFactories[key] as! ((Arg) -> Service)
        
        return factory(argument)
    }
    
    public func removeAll() {
        services.removeAll()
    }
    
    private func makeServiceKey<Service>(_ serviceType: Service.Type,
                                         name: String? = nil) -> ServiceKey {
        return ServiceKey(serviceType: serviceType,
                          name: name ?? String(describing: serviceType))
    }
}
