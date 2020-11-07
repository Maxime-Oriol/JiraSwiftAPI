//
//  JiraHistoryItem.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 13/10/2020.
//

public struct JiraHistoryItem: JiraObject {
    public let field: String
    public let from: String?
    public let fromString: String?
    public let to: String?
    public let toString: String?
    
    public static func parse(data: Data) -> JiraObject? {
        do {
            return try JSONDecoder().decode(JiraHistoryItem.self, from: data)
        } catch {
            return nil
        }
    }
}
