//
//  ViewModel.swift
//  Wtest
//
//  Created by Yuri on 04/07/2022.
//

import Foundation
import CSV

// MARK: - Typealias
typealias Completion = (Result<[ZipCodeEntity], Error>) -> Void


// MARK: - Protocol
protocol ViewModelProtocol {
    var zipCodes: [ZipCodeEntity] { get }
    func getCSVFromApi(completion: @escaping Completion)
    func getZipCodes(by text: String, completion: @escaping Completion)
}

// MARK: - ViewModel
class ViewModel {
    var zipCodes: [ZipCodeEntity] = []
    let coreData: ZipCodeCoreDataProtocol
    
    init (coreData: ZipCodeCoreData) {
        self.coreData = coreData
        
        print("Init ViewModel")
    }
    
    deinit {
        print("Deinit ViewModel")
    }
}


// MARK: - Extension ViewModelProtocol
extension ViewModel: ViewModelProtocol {
    
    /// It downloads a CSV file, decodes to ZipCode object and adds to CoreData
    func getCSVFromApi(completion: @escaping (Result<[ZipCodeEntity], Error>) -> Void) {
        let service = ZipCodeService()
        
        coreData.deleteAllZipCodes()
        
        service.getPostalCode { [weak self] result in
            switch result {
            case .success(let csv):
                do {
                    let reader = try CSVReader(string: csv, hasHeaderRow: true)
                    let decoder = CSVRowDecoder()
                    var zipCodes: [ZipCode] = []
                    
                    // it takes each row and saves it to the database
                    while reader.next() != nil {
                        let zipCode = try decoder.decode(ZipCode.self, from: reader)
                        zipCodes.append(zipCode)
                        self?.coreData.save(zipCode: zipCode)
                    }
                    
                    // add this flag to UserDefaults to check if it needs to get from CSV again or if it has downloaded completely
                    UserDefaults.standard.set(true, forKey: "hasFinished")
                    completion(.success([]))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// This function delete all rows from CoreData
    func deleteAllZipCodes() {
        coreData.deleteAllZipCodes()
    }
    
    /// This function get all data from CoreData
    func getZipCodes(by text: String, completion: @escaping Completion) {
        coreData.getZipCodes(by: text, completion: completion)
    }
}
