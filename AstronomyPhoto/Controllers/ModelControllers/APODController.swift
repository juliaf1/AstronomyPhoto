//
//  APODController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import UIKit
import CloudKit

class APODController {
    
    // MARK: - Properties
    
    static let shared = APODController()
    
    let privateDB = CKContainer.default().privateCloudDatabase

    var today: APOD?
    var favorites: [APOD] = []
    var results: [APOD] = []

    // MARK: - Initializer

    private init() {}
    
    // MARK: - Methods
    
    private func apodURL(startDate: Date? = nil, endDate: Date? = nil) -> URL? {
        guard let baseURL = URL(string: Strings.API.baseURL) else { return nil }
        
        let apodURL = baseURL.appendingPathComponent(Strings.API.apodEP)
        var components = URLComponents(url: apodURL, resolvingAgainstBaseURL: true)
        
        let apiKeyQuery = URLQueryItem(name: Strings.API.queryKeyName, value: Strings.API.key)

        components?.queryItems = [apiKeyQuery]
        
        if let startDate = startDate {
            let startDateQuery = URLQueryItem(name: Strings.API.queryStartDateName, value: startDate.toString(formatter: .api))

            components?.queryItems?.append(startDateQuery)
        }
        
        if let endDate = endDate {
            let endDateQuery = URLQueryItem(name: Strings.API.queryEndDateName, value: endDate.toString(formatter: .api))
            
            components?.queryItems?.append(endDateQuery)
        }
        
        guard let finalURL = components?.url else { return nil }
        
        return finalURL
    }
    
    func fetchTodayAPOD(completion: @escaping (Result<APOD, APIError>) -> Void) {

        guard let url = apodURL() else {
            return completion(.failure(.invalidURL))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("STATUS CODE in \(#function): \(response.statusCode)")
                
                do {
                    let error = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    return completion(.failure(.responseError(error)))
                } catch {
                    
                }
            }
            
            do {
                let apod = try JSONDecoder().decode(APOD.self, from: data)
                self.today = apod
                
                let group = DispatchGroup()
                group.enter()

                self.fetchPhoto(apod: apod) { result in
                    switch result {
                    case .success(let photo):
                        apod.photo = photo
                    case .failure:
                        break
                    }
                    group.leave()
                }
                
                group.notify(queue: .main) {
                    return completion(.success(apod))
                }
            } catch {
                return completion(.failure(.thrownError(error)))
            }
            
        }.resume()
    }
    
    func fetchAPODs(startDate: Date?, endDate: Date?, completion: @escaping (Result<[APOD], APIError>) -> Void) {
        
        guard let url = apodURL(startDate: startDate, endDate: endDate) else {
            return completion(.failure(.invalidURL))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("STATUS CODE in \(#function): \(response.statusCode)")
                
                do {
                    let error = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    return completion(.failure(.responseError(error)))
                } catch {
                    
                }
            }
            
            do {
                let apods = try JSONDecoder().decode([APOD].self, from: data)
                self.results = apods
                
                let group = DispatchGroup()
                
                for apod in apods {
                    group.enter()
                    
                    self.fetchPhoto(apod: apod) { result in
                        switch result {
                        case .success(let photo):
                            apod.photo = photo
                        case .failure:
                            break
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    return completion(.success(apods))
                }
            } catch {
                return completion(.failure(.thrownError(error)))
            }
            
        }.resume()
        
    }
    
    private func fetchPhoto(apod: APOD, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        URLSession.shared.dataTask(with: apod.url) { data, _, error in
            if let error = error {
                print("Error fetching photo:", error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let image = UIImage(data: data) else { return completion(.failure(.imageDecode)) }
            
            apod.photo = image

            return completion(.success(image))
        }.resume()

    }
    
}

extension APODController {
    
    // MARK: - Cloud Kit Methods
    
    func fetchFavorites(completion: @escaping(Result<[APOD], APIError>) -> Void) {
        // Fetch favorites APOD
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: APODKeys.recordType, predicate: predicate)
        
        var results: [APOD] = []
        
        privateDB.fetch(withQuery: query) { result in
            switch result {
            case .success(let successResult):
                let group = DispatchGroup()
                group.enter()

                successResult.matchResults.forEach { matchTuple in
                    if case .success(let record) = matchTuple.1 {
                        guard let apod = APOD(ckRecord: record) else { return }
                        self.fetchPhoto(apod: apod) { result
                            in
                            if case .success(let photo) = result {
                                apod.photo = photo
                            }
                        }
                        results.append(apod)
                    }
                    group.leave()
                }

                self.favorites = results

                return completion(.success(results))
            case .failure(let error):
                return completion(.failure(.thrownError(error)))
            }
        }
    }
    
    func toggleFavorite(apod: APOD, completion: @escaping(Result<APOD, Error>) -> Void) {
    }
    
    func favorite(apod: APOD, completion: @escaping(Result<APOD, Error>) -> Void) {
        // Create CK Record from APOD
        // Recreate APOD from CK Record
        // Append APOD to favorites array
    }
    
    private func unfavorite(apod: APOD, completion: @escaping(Result<APOD, Error>) -> Void) {
        // Remove APOD from DB
        // Remove APOD from results array
    }
    
    
}
