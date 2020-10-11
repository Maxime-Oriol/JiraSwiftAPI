//
//  JiraVersions.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 11/10/2020.
//

public struct JiraVersions: JiraObject {
    public let maxResults: Int
    public let startAt: Int
    public let total: Int?
    public let isLast: Bool
    public let values:[JiraVersion]
}
