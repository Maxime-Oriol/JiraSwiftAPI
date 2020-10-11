//
//  JiraBoard.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public struct JiraBoard: Decodable {
    public var id: Int
    public var link: URL
    public var name: String
    public var type: String
    

    public enum CodingKeys: String, CodingKey {
        case id = "id"
        case link = "self"
        case name = "name"
        case type = "type"
    }
}
