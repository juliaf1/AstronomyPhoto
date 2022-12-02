//
//  APOD.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import UIKit

class APOD: Decodable {

    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case title
        case url
        case hdURL = "hdurl"
        case description = "explanation"
        case dateString = "date"
    }

    // MARK: - Stored Properties

    let title: String
    let description: String
    let dateString: String
    let url: URL?
    let hdURL: URL?
    
    var photo: UIImage?
    
    // MARK: - Computed Properties

    var date: Date {
        return dateString.toAPIDate()
    }

    // MARK: - Initializer

    init(title: String, description: String, dateString: String, url: URL?, hdURL: URL?) {
        self.title = title
        self.description = description
        self.dateString = dateString
        self.url = url
        self.hdURL = hdURL
    }

}
