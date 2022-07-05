//
//  ViewModelMock.swift
//  WtestTests
//
//  Created by Yuri on 05/07/2022.
//

import XCTest
@testable import Wtest

protocol ViewModelProtocolMock: ViewModelProtocol {
    var hasFinished: Bool { get }
    var zipCodes: [ZipCodeEntity] { get }
    var isShowingIndicator: Bool { get }
}

class ViewModelMock: ViewModelProtocolMock {
    
    let status: ViewModelStatus
    
    var hasFinished = false
    var isShowingIndicator: Bool = true
    
    var zipCodes: [ZipCodeEntity] = [ZipCodeEntity(), ZipCodeEntity()]
    
    init (status: ViewModelStatus) {
        self.status = status
    }
    
    func getCSVFromApi(completion: @escaping Completion) {
        switch status {
        case .success:
            hasFinished = true
            isShowingIndicator = false
            completion(.success([]))
        case .error:
            isShowingIndicator = false
            completion(.failure(ZipCodeError.internetConnection))
        case .closedDownloading:
            completion(.failure(ZipCodeError.closedDownloading))
        }
    }
    
    func getZipCodes(by text: String, completion: @escaping Completion) {
        switch status {
        case .success:
            completion(.success(zipCodes))
        case .error:
            completion(.failure(ZipCodeError.internetConnection))
        case .closedDownloading:
            completion(.failure(ZipCodeError.closedDownloading))
        }
    }
    
    enum ViewModelStatus {
        case success
        case error
        case closedDownloading
    }
    
}
