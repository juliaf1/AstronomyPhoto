//
//  FavoriteController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 03/12/22.
//

import Foundation
import CloudKit

class FavoriteController {
    
    // MARK: - Properties
    
    static let shared = FavoriteController()
    let privateDB = CKContainer(identifier: "iCloud.com.juliafrederico.APOD").privateCloudDatabase
    
    var apodsFetched: Bool = false
    var apods: [APOD] = []
    
    // MARK: - Methods
    
    func fetchFavorites(completion: @escaping (Result<[APOD], APIError>) -> Void) {
        if apodsFetched {
            return completion(.success(apods))
        }
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: APODKeys.recordType, predicate: predicate)
        
        var apods: [APOD] = []
        
        privateDB.fetch(withQuery: query) { result in
            switch result {
            case .success(let successResult):
                successResult.matchResults.forEach { matchTuple in
                    if case .success(let record) = matchTuple.1 {
                        guard let apod = APOD(ckRecord: record) else { return }
                        apods.append(apod)
                    }
                }
                
                let group = DispatchGroup()
                
                for apod in apods {
                    group.enter()
                    
                    switch apod.mediaType {
                    case .video:
                        APODController.shared.fetchThumbnail(apod: apod) { _ in
                            group.leave()
                        }
                    case .image:
                        APODController.shared.fetchPhoto(apod: apod) { _ in
                            group.leave()
                        }
                    }
                }

                group.notify(queue: .main) {
                    self.apods = apods
                    self.apodsFetched = true
                    return completion(.success(apods))
                }
            case .failure(let error):
                return completion(.failure(.thrownError(error)))
            }
        }
    }
    
    func favorite(apod: APOD, completion: @escaping(Result<Void, APIError>) -> Void) {
        fetchFavorites { result in
            switch result {
            case .success(let apods):
                self.apods = apods
                
                if self.apods.contains(apod) {
                    // apod is already favorited
                    return completion(.success(()))
                }
                
                let record = CKRecord(apod: apod)
                
                self.privateDB.save(record) { record, error in
                    if let error = error {
                        return completion(.failure(.thrownError(error)))
                    }
                    
                    guard let record = record,
                          let newAPOD = APOD(ckRecord: record) else {
                        return completion(.failure(.recordError))
                    }
                    
                    newAPOD.photo = apod.photo
                    self.apods.append(newAPOD)
                    return completion(.success(()))
                }
                
            case .failure(let error):
                return completion(.failure(.thrownError(error)))
            }
        }
    }
    
    func unfavorite(apod: APOD, completion: @escaping(Result<Void, APIError>) -> Void) {
        guard let index = self.apods.firstIndex(of: apod) else {
            return completion(.failure(.noData)) // todo: update error
        }
        
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [apod.recordID!])
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive

        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success:
                self.apods.remove(at: index)
                return completion(.success(()))
            case .failure(let error):
                return completion(.failure(.thrownError(error)))
            }
        }
        
        privateDB.add(operation)
    }
    
    
}
