//
//  JiraRequestIssue.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 12/10/2020.
//

extension JiraRequest {
    
    // GET /rest/agile/1.0/issue/{issueIdOrKey}
    // Returns a single issue, for a given issue ID or issue key. Issues returned from this resource include Agile fields, like sprint, closedSprints, flagged, and epic.
    func getIssue(issueIdOfKey: String, fields: [String] = [], expand: [String] = [], completion: ((JiraIssue?) -> Void)?) {
        let path = "/rest/agile/1.0/issue/{issueIdOrKey}".replacingOccurrences(of: "{issueIdOrKey}", with: issueIdOfKey)
        
        var parameters:[JiraRequestQuery: String] = [:]
        if fields.count > 0 {
            parameters[.fields] = fields.joined(separator: ",")
        }
        if expand.count > 0 {
            parameters[.expand] = expand.joined(separator: ",")
        }
        
        self.get(path: path, parameters: nil) { (result) in
            let issue:JiraIssue? = JiraParser.decode(data: result)
            completion?(issue)
        }
    }
    
    // GET /rest/agile/1.0/issue/{issueIdOrKey}/estimation
    // Returns the estimation of the issue and a fieldId of the field that is used for it. boardId param is required. This param determines which field will be updated on a issue.
    func getIssueEstimation(issue: String, completion: ((String, JiraEstimation?) -> Void)?) {
        let path = "/rest/agile/1.0/issue/{issueIdOrKey}/estimation".replacingOccurrences(of: "{issueIdOrKey}", with: issue)
        let parameters = [JiraRequestQuery.boardId: String(self.boardId)]
        self.get(path: path, parameters: parameters) { (result) in
            let estimation:JiraEstimation? = JiraParser.decode(data: result)
            completion?(issue, estimation)
        }
    }
}
