//
//  APODController.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import UIKit

class APODController {
    
    // MARK: - Properties
    
    static let shared = APODController()

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
            let startDateQuery = URLQueryItem(name: Strings.API.queryStartDateName, value: startDate.toAPIString())

            components?.queryItems?.append(startDateQuery)
        }
        
        if let endDate = endDate {
            let endDateQuery = URLQueryItem(name: Strings.API.queryEndDateName, value: endDate.toAPIString())
            
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
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("STATUS CODE in \(#function): \(response.statusCode)")
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let apod = try JSONDecoder().decode(APOD.self, from: data)
                self.today = apod
                return completion(.success(apod))
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
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("STATUS CODE in \(#function): \(response.statusCode)")
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            do {
                let apods = try JSONDecoder().decode([APOD].self, from: data)
                self.results = apods
                return completion(.success(apods))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
            
        }.resume()
        
    }
    
    func fetchPhoto(apod: APOD, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        guard let url = apod.url else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching sprite:", error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let image = UIImage(data: data) else { return completion(.failure(.imageDecode)) }
            
            apod.photo = image

            return completion(.success(image))
        }.resume()

    }
    
}
