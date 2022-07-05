//
//  ZipCodeCoreData.swift
//  Wtest
//
//  Created by Yuri on 05/07/2022.
//

import Foundation
import CoreData

// MARK: - Protocol
protocol ZipCodeCoreDataProtocol {
    func save(zipCode: ZipCode)
    func deleteAllZipCodes()
    func getZipCodes(by text: String, completion: @escaping Completion)
}

// MARK: - Class
class ZipCodeCoreData {
    let request: NSFetchRequest<ZipCodeEntity> = ZipCodeEntity.fetchRequest()

    lazy var managedObjectContext: NSManagedObjectContext = {
        return AppDelegate.persistentContainer.viewContext
    }()
}

// MARK: - Extension ZipCodeCoreDataProtocol
extension ZipCodeCoreData: ZipCodeCoreDataProtocol {
    
    /// It saves the object into the database
    func save(zipCode: ZipCode) {
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
    
    /// It deletes all data from database
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
    
    /// It takes all zip codes from the database
    func getZipCodes(by text: String, completion: @escaping Completion) {
        if !text.isEmpty {
            request.predicate = NSPredicate(format: "zipCode contains[c] %@", text)
        }
            
        do {
            let zipCodes = try managedObjectContext.fetch(request)
            completion(.success(zipCodes))
        } catch {
            completion(.failure(error))
        }
    }
}
