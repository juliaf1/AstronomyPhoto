//
//  APOD.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import UIKit
import CloudKit

struct APODKeys {
    
    static let recordType = "APOD"
    static let recordID = "recordID"
    
    fileprivate static let title = "title"
    fileprivate static let url = "url"
    fileprivate static let hdURL = "hdURL"
    fileprivate static let description = "description"
    fileprivate static let date = "date"
    fileprivate static let mediaType = "mediaType"
    
}

enum MediaType: String, Decodable {
    case video = "video"
    case image = "image"
}

class APOD: Decodable {

    // MARK: - Coding Keys
    
    enum CodingKeys: String, CodingKey {
        case title
        case url
        case hdURL = "hdurl"
        case mediaType = "media_type"
        case description = "explanation"
        case dateString = "date"
    }

    // MARK: - Stored Properties

    var recordID: CKRecord.ID?

    let title: String
    let description: String
    let dateString: String
    let mediaType: MediaType
    
    let url: URL?
    let hdURL: URL?

    var photo: UIImage?
    
    var favorite: Bool = false

    // MARK: - Computed Properties

    var date: Date {
        return dateString.toDate(formatter: .api)
    }

    // MARK: - Initializer

    init(title: String, description: String, dateString: String, mediaType: MediaType, url: URL?, hdURL: URL?, favorite: Bool = false, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.description = description
        self.dateString = dateString
        self.url = url
        self.hdURL = hdURL
        self.mediaType = mediaType
        self.recordID = recordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[APODKeys.title] as? String,
              let description = ckRecord[APODKeys.description] as? String,
              let date = ckRecord[APODKeys.date] as? Date,
              let mediaTypeString = ckRecord[APODKeys.mediaType] as? String,
              let mediaType = MediaType(rawValue: mediaTypeString) else { return nil }
        
        var url: URL?
        var hdURL: URL?
        
        if let urlString = ckRecord[APODKeys.url] as? String {
            url = URL(string: urlString)
        }

        if let hdURLString = ckRecord[APODKeys.hdURL] as? String {
            hdURL = URL(string: hdURLString)
        }
        
        let dateString = date.toString(formatter: .api)
        
        self.init(title: title, description: description, dateString: dateString, mediaType: mediaType, url: url, hdURL: hdURL, recordID: ckRecord.recordID)
    }

}

extension CKRecord {
    
    convenience init(apod: APOD) {
        self.init(recordType: APODKeys.recordType)
        
        self.setValuesForKeys([
            APODKeys.title: apod.title,
            APODKeys.description: apod.description,
            APODKeys.date: apod.date,
            APODKeys.mediaType: apod.mediaType.rawValue,
        ])
        
        if let url = apod.url {
            self.setValue("\(url)", forKey: APODKeys.url)
        }
        
        if let hdURL = apod.hdURL {
            self.setValue("\(hdURL)", forKey: APODKeys.hdURL)
        }
    }
    
}

extension APOD: Equatable {
    
    static func ==(lhs: APOD, rhs: APOD) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description
    }
    
}
