//
//  JiraEpic.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 11/10/2020.
//

public struct JiraEpic: JiraObject {
    
    public var id: Int
    public var link: URL
    public var name: String
    public var summary: String?
    public var done: Bool
    
    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case link = "self"
        case name = "name"
        case summary = "summary"
        case done = "done"
    }
}
