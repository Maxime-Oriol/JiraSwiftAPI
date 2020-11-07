public class JiraAPI {
    
    private let requestManager: JiraRequest
    
    //MARK: -- INIT method
    public init(server: String,
                username: String,
                password: String,
                boardId: Int,
                projectId: String) throws {
        
        // Generate token based on login base64 encoded
        let tokenSource = username+":"+password
        guard let data = tokenSource.data(using: .utf8) else {
            throw JiraException.encodingTokenException
        }
        
        let token = data.base64EncodedString()
        
        self.requestManager = JiraRequest(server: server, token: token, boardId: boardId, projectId: projectId)
        
    }
    
    //MARK: -- Cache manager
    public func enableCache(enabled: Bool) {
        self.requestManager.enableCache(enabled)
    }
    public func clearCache() {
        self.requestManager.clearCache()
    }
    
    
    //MARK: -- Available requests
    //MARK: Board
    public func getBoard(completion: ((JiraBoard?) -> Void)?) {
        self.requestManager.getBoard { (board) in
            completion?(board)
        }
    }
    
    public func getIssuesForBacklog(startAt: Int? = nil,
                                    maxResults: Int? = nil,
                                    jql: String? = nil,
                                    validateQuery: Bool = true,
                                    fields: [String] = [],
                                    completion: ((JiraIssues?) -> Void)?) {
        self.requestManager.getIssuesForBacklog(startAt: startAt, maxResults: maxResults, jql: jql, validateQuery: validateQuery, fields: fields) { (issues) in
            completion?(issues)
        }
    }
    
    public func getConfiguration(completion: ((JiraConfiguration?) -> Void)?) {
        self.requestManager.getConfiguration { (config) in
            completion?(config)
        }
    }
    
    public func getAllSprints(startAt: Int? = nil,
                              maxResults: Int? = nil,
                              states: [JiraSprintState] = [],
                              completion: ((JiraSprints?) -> Void)?) {
        
        self.requestManager.allSprints(startAt: startAt, maxResults: maxResults, states: states) { (sprints) in
            completion?(sprints)
        }
    }
    
    //MARK: Sprint
    public func getSprint(id: Int,
                          completion: ((JiraSprint?) -> Void)?) {
        self.requestManager.getSprint(id: id) { (sprint) in
            completion?(sprint)
        }
    }
    
    public func getIssues(sprint: Int,
                          startAt: Int? = nil,
                          maxResults: Int? = nil,
                          jql: String? = nil,
                          expand: [String] = [],
                          extraFields: [String] = [],
                          completion: ((Int, JiraIssues?) -> Void)?) {
        
        self.requestManager.getIssues(sprint: sprint,
                                      startAt: startAt,
                                      maxResults: maxResults,
                                      jql: jql,
                                      expand: expand,
                                      extraFields: extraFields) { (issues) in
            completion?(sprint, issues)
        }
    }
    
    //MARK: Issue
    public func getIssue(issue: String,
                         fields: [String] = [],
                         expand:[String] = [],
                         completion: ((JiraIssue?) -> Void)?) {
        self.requestManager.getIssue(issueIdOfKey: issue, fields: fields, expand: expand) { (issue) in
            completion?(issue)
        }
    }
    
    public func getIssueEstimation(issue: String,
                                   completion: ((String, JiraEstimation?) -> Void)?) {
        self.requestManager.getIssueEstimation(issue: issue) { (issue, estimation) in
            completion?(issue, estimation)
        }
    }
    
    public func getAllVersions(completion: (([JiraVersion])-> Void)?) {
        self.requestManager.getVersions() { (versions) in
            completion?(versions)
        }
    }
    
    public func updateVersion(version: JiraVersion, completion: ((JiraVersion?) -> Void)?) {
        self.requestManager.updateVersion(version: version) { (version) in
            completion?(version)
        }
    }
}
