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
    case recordError
    case responseError(ErrorResponse)
    case thrownError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "We couldn't reach the API"
        case .noData:
            return "We couldn't find any data"
        case .imageDecode:
            return "We couldn't fetch the image"
        case .recordError:
            return "We couldn't save the record"
        case .responseError(let response):
            return response.msg
        case .thrownError(let error):
            return error.localizedDescription
        }
    }
    
}
