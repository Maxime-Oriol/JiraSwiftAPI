//
//  JiraIssues.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public struct JiraIssues: JiraObject {
    
    public let expand: String
    public let startAt: Int
    public let maxResults: Int
    public let total: Int
    public let issues:[JiraIssue]
}

