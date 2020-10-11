//
//  JiraSprintStatus.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

public enum JiraSprintState: String, Decodable {
    case closed = "closed"
    case active = "active"
    case future = "future"
}
