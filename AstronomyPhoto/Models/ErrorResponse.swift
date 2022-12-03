//
//  ErrorResponse.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 02/12/22.
//

import Foundation

struct ErrorResponse: Decodable {
    
    let code: Int
    let msg: String
    
}
