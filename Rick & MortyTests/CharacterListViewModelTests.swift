
import XCTest
@testable import Rick___Morty

class CharacterListViewModelTests: XCTestCase {
    
    var viewModel: CharacterListViewModel!
    var mockService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        viewModel = CharacterListViewModel(networkService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchCharactersSuccess() {
        // Given
        let origin = Origin(name: "Earth", url: "https://rickandmortyapi.com/api/location/1")
        let location = Location(id: 1, name: "Citadel of Ricks", type: "Planet", dimension: "Dimension C-137", residents: ["https://rickandmortyapi.com/api/character/38"], url: "https://rickandmortyapi.com/api/location/3")
                
        let expectedCharacter = Character(
            id: 1,
            name: "Rick Sanchez",
            gender: "Male",
            status: "Alive",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            location: location,
            origin: origin
        )
        
        mockService.characterResult = .success([expectedCharacter])
        
        // When
        viewModel.fetchCharacters(page: 1) { _ in
            // Then
            XCTAssertEqual(self.viewModel.characters.count, 1)
            XCTAssertEqual(self.viewModel.characters.first?.name, "Rick Sanchez")
        }
    }
    
    func testFetchCharactersFailure() {
        // Given
        mockService.characterResult = .failure(.dataError)
        
        // When
        viewModel.fetchCharacters(page: 1) { _ in
            // Then
            XCTAssertEqual(self.viewModel.characters.count, 0)
        }
    }
    
    func testCharactersAppendedOnPagination() {
        // Given
        let originFirst = Origin(name: "Earth", url: "https://rickandmortyapi.com/api/location/1")
        let locationFirst = Location(id: 1, name: "Citadel of Ricks", type: "Planet", dimension: "Dimension C-137", residents: ["https://rickandmortyapi.com/api/character/38"], url: "https://rickandmortyapi.com/api/location/3")
                
        let firstCharacter = Character(
            id: 1,
            name: "Rick Sanchez",
            gender: "Male",
            status: "Alive",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            location: locationFirst,
            origin: originFirst
        )
        
        let originSecond = Origin(name: "Earth", url: "https://rickandmortyapi.com/api/location/3")
        let locationSecond = Location(id: 1, name: "Citadel of Ricks", type: "Planet", dimension: "Dimension C-137", residents: ["https://rickandmortyapi.com/api/character/38"], url: "https://rickandmortyapi.com/api/location/3")
                
        let secondCharacter = Character(
            id: 1,
            name: "Morty Smith",
            gender: "Male",
            status: "Alive",
            species: "Human",
            image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
            location: locationSecond,
            origin: originSecond
        )
        
        
        mockService.characterResult = .success([firstCharacter])

        viewModel.fetchCharacters(page: 1) { _ in }

        // When
        mockService.characterResult = .success([secondCharacter])
        viewModel.fetchCharacters(page: 2) { _ in 
            // Then
            XCTAssertEqual(self.viewModel.characters, [firstCharacter, secondCharacter])
            XCTAssertEqual(self.viewModel.characters.count, 2)
            XCTAssertEqual(self.viewModel.characters[0].name, firstCharacter.name)
            XCTAssertEqual(self.viewModel.characters[1].name, secondCharacter.name)

        }
    }

    func testDecodingErrorHandling() {
        // Given
        mockService.characterResult = .failure(.decodingError)

        // When
        viewModel.fetchCharacters(page: 1) { _ in
            // Then
            XCTAssertEqual(self.viewModel.characters.count, 0)
        }
    }

    
}
