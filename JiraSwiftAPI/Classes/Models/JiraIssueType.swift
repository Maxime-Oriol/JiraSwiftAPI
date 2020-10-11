//
//  JiraIssueType.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public struct JiraIssueType: JiraObject {
    public var id: String
    public var description: String
    public var iconUrl:URL
    public var name:String
    public var subtask:Bool
    public var avatarId: Int?
}
