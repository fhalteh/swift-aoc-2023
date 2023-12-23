import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day01Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testDataForDay1 = """
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
    """

    let testDataForDay2 = """
        two1nine
        eightwothree
        abcone2threexyz
        xtwone3four
        4nineeightseven2
        zoneight234
        7pqrstsixteen
    """

    func testPart1() throws {
        let challenge = Day01(data: testDataForDay1)
        XCTAssertEqual(String(describing: challenge.part1()), "142")
    }
    
    func testPart2() throws {
        let challenge = Day01(data: testDataForDay2)
        XCTAssertEqual(String(describing: challenge.part2()), "281")
    }
    
    func testFetchCalibrationValue_WithInput1() throws {
        // Given
        let input = "1abc2"
        
        // When
        let challenge = Day01()
        let calibrationValue = try challenge.calibrationValue(from: input, includeNumericText: false)
        
        // Then
        XCTAssertEqual(calibrationValue, 12)
    }
    
    func testFetchCalibrationValue_WithInput2() throws {
        // Given
        let input = "pqr3stu8vwx"

        // When
        let challenge = Day01()
        let calibrationValue = try challenge.calibrationValue(from: input, includeNumericText: false)
        
        // Then
        XCTAssertEqual(calibrationValue, 38)
    }
    
    func testFetchCalibrationValue_WithInput3() throws {
        // Given
        let input = "a1b2c3d4e5f"

        // When
        let challenge = Day01()
        let calibrationValue = try challenge.calibrationValue(from: input, includeNumericText: false)
        
        // Then
        XCTAssertEqual(calibrationValue, 15)
    }

    func testFetchCalibrationValue_WithInput4() throws {
        // Given
        let input = "treb7uchet"

        // When
        let challenge = Day01()
        let calibrationValue = try challenge.calibrationValue(from: input, includeNumericText: false)
        
        // Then
        XCTAssertEqual(calibrationValue, 77)
    }
    
    func testFetchCalibrationValue_WithInput5() throws {
        // Given
        let input = "two1nine"

        // When
        let challenge = Day01()
        let calibrationValue = try challenge.calibrationValue(from: input, includeNumericText: true)
        
        // Then
        XCTAssertEqual(calibrationValue, 29)
    }
    
    func testFetchCalibrationValue_WithInput6() throws {
        // Given
        let input = "xtwone3four"

        // When
        let challenge = Day01()
        let calibrationValue = try challenge.calibrationValue(from: input, includeNumericText: true)

        // Then
        XCTAssertEqual(calibrationValue, 24)
    }
}

final class NumericTextValueExtractorTests: XCTestCase {
    let sut = NumericTextValueExtractorImpl()
    
    func test_ConvertNumericTextValuesToNumbers_Input1() {
        // Given
        let stringValue = "eightwothree"
        
        // When
        let result = sut.extractNumericTextValues(in: stringValue, includeNumericText: true)

        // Then
        XCTAssertEqual(result?.firstValue, 8)
        XCTAssertEqual(result?.lastValue, 3)
    }
    
    func test_ConvertNumericTextValuesToNumbers_Input2() {
        // Given
        let stringValue = "abcone2threexyz"
        
        // When
        let result = sut.extractNumericTextValues(in: stringValue, includeNumericText: true)

        // Then
        XCTAssertEqual(result?.firstValue, 1)
        XCTAssertEqual(result?.lastValue, 3)
    }
    
    func test_ConvertNumericTextValuesToNumbers_Input3() {
        // Given
        let stringValue = "4nineeightseven2"
        
        // When
        let result = sut.extractNumericTextValues(in: stringValue, includeNumericText: true)

        // Then
        XCTAssertEqual(result?.firstValue, 4)
        XCTAssertEqual(result?.lastValue, 2)
    }
    
    func test_ConvertNumericTextValuesToNumbers_Input4() {
        // Given
        let stringValue = "zoneight234"
        
        // When
        let result = sut.extractNumericTextValues(in: stringValue, includeNumericText: true)

        // Then
        XCTAssertEqual(result?.firstValue, 1)
        XCTAssertEqual(result?.lastValue, 4)
    }
    
    func test_ConvertNumericTextValuesToNumbers_WithNumbersOnly_Input5() {
        // Given
        let stringValue = "zoneight234"
        
        // When
        let result = sut.extractNumericTextValues(in: stringValue, includeNumericText: false)

        // Then
        XCTAssertEqual(result?.firstValue, 2)
        XCTAssertEqual(result?.lastValue, 4)
    }
    
    func test_ConvertNumericTextValuesToNumbers_WithNumbersOnly_Input6() {
        // Given
        let stringValue = "heightwosixthzdf7gdtllhsnfive1onemfcqkqfqkj1"
        
        // When
        let result = sut.extractNumericTextValues(in: stringValue, includeNumericText: true)

        // Then
        XCTAssertEqual(result?.firstValue, 8)
        XCTAssertEqual(result?.lastValue, 1)
    }
    
    func test_ConvertNumericTextValuesToNumbers_WithNumbersOnly_Input7() {
        // Given
        let stringValue = "1fourthreetpmqqtzgtwofour"
        
        // When
        let result = sut.extractNumericTextValues(in: stringValue, includeNumericText: true)

        // Then
        XCTAssertEqual(result?.firstValue, 1)
        XCTAssertEqual(result?.lastValue, 4)
    }

}

