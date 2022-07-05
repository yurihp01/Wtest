//
//  ViewModelTests.swift
//  WtestTests
//
//  Created by Yuri on 05/07/2022.
//

import XCTest
@testable import Wtest

class ViewModelTests: XCTestCase {
    
    var service: ZipCodeServiceProtocol!
    
    func testGetPostalCodeSuccessful() {
        service = ZipCodeServiceMock(status: .success)
        service.getZipCode { result in
            switch result {
            case .success(let csv):
                XCTAssertFalse(csv.isEmpty, "Zip codes must not be empty!")
            case .failure:
                break
            }
        }
    }
    
    func testGetPostalCodeError() {
        service = ZipCodeServiceMock(status: .error)
        service.getZipCode { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertNotNil(error, "This call must show an error!")
            }
        }
    }
}
