//
//  JiraParser.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

class JiraParser {
    
    public static func decode<T>(data: Data) -> T? where T: Decodable {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error while decoding")
            print(error)
        }
        
        return nil
    }
    
}
