//
//  Strings.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import Foundation

struct Strings {
    
    struct API {
        // URLs, Endpoints, API Keys
        static let baseURL = "https://api.nasa.gov"
        static let apodEP = "planetary/apod"
        static let key = ProcessInfo.processInfo.environment["NASA_API_KEY"] ?? "DEMO_KEY"
        
        // Query Parameters Names
        static let queryDateName = "date"
        static let queryStartDateName = "start_date"
        static let queryEndDateName = "end_date"
        static let queryKeyName = "api_key"
        
        // Youtube Thumbnail
        static let thumbnailBaseURL = "https://img.youtube.com/vi"
        static let thumbnailSizeComponent = "0"
        static let thumbnailPathExtension = "jpg"
    }
    
    static let defaultPhotoName = "Photo"
    
}
