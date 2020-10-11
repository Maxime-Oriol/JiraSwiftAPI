//
//  JiraCacheManager.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

import Foundation

//MARK: @TODO: Improve and fix considering options for each request
class JiraCacheManager {
    open var enabled = true
    
    var data: [String: Data] = [:]
    
    func clear() {
        self.data = [:]
    }
    
    func preserve(route: String, data: Data) {
        self.data[route] = data
    }
    
    func value(route: String) -> Decodable? {
        return self.data[route]
    }
}
