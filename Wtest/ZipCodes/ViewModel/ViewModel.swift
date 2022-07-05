//
//  ViewModel.swift
//  Wtest
//
//  Created by Yuri on 04/07/2022.
//

import Foundation
import CSV
import CoreData

typealias Completion = (Result<[ZipCodeEntity], Error>) -> Void

protocol ViewModelProtocol {
    var zipCodes: [ZipCodeEntity] { get }
    func getCSVFromApi(completion: @escaping Completion)
    func getZipCodes(by text: String, completion: @escaping Completion)
}

class ViewModel {
    let request: NSFetchRequest<ZipCodeEntity> = ZipCodeEntity.fetchRequest()
    var zipCodes: [ZipCodeEntity] = []

    lazy var managedObjectContext: NSManagedObjectContext = {
        return AppDelegate.persistentContainer.viewContext
    }()

    init () {
        print("Init ViewModel")
    }
    
    deinit {
        print("Deinit ViewModel")
    }
}

extension ViewModel: ViewModelProtocol {
    func getCSVFromApi(completion: @escaping (Result<[ZipCodeEntity], Error>) -> Void) {
        let service = ZipCodeService()
        deleteAllZipCodes()
        
        service.getPostalCode { [weak self] result in
            switch result {
            case .success(let csv):
                do {
                    let reader = try CSVReader(string: csv, hasHeaderRow: true)
                    let decoder = CSVRowDecoder()
                    var zipCodes: [ZipCode] = []
                    while reader.next() != nil {
                        let row = try decoder.decode(ZipCode.self, from: reader)
                        zipCodes.append(row)
                        self?.save(zipCode: row)
                    }
                    
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
    
    private func save(zipCode: ZipCode) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ZipCodeEntity", in: managedObjectContext) else { return }
                
        let newValue = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        let fullZipCode = "\(zipCode.zipCode)-\(zipCode.extensionZipCode) \(zipCode.city)"
        newValue.setValue(fullZipCode, forKey: "zipCode")
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Save error")
        }
    }
    
    func deleteAllZipCodes() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "ZipCodeEntity")

        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )

        deleteRequest.resultType = .resultTypeObjectIDs

        let batchDelete = try! managedObjectContext.execute(deleteRequest)
            as? NSBatchDeleteResult

        guard let deleteResult = batchDelete?.result
            as? [NSManagedObjectID]
            else { return }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [managedObjectContext]
        )
    }
    
    func getZipCodes(by text: String, completion: @escaping Completion) {
        if !text.isEmpty {
            request.predicate = NSPredicate(format: "zipCode contains[c] %@", text)
        }
            
        do {
            zipCodes = try managedObjectContext.fetch(request)
            completion(.success(zipCodes))
        } catch {
            completion(.failure(error))
        }
    }
}
