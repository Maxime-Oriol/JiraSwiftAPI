//
//  JiraEpics.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 11/10/2020.
//

public struct JiraEpics: JiraObject {
    
    public let maxResults: Int
    public let startAt: Int
    public let isLast: Bool
    public let values:[JiraEpic]
}
