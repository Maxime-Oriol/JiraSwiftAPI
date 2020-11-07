//
//  JiraRequestSprint.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

extension JiraRequest {
    
    // GET /rest/agile/1.0/sprint/{sprintId}
    // Returns the sprint for a given sprint ID. The sprint will only be returned if the user can view the board that the sprint was created on, or view at least one of the issues in the sprint.
    
    func getSprint(id: Int, completion: ((JiraSprint?) -> Void)?) {
        let builder = JiraRequestBuilder()
        builder.path = "/rest/agile/1.0/sprint/{sprintId}".replacingOccurrences(of: "{sprintId}", with: String(id))
        
        self.execute(request: builder) { (result) in
            let sprint = JiraSprint.parse(data: result) as? JiraSprint
            completion?(sprint)
        }
    }
    
    func getIssues(sprint: Int,
                   startAt: Int? = nil,
                   maxResults: Int? = nil,
                   jql: String? = nil,
                   expand: [String] = [],
                   extraFields: [String] = [],
                   completion: ((JiraIssues?) -> Void)?) {
        
        var parameters:[JiraRequestQuery: String] = [:]
        if  let startAt = startAt {
            parameters[.startAt] = String(startAt)
        }
        if let maxResults = maxResults {
            parameters[.maxResults] = String(maxResults)
        }
        if expand.count > 0 {
            parameters[.expand] = expand.joined(separator: ",")
        }
        if let jql = jql {
            parameters[.jql] = jql
        }
        
        let path = "/rest/agile/1.0/sprint/{sprintId}/issue".replacingOccurrences(of: "{sprintId}", with: String(sprint))
        
        let builder = JiraRequestBuilder()
        builder.path = path
        builder.parameters = parameters
        
        self.execute(request: builder) { (result) in
            let issues = JiraIssues.parse(data: result, extraFields: extraFields) as? JiraIssues
            completion?(issues)
        }
    }
}
