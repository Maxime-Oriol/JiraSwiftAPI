//
//  JiraIssue.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public struct JiraIssue: JiraObject {
    
    public var expand: String
    public var id: String
    public var link: URL
    public var key:String
    public var fields:JiraIssueFields
    public var changelog: JiraIssueChangelog?
    
    public enum CodingKeys: String, CodingKey {
        case expand     = "expand"
        case id         = "id"
        case link       = "self"
        case key        = "key"
        case fields     = "fields"
        case changelog  = "changelog"
    }
    
    public static func parse(data: Data) -> JiraObject? {
        do {
        return try JSONDecoder().decode(JiraIssue.self, from: data)
        } catch {
            return nil
        }
    }
}
