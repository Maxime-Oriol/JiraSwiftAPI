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
        let builder = JiraRequestBuilder()
        builder.path = "/rest/agile/1.0/board/{boardId}"
        
        self.execute(request: builder) { (result) in
            let board = JiraBoard.parse(data: result) as? JiraBoard
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
        
        let builder = JiraRequestBuilder()
        builder.path = "/rest/agile/1.0/board/{boardId}/backlog"
        builder.parameters = parameters
        
        self.execute(request: builder) { (result) in
            let issues = JiraIssues.parse(data: result) as? JiraIssues
            completion?(issues)
        }
        
    }
    
    // GET /rest/agile/1.0/board/{boardId}/configuration
    // Get the board configuration. The response contains the following fields
    func getConfiguration(completion: ((JiraConfiguration?) -> Void)?) {
        let builder = JiraRequestBuilder()
        builder.path = "/rest/agile/1.0/board/{boardId}/configuration"
        
        self.execute(request: builder) { (result) in
            do {
                let config = try JiraConfiguration.parse(data: result)
                completion?(config)
            } catch {
                completion?(nil)
            }
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
        
        let builder = JiraRequestBuilder()
        builder.path = "/rest/agile/1.0/board/{boardId}/sprint"
        builder.parameters = parameters
        
        self.execute(request: builder) { (result) in
            do {
                let sprints = try JiraSprints.parse(data: result)
                completion?(sprints)
            } catch {
                completion?(nil)
            }
            
        }
    }
}
