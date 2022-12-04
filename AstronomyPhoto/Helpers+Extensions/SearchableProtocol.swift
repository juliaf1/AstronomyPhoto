//
//  SearchableProtocol.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 04/12/22.
//

import Foundation

protocol Searchable {
    func matches(searchTerm: String) -> Bool
}
