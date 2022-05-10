//
//  WikiManager.swift
//  do I know U?
//
//  Created by Татьяна on 10.05.2022.
//

import Foundation

protocol WikiManagerDelegate {
    func didUpdateWikiData(_ wikiManager: WikiManager, wiki: Results)
    
    func didFailWithError(error: Error)
}

struct WikiManager {
    let wikipediaURl = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&indexpageids"
    
    var delegate: WikiManagerDelegate?
    
    func fetchWikiData(celebName: String) {
        let urlString = "\(wikipediaURl)&titles=\(celebName)".replacingOccurrences(of: " ", with: "%20")
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    self.parseJson(safeData)
                    
                    if let wiki = self.parseJson(safeData) {
                        self.delegate?.didUpdateWikiData(self, wiki: wiki)
                    }
                }
            }
            task.resume()
        }
        
        
    }
    func parseJson(_ wikiData: Data)  -> Results? {
        print("Ia m inside parsejson")
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WikiData.self, from: wikiData).query.pages
            
            if let pageKey = decodedData.first?.key { //changing dictionary key captured here
                let results = decodedData[pageKey]! // Dictionary that the changing key refers to
                print(results.pageid, " = ",results.title)
                print(results.pageid, " = ",results.extract)
                return results
            }
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
        return nil
    }
}
