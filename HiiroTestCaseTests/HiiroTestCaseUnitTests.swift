import XCTest
@testable import HiiroTestCase

final class HiiroTestCaseTests: XCTestCase {
    
    var viewModel: TrainingViewModel!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = TrainingViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    // Проверка функции форматирования дат
    func testFormatDate() {
        // Given
        guard let date1 = dateFormatter.date(from: "08.04.2024"),
              let date2 = dateFormatter.date(from: "09.04.2024"),
              let date3 = dateFormatter.date(from: "10.04.2024") else {
            XCTFail("Failed to create test dates.")
            return
        }
        
        // When
        let expectedDate1 = "8"
        let expectedDate2 = "9"
        let expectedDate3 = "10"
        let expectedDate4 = "MON"
        let expectedDate5 = "TUE"
        
        // Then
        XCTAssertEqual(viewModel.formatDate(date1).dayOfMonth, expectedDate1)
        XCTAssertEqual(viewModel.formatDate(date2).dayOfMonth, expectedDate2)
        XCTAssertEqual(viewModel.formatDate(date3).dayOfMonth, expectedDate3)
        XCTAssertEqual(viewModel.formatDate(date1).dayOfWeek, expectedDate4)
        XCTAssertEqual(viewModel.formatDate(date2).dayOfWeek, expectedDate5)
        
    }
    
    // Проверяем, что ViewModel корректно переходит к следующей неделе.
    func testGoToNextWeek() {
        // Given
        let currentWeekDates = viewModel.dates
        
        // When
        viewModel.goToNextWeek()
        
        // Then
        XCTAssertNotEqual(viewModel.dates, currentWeekDates)
    }
    
    // Проверяем, что ViewModel корректно переходит к предыдущей неделе.
    func testGoToPreviousWeek() {
        // Given
        let currentWeekDates = viewModel.dates
        
        // When
        viewModel.goToPreviousWeek()
        
        // Then
        XCTAssertNotEqual(viewModel.dates, currentWeekDates)
    }
}
