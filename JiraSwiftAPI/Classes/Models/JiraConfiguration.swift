//
//  JiraConfiguration.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public struct JiraConfiguration: JiraObject {
    public var id: Int
    public var name: String
    public var type: String
    public var link: URL
    
    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case link = "self"
    }
}
