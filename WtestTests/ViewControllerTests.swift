//
//  WtestTests.swift
//  WtestTests
//
//  Created by Yuri on 02/07/2022.
//

import XCTest
@testable import Wtest

class ViewControllerTests: XCTestCase {
    
    var viewModel: ViewModelProtocolMock!
    var coordinator = ViewCoordinator(navigationController: UINavigationController())
    
    func testHasFinishedDownloading() {
        viewModel = ViewModelMock(status: .success)
        
        XCTAssertFalse(viewModel.hasFinished, "The download must not be finished yet!")
        viewModel.getCSVFromApi { result in
            switch result {
            case .success:
                XCTAssertTrue(self.viewModel.hasFinished, "The download must be finished!")
            case .failure:
                break
            }
        }
    }
    
    func testErrorWhileDownloading() {
        viewModel = ViewModelMock(status: .error)
        
        XCTAssertFalse(viewModel.hasFinished, "The download must not be finished yet!")
        viewModel.getCSVFromApi { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertFalse(self.viewModel.hasFinished, "The download must not be finished yet!")
                XCTAssertEqual(error.localizedDescription, "Lost internet connection", "The error message must be: Lost internet connection")
            }
        }
    }
    
    func testAppClosedWhileDownloading() {
        viewModel = ViewModelMock(status: .closedDownloading)
        
        XCTAssertFalse(viewModel.hasFinished, "The download must not be finished yet!")
        viewModel.getCSVFromApi { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTAssertFalse(self.viewModel.hasFinished, "The download must not be finished yet!")
            }
        }
    }
    
    func testHidesIndicatorViewWhenSuccess() {
        viewModel = ViewModelMock(status: .success)
        
        XCTAssertTrue(viewModel.isShowingIndicator, "The indicator view must be visible!")
        viewModel.getCSVFromApi { result in
            switch result {
            case .success:
                XCTAssertFalse(self.viewModel.isShowingIndicator, "The indicator view must not be visible!")
            case .failure:
                break
            }
        }
    }
    
    func testHidesIndicatorViewWhenError() {
        viewModel = ViewModelMock(status: .error)
        
        XCTAssertTrue(viewModel.isShowingIndicator, "The indicator view must be visible!")
        viewModel.getCSVFromApi { result in
            switch result {
            case .success:
                break
            case .failure:
                XCTAssertFalse(self.viewModel.isShowingIndicator, "The indicator view must not be visible!")
            }
        }
    }
}
