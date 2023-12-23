import Foundation

struct Day01: AdventDay {
    private let extractor: NumericTextValueExtractor
    
    init(data: String) {
        self.data = data
        extractor = NumericTextValueExtractorImpl()
    }
    
    init(
        extractor: NumericTextValueExtractor = NumericTextValueExtractorImpl(),
        data: String
    ) {
        self.extractor = extractor
        self.data = data
    }
    
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
      data.lines.map { String($0) }
  }

  // Replace this with your solution for the first part of the day's challenge.
    func part1() -> Any {
        let sum = sumOfCalibrationValues(from: entities, includeNumericText: false)
        return String(sum)
    }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
      let sum = sumOfCalibrationValues(from: entities, includeNumericText: true)
      return String(sum)
  }
    
    enum Day01Error: Error {
        case emptyString
        case doesNotContainNumberChar
        case couldNotConstructIntegerFromNumericChars
        case couldNotExtractNumericValues
    }
}


extension Day01 {
    func sumOfCalibrationValues(from lines: [String], includeNumericText: Bool) -> Int {
        lines.compactMap { try? calibrationValue(from: $0, includeNumericText: includeNumericText) }.reduce(0, +)
    }
    
    func calibrationValue(from string: String, includeNumericText: Bool) throws -> Int {
        guard !string.isEmpty else { throw Day01Error.emptyString }
        guard let result = extractor.extractNumericTextValues(in: string, includeNumericText: includeNumericText) else {
            throw Day01Error.couldNotExtractNumericValues
        }
        return Int(String(result.firstValue) + String(result.lastValue)) ?? 0
    }
}

extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

enum NumericTextValue: String, CaseIterable {
    case one, two, three, four, five, six, seven, eight, nine
    
    var numericValue: String {
        switch self {
        case .one:
            return "1"
        case .two:
            return "2"
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        case .six:
            return "6"
        case .seven:
            return "7"
        case .eight:
            return "8"
        case .nine:
            return "9"
        }
    }
    
    var wholeNumber: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        case .seven:
            return 7
        case .eight:
            return 8
        case .nine:
            return 9
        }
    }
}

protocol NumericTextValueExtractor {
    func extractNumericTextValues(in string: String, includeNumericText: Bool) -> (firstValue: Int, lastValue: Int)?
}

struct NumericTextValueExtractorImpl: NumericTextValueExtractor {
    /// Extracts the first and last numbers in a given text.
    /// - Parameters:
    ///   - includeNumericText: Whether to include numbers which are spelled out with letters e.g. one, two, etc.
    func extractNumericTextValues(in text: String, includeNumericText: Bool) -> (firstValue: Int, lastValue: Int)? {
        let numericIndexes = numericTextValueIndexes(in: text, includeNumericText: includeNumericText)
        func number(at index: String.Index, in dictionary:  [String.Index: NumericTextValue]) -> Int? {
            guard let numericValue = dictionary[index]?.numericValue else { return nil }
            return Int(numericValue)
        }
        guard
            let lowestIndex = numericIndexes.keys.min(),
            let highestIndex = numericIndexes.keys.max(),
            let firstNumber = number(at: lowestIndex, in: numericIndexes),
            let lastNumber = number(at: highestIndex, in: numericIndexes)
        else { return nil }
        return (firstNumber, lastNumber)
    }
    
    /// This method analyzes a given text to identify and record the positions of both numeric and textual representations of a
    /// predefined set of numeric values. It returns a dictionary mapping the lower bounds of the identified ranges to their corresponding NumericTextValue.
    func numericTextValueIndexes(in text: String, includeNumericText: Bool) -> [String.Index: NumericTextValue] {
        var indexes = [String.Index: NumericTextValue]()
        func addNumericValue(forRangesOf substring: String, with numericTextValue: NumericTextValue) {
            for range in text.ranges(of: substring) {
                indexes[range.lowerBound] = numericTextValue
            }
        }
        // Go thorugh all the numeric values
        NumericTextValue.allCases.forEach { numericTextValue in
            if includeNumericText {
                // Get the ranges of one, two, three, etc
                addNumericValue(forRangesOf: numericTextValue.rawValue, with: numericTextValue)
            }
            // Get the range of 1, 2, 3, etc
            addNumericValue(forRangesOf: numericTextValue.numericValue, with: numericTextValue)
        }
        return indexes
    }
    
}
