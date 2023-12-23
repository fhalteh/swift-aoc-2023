import Foundation

struct Day02: AdventDay {
    let gameMapper: GameMapper
    var data: String
    
    init(data: String) {
        self.data = data
        self.gameMapper = GameMapperImpl()
    }

    var entities: [String] {
        data.lines.map { String($0) }
    }
    
    func part1() -> Any {
        do {
            let games = try entities
                .map { try gameMapper.map($0) }
            let filteredGames = games.filter { $0.hasLessThanOrEqual(red: 12, green: 13, blue: 14) }
            let sumOfIdentifiers = filteredGames
                .map { $0.identifier }
                .reduce(0, +)
            return sumOfIdentifiers
        } catch {
            print("Error occurred", error)
            return -1
        }
    }
    
    func part2() -> Any {
        do {
            return try entities
                .map { try gameMapper.map($0) }
                .map { $0.fewestNumberOfCubes() }
                .map { Game.powerOfSet($0) }
                .reduce(0, +)
        } catch {
            print("Error occurred", error)
            return -1
        }
    }
}

extension Game {
    static func powerOfSet(_ set: [Game.Color: Int]) -> Int {
        return set.reduce(1) { partialResult, element in
            partialResult * element.value
        }
    }

    func hasLessThanOrEqual(red: Int, green: Int, blue: Int) -> Bool {
        // Go through a game's sets
        for set in sets {
            let redCubes = set[.red] ?? 0
            let greenCubes = set[.green] ?? 0
            let blueCubes = set[.blue] ?? 0
            if redCubes > red || greenCubes > green || blueCubes > blue {
                return false
            }
        }
        return true
    }
    
    func fewestNumberOfCubes() -> [Game.Color: Int] {
        // get the maximum of each
        var fewestCubes = [Game.Color: Int]()
        Game.Color.allCases.forEach { fewestCubes[$0] = 0 }
        for set in sets {
            Game.Color.allCases.forEach { color in
                if let colorCount = set[color], colorCount > (fewestCubes[color] ?? 0) {
                    fewestCubes[color] = colorCount
                }
            }
        }
        return fewestCubes
    }
}

protocol GameMapper {
    func map(_ input: String) throws -> Game
}

struct Game {
    let identifier: Int
    let sets: [[Color: Int]]
    
    enum Color: String, CaseIterable {
        case red, green, blue
    }
}

enum GameMapperError: Error {
    case doesNotContainGame
    case parsingError
    case couldNotRetrieveGameIdentifier
    case cubeCountAndColorError
}
final class GameMapperImpl: GameMapper {
    func map(_ gameInput: String) throws -> Game {
        let inputComponents = gameInput.split(separator: ":")
        guard inputComponents.count == 2 else {
            throw GameMapperError.parsingError
        }
        let gameIdentifier = inputComponents.first
        guard gameIdentifier?.contains("Game") == true else {
            throw GameMapperError.doesNotContainGame
        }
        
        let gameIdentifierComponents = gameIdentifier?.split(whereSeparator: \.isWhitespace)
        guard
            let identifierComponent = gameIdentifierComponents?.last,
            let identifier = Int(identifierComponent) else {
            throw GameMapperError.couldNotRetrieveGameIdentifier
        }
        
        let sets = try inputComponents[1].split(separator: ";").map { try map(set: String($0)) }
        return Game(identifier: identifier, sets: sets)
    }
    
    // 5 blue, 2 green, 6 blue
    func map(set: String) throws -> [Game.Color: Int] {
        var cubes = [Game.Color: Int]()
        let cubesByColor = try set.split(separator: ",").map { try map(cubes: String($0))}
        for colorCount in cubesByColor {
            cubes[colorCount.color] = colorCount.count
        }
        return cubes
    }
    
    // "5 blue" should output (blue, 5)
    func map(cubes: String) throws -> (color: Game.Color, count: Int) {
        // Check what color exists here
        let components = cubes.split(whereSeparator: \.isWhitespace)
        guard
            let count = Int(components[0]),
            let color = Game.Color(rawValue: String(components[1])) else {
            throw GameMapperError.cubeCountAndColorError
        }
        return (color, count)
    }
}
