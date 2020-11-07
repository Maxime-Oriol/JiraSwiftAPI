//
//  JiraIssueChangelog.swift
//  Pods
//
//  Created by ORIOL.OMNILOG, MAXIME on 13/10/2020.
//

public struct JiraIssueChangelog: JiraObject {
    
    public let startAt: Int
    public let maxResults: Int
    public let total: Int
    public let histories:[JiraIssueHistory]?
    
    public static func parse(data: Data) -> JiraObject? {
        do {
            return try JSONDecoder().decode(JiraIssueChangelog.self, from: data)
        } catch {
            return nil
        }
    }

}
