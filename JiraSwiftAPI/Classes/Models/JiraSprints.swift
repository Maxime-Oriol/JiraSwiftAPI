//
//  JiraSprints.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

public struct JiraSprints: JiraObject {
    
    public let maxResults: Int
    public let startAt: Int
    public let isLast: Bool
    public let values:[JiraSprint]
}
