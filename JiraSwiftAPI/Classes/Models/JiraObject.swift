//
//  JiraObject.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

public protocol JiraObject: Decodable {
//    static func parse(data: Data) -> Self
//    static func parse(data: Data, extraFields:[String]) -> Self
}

extension JiraObject {
    public static func parse(data: Data) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }
    
    public static func parse(data: Data, extraFields:[String]) throws -> Self {
        return try JSONDecoder().decode(Self.self, from: data)
    }
}

public enum JiraSprintState: String, Decodable {
    case closed = "closed"
    case active = "active"
    case future = "future"
}

public enum JiraHttpMethod: String, Decodable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
