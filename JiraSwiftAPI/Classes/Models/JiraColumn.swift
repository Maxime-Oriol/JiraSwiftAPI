//
//  JiraColumn.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 11/10/2020.
//

public struct JiraColumn: JiraObject {
    public var name: String
    
    public static func parse(data: Data) -> JiraObject? {
        do {
            return try JSONDecoder().decode(JiraColumn.self, from: data)
        } catch {
            return nil
        }
    }
}
