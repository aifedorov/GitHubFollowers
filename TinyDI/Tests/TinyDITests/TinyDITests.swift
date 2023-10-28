import XCTest
@testable import TinyDI

final class TinyDITests: XCTestCase {
    
    private var container: DIContainer!

    override func setUpWithError() throws {
        container = DIContainer()
    }
    
    override func tearDownWithError() throws {
        container = nil
    }
    
    func testContainerWithoutRegistration() {
        let animalFromDI = container.resolve(Animal.self)
        XCTAssertNil(animalFromDI)
    }
    
    func testRegistrationWithoutArguments() {
        container.register(Animal.self) {
            Animal()
        }
        
        let animalFromDI = container.resolve(Animal.self)
        let animalForTest = Animal()
        
        guard let animalFromDI else { 
            XCTFail("Object instance is nil")
            return
        }
        
        XCTAssertEqual(String(describing: animalFromDI.self),
                       String(describing: animalForTest.self))
    }
    
    func testRegistrationWithArguments() {
        let animalName = "MyPet"
        
        container.register(Animal.self) {
            return Animal(name: animalName)
        }
        
        let animalFromDI = container.resolve(Animal.self)
        let animalForTest = Animal(name: animalName)
        
        guard let animalFromDI else { 
            XCTFail("Object instance is nil")
            return
        }
        
        XCTAssertEqual(animalFromDI.name,
                       animalForTest.name)
    }
        
    func testContainerResolvesTwoSomeTypeObjectsWithoutRegisteredName() {
        container.register(Animal.self) {
            return Animal()
        }
        container.register(Animal.self) {
            return Animal()
        }
        
        let animalFromDIOne = container.resolve(Animal.self)
        let animalFromDITwo = container.resolve(Animal.self)
        
        XCTAssertNotNil(animalFromDIOne)
        XCTAssertNotNil(animalFromDITwo)
        XCTAssert(animalFromDIOne === animalFromDITwo)
    }
    
    func testContainerResolvesByRegisteredName() {
        let animalNameOne = "MyPetOne"
        let animalNameTwo = "MyPetTwo"
        
        container.register(Animal.self, name: animalNameOne) { return Animal(name: animalNameOne) }
        container.register(Animal.self, name: animalNameTwo) { return Animal(name: animalNameTwo) }
        container.register(Animal.self) { return Animal() }
        
        let animalFromDIOne = container.resolve(Animal.self, name: animalNameOne)
        let animalFromDITwo = container.resolve(Animal.self, name: animalNameTwo)
        let animalFromDINoName = container.resolve(Animal.self)
        
        XCTAssertNotNil(animalFromDIOne)
        XCTAssertNotNil(animalFromDITwo)
        XCTAssertNotNil(animalFromDINoName)
        
        XCTAssertEqual(animalFromDIOne?.name, animalNameOne)
        XCTAssertEqual(animalFromDITwo?.name, animalNameTwo)
        XCTAssertNil(animalFromDINoName?.name)
    }
    
    func testContainerCanRemoveAllRegisteredServices() {
        let animalNameOne = "MyPetOne"
        let catName = "MyCat"
        
        container.register(Animal.self, name: animalNameOne) { return Animal() }
        container.register(Animal.self) { arg in Cat(name: arg) }
        container.removeAll()
        
        let animalFromDIOne = container.resolve(Animal.self, name: animalNameOne)
        let animalFromDITwo = container.resolve(Animal.self, argument: catName)

        XCTAssertNil(animalFromDIOne)
        XCTAssertNil(animalFromDITwo)
    }
    
    func testContainerResolvesWithArguments() {
        let animalNameOne: String? = "MyPetOne"
        let animalNameTwo: String? = "MyPetTwo"
        
        container.register(Animal.self) { Cat() }
        container.register(Animal.self) { arg in Cat(name: arg) }
        
        let animalFromDIOne = container.resolve(Animal.self)
        let animalFromDITwo = container.resolve(
            Animal.self,
            argument: animalNameOne
        )
        let animalFromDIThree = container.resolve(
            Animal.self,
            argument: animalNameTwo
        )
        
        XCTAssertNotNil(animalFromDIOne)
        XCTAssertNotNil(animalFromDITwo)
        
        XCTAssertEqual(animalFromDITwo.name, animalNameOne)
        XCTAssertNotEqual(animalFromDITwo, animalFromDIThree)
    }
    
    func testContainerResolvesSelfBindingWithDependencyInjected() {
        let houseName = "MyHouse"
        
        container.register(House.self) { _ in House(name: houseName) }
        container.register(Animal.self) { container in
            let house = container.resolve(House.self)!
            return Cat(house: house)
        }

        let cat = container.resolve(Animal.self) as? Cat
        
        XCTAssertNotNil(cat?.house)
        XCTAssertEqual(cat?.house?.name, houseName)
    }
}
