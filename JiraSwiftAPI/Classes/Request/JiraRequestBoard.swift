//
//  JiraRequestSprint.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

extension JiraRequest {
    
    // GET /rest/agile/1.0/board/{boardId}
    // Returns the board for the given board ID. This board will only be returned if the user has permission to view it. Admins without the view permission will see the board as a private one, so will see only a subset of the board's data (board location for instance).
    func getBoard(completion: ((JiraBoard?) -> Void)?) {
        self.get(path: "/rest/agile/1.0/board/{boardId}", parameters: nil) { (result) in
            let board:JiraBoard? = JiraParser.decode(data: result)
            completion?(board)
        }
    }
    
    // GET /rest/agile/1.0/board/{boardId}/backlog
    // Returns all issues from the board's backlog, for the given board ID. This only includes issues that the user has permission to view. The backlog contains incomplete issues that are not assigned to any future or active sprint. Note, if the user does not have permission to view the board, no issues will be returned at all. Issues returned from this resource include Agile fields, like sprint, closedSprints, flagged, and epic. By default, the returned issues are ordered by rank.
    func getIssuesForBacklog(startAt: Int? = nil, maxResults: Int? = nil, jql: String? = nil, validateQuery: Bool = true, fields: [String] = [], completion: ((JiraIssues?) -> Void)?) {
        var parameters:[JiraRequestQuery: String] = [:]
        if  let startAt = startAt {
            parameters[.startAt] = String(startAt)
        }
        if let maxResults = maxResults {
            parameters[.maxResults] = String(maxResults)
        }
        if let jql = jql {
            parameters[.jql] = jql
        }
        if validateQuery == false {
            parameters[.validateQuery] = "false"
        }
        if fields.count > 0 {
            parameters[.fields] = fields.joined(separator: ",")
        }
        
        self.get(path: "/rest/agile/1.0/board/{boardId}/backlog", parameters: parameters) { (result) in
            let issues:JiraIssues? = JiraParser.decode(data: result)
            completion?(issues)
        }
        
    }
    
    // GET /rest/agile/1.0/board/{boardId}/configuration
    // Get the board configuration. The response contains the following fields
    func getConfiguration(completion: ((JiraConfiguration?) -> Void)?) {
        self.get(path: "/rest/agile/1.0/board/{boardId}/configuration", parameters: nil) { (result) in
            let config:JiraConfiguration? = JiraParser.decode(data: result)
            completion?(config)
        }
    }
    
    // GET /rest/agile/1.0/board/{boardId}/epic
    // Returns all epics from the board, for the given board ID. This only includes epics that the user has permission to view. Note, if the user does not have permission to view the board, no epics will be returned at all.
    
    func getEpics(startAt: Int? = nil, maxResults: Int? = nil, done: Bool? = nil, completion:((JiraEpics?) -> Void)?) {
        var parameters:[JiraRequestQuery: String] = [:]
        if  let startAt = startAt {
            parameters[.startAt] = String(startAt)
        }
        if let maxResults = maxResults {
            parameters[.maxResults] = String(maxResults)
        }
        if let done = done {
            parameters[.done] = done ? "true" : "false"
        }
        
        self.get(path: "/rest/agile/1.0/board/{boardId}/epic", parameters: parameters) { (result) in
            let epics: JiraEpics? = JiraParser.decode(data: result)
            completion?(epics)
        }
    }
    
    // GET /rest/agile/1.0/board/{boardId}/issue
    // Returns all issues from a board, for a given board ID. This only includes issues that the user has permission to view. An issue belongs to the board if its status is mapped to the board's column. Epic issues do not belongs to the scrum boards. Note, if the user does not have permission to view the board, no issues will be returned at all. Issues returned from this resource include Agile fields, like sprint, closedSprints, flagged, and epic. By default, the returned issues are ordered by rank.
    func getIssuesForBoard(startAt: Int? = nil, maxResults: Int? = nil, jql: String? = nil, validateQuery: Bool = true, fields: [String] = [], completion: ((JiraIssues?) -> Void)?) {
        var parameters:[JiraRequestQuery: String] = [:]
        if  let startAt = startAt {
            parameters[.startAt] = String(startAt)
        }
        if let maxResults = maxResults {
            parameters[.maxResults] = String(maxResults)
        }
        if let jql = jql {
            parameters[.jql] = jql
        }
        if validateQuery == false {
            parameters[.validateQuery] = "false"
        }
        if fields.count > 0 {
            parameters[.fields] = fields.joined(separator: ",")
        }
        
        self.get(path: "/rest/agile/1.0/board/{boardId}/issue", parameters: parameters) { (result) in
            let issues:JiraIssues? = JiraParser.decode(data: result)
            completion?(issues)
        }
    }
    
    
    // GET /rest/agile/1.0/board/{boardId}/sprint
    // Returns all sprints from a board, for a given board ID. This only includes sprints that the user has permission to view.
    
    func allSprints(startAt: Int?, maxResults: Int?, states:[JiraSprintState], completion: ((JiraSprints?) -> Void)?) {
        var parameters:[JiraRequestQuery: String] = [:]
        if  let startAt = startAt {
            parameters[.startAt] = String(startAt)
        }
        if let maxResults = maxResults {
            parameters[.maxResults] = String(maxResults)
        }
        if states.count > 0 {
            let statesStr = states.map { $0.rawValue }.joined(separator: ",")
            parameters[.state] = statesStr
        }
        
        self.get(path: "/rest/agile/1.0/board/{boardId}/sprint", parameters: parameters) { (result) in
            let sprints:JiraSprints? = JiraParser.decode(data: result)
            completion?(sprints)
        }
    }
}
