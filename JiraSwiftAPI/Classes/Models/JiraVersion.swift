//
//  JiraVersion.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 15/10/2020.
//

import Foundation

public class JiraVersion: JiraObject, Encodable {
    
    public let id: String
    public let name: String
    public let description: String?
    public let archived: Bool
    public var released:Bool
    public let projectId: Int
    
    private var _releaseDate:String?
    
    public var releaseDate:Date? {
        guard let date = _releaseDate else {
            return nil
        }
        // 2018-11-20T10:46:09.189+01:00
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date)
    }
    
    public enum CodingKeys: String, CodingKey {
        case id             = "id"
        case name           = "name"
        case description    = "description"
        case archived       = "archived"
        case released       = "released"
        case _releaseDate   = "releaseDate"
        case projectId      = "projectId"
    }
    
    public static func parse(data: Data) -> JiraObject? {
        do {
            return try JSONDecoder().decode(JiraVersion.self, from: data)
        } catch {
            return nil
        }
    }
    
    public func setReleased(at: String) {
        self._releaseDate = at
        self.released = true
    }
}

