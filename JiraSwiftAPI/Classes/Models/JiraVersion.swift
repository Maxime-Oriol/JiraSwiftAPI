//
//  JiraVersion.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 11/10/2020.
//

public struct JiraVersion: JiraObject {
    public var link: URL
    public var id: Int
    public var projectId:Int
    public var name: String
    public var description: String?
    public var archived: Bool
    public var released: Bool
    
    private let _releaseDate:String?
    
    public var releaseDate:Date? {
        guard let date = _releaseDate else {
            return nil
        }
        // 2018-11-20T10:46:09.189+01:00
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: date)
    }
    
    public enum CodingKeys: String, CodingKey {
        case link = "self"
        case id = "id"
        case projectId = "projectId"
        case name = "name"
        case description = "description"
        case archived = "archived"
        case released = "released"
        case _releaseDate = "releaseDate"
    }
}
