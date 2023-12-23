import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day02Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testDataForPart1 = """
    Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
    Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
    Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
    Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    """

    func testPart1() throws {
        let challenge = Day02(data: testDataForPart1)
        XCTAssertEqual(challenge.part1() as? Int, 8)
    }
    
    func testPart2() throws {
        let challenge = Day02(data: testDataForPart1)
        XCTAssertEqual(challenge.part2() as? Int, 2286)
    }
    
    func testGame_HasExactly_ReturnsTrue() {
        // Given
        let cubes: [Game.Color: Int] = [.blue: 5, .green: 2, .red: 7]
        let game = Game(identifier: 13, sets: [cubes])

        // When
        let result = game.hasLessThanOrEqual(red: 12, green: 13, blue: 14)
        
        // Then
        XCTAssertTrue(result)
    }
        
    func testGame_HasExactly_ReturnsFalse2() {
        // Given
        let set1: [Game.Color: Int] = [.blue: 6, .green: 8, .red: 20]
        let set2: [Game.Color: Int] = [.blue: 5, .green: 13, .red: 4]
        let set3: [Game.Color: Int] = [.green: 5, .red: 1]
        let game = Game(identifier: 13, sets: [set1, set2, set3])

        // When
        let result = game.hasLessThanOrEqual(red: 12, green: 13, blue: 14)
        
        // Then
        XCTAssertFalse(result)
    }
    
    func testGame_HasExactly_ReturnsFalse() {
        // Given
        let cubes: [Game.Color: Int] = [.blue: 5, .green: 2, .red: 7]
        let game = Game(identifier: 13, sets: [cubes])
        
        // When
        let result = game.hasLessThanOrEqual(red: 1, green: 4, blue: 5)
        
        // Then
        XCTAssertFalse(result)
    }
    
    func test_Game_FewestNumberOfCubes_1() {
        let game = try! GameMapperImpl().map("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green")
        let expectedCubes: [Game.Color: Int] = [.red: 4, .green: 2, .blue: 6]

        // When
        let cubes = game.fewestNumberOfCubes()
        
        // Then
        XCTAssertEqual(cubes, expectedCubes)
    }

    func test_Game_FewestNumberOfCubes_2() {
        let game = try! GameMapperImpl().map("Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red")
        let expectedCubes: [Game.Color: Int] = [.red: 20, .green: 13, .blue: 6]

        // When
        let cubes = game.fewestNumberOfCubes()
        
        // Then
        XCTAssertEqual(cubes, expectedCubes)
    }
    
    func test_Game_PowerOfSet() {
        let set: [Game.Color: Int] = [.red: 20, .green: 13, .blue: 6]

        // When
        let power = Game.powerOfSet(set)
        
        // Then
        XCTAssertEqual(power, 1560)
    }
}

final class GameMapperTests: XCTestCase {
    let sut = GameMapperImpl()
    
    func testMapString_CreatesGame() {
        // Given
        let input = "Game 13: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
        let sets: [[Game.Color: Int]] = [
            [.blue: 3, .red: 4],
            [.red: 1, .green: 2, .blue: 6],
            [.green: 2]
        ]

        
        // When
        let game = try! sut.map(input)
        
        // Then
        XCTAssertEqual(game.identifier, 13)
        XCTAssertEqual(game.sets, sets)
    }
      
    func testMapSet_WithSampleData1() {
        // Given
        let input = "5 blue, 2 green, 6 red"
        let expectedResult: [Game.Color: Int] = [.blue: 5, .green: 2, .red: 6]
        
        // When
        let result = try! sut.map(set: input)
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func testMapSet_WithSampleData2() {
        // Given
        let input = "6 red, 1 blue, 3 green"
        let expectedResult: [Game.Color: Int] = [.blue: 1, .green: 3, .red: 6]
        
        // When
        let result = try! sut.map(set: input)
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }

    func testMapCubes_Blue() {
        // Given
        let input = "5 blue"
        
        // When
        let result = try! sut.map(cubes: input)
        
        // Then
        XCTAssertEqual(result.color, .blue)
        XCTAssertEqual(result.count, 5)
    }
    
    func testMapCubes_Red() {
        // Given
        let input = "10 red"
        
        // When
        let result = try! sut.map(cubes: input)
        
        // Then
        XCTAssertEqual(result.color, .red)
        XCTAssertEqual(result.count, 10)
    }
    
    func testMapCubes_Green() {
        // Given
        let input = "9 green"
        
        // When
        let result = try! sut.map(cubes: input)
        
        // Then
        XCTAssertEqual(result.color, .green)
        XCTAssertEqual(result.count, 9)
    }

}
