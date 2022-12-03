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
    
}

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

    var recordID: CKRecord.ID?

    let title: String
    let description: String
    let dateString: String
    let url: URL
    let hdURL: URL

    var photo: UIImage?

    // MARK: - Computed Properties

    var date: Date {
        return dateString.toDate(formatter: .api)
    }

    // MARK: - Initializer

    init(title: String, description: String, dateString: String, url: URL, hdURL: URL, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.description = description
        self.dateString = dateString
        self.url = url
        self.hdURL = hdURL
        self.recordID = recordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[APODKeys.title] as? String,
              let description = ckRecord[APODKeys.description] as? String,
              let date = ckRecord[APODKeys.date] as? Date,
              let url = ckRecord[APODKeys.url] as? URL,
              let hdURL = ckRecord[APODKeys.hdURL] as? URL else { return nil }
        
        let dateString = date.toString(formatter: .api)
        
        self.init(title: title, description: description, dateString: dateString, url: url, hdURL: hdURL, recordID: ckRecord.recordID)
    }

}

extension CKRecord {
    
    convenience init(apod: APOD) {
        self.init(recordType: APODKeys.recordType)
        
        self.setValuesForKeys([
            APODKeys.title: apod.title,
            APODKeys.description: apod.description,
            APODKeys.date: apod.date,
            APODKeys.url: apod.url,
            APODKeys.hdURL: apod.url,
        ])
    }
    
}

extension APOD: Equatable {
    
    static func ==(lhs: APOD, rhs: APOD) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description
    }
    
}
