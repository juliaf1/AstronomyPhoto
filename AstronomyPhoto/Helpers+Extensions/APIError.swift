//
//  APIError.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import Foundation

enum APIError: LocalizedError {

    case invalidURL
    case noData
    case imageDecode
    case thrownError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Unable to reach NASA API"
        case .noData:
            return "NASA API couldn't find any data"
        case .imageDecode:
            return "We couldn't fetch the image"
        case .thrownError(let error):
            return error.localizedDescription
        }
    }
    
}
