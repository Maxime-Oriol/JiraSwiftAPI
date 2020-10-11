//
//  JiraRequestQuery.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

enum JiraRequestQuery: String, Decodable {
    case startAt = "startAt"
    case maxResults = "maxResults"
    case state = "state"
    case jql = "jql"
    case validateQuery = "validateQuery"
    case fields = "fields"
}
