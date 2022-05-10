//
//  WikiData.swift
//  do I know U?
//
//  Created by Татьяна on 10.05.2022.
//

import Foundation

struct WikiData: Codable { // entire structure
    struct Query: Codable { // query dictionary
        let pages : [String:Results] // String is the changing pageid
    }
    let query : Query //reference to srtucture
}
