public class JiraAPI {
    
    private let requestManager: JiraRequest
    public var delegate: JiraAPIDelegate? = nil
    
    //MARK: -- INIT method
    public init(server: String, username: String, password: String, boardId: Int) throws {
        
        // Generate token based on login base64 encoded
        let tokenSource = username+":"+password
        guard let data = tokenSource.data(using: .utf8) else {
            throw JiraException.encodingTokenException
        }
        
        let token = data.base64EncodedString()
        
        self.requestManager = JiraRequest(server: server, token: token, boardId: boardId)
        
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
    public func getBoard() {
        self.requestManager.getBoard { (board) in
            self.delegate?.didGetBoard(board: board)
        }
    }
    
    public func getIssuesForBacklog(startAt: Int? = nil, maxResults: Int? = nil, jql: String? = nil, validateQuery: Bool = true, fields: [String] = []) {
        self.requestManager.getIssuesForBacklog(startAt: startAt, maxResults: maxResults, jql: jql, validateQuery: validateQuery, fields: fields) { (issues) in
            self.delegate?.didGetIssuesForBacklog(issues: issues)
        }
    }
    
    public func getConfiguration() {
        self.requestManager.getConfiguration { (config) in
            self.delegate?.didGetConfiguration(configuration: config)
        }
    }
    
    public func getAllSprints(startAt: Int? = nil, maxResults: Int? = nil, states: [JiraSprintState] = []) {
        
        self.requestManager.allSprints(startAt: startAt, maxResults: maxResults, states: states) { (sprints) in
            self.delegate?.didGetAllSprints(sprints: sprints)
        }
    }
    
    //MARK: Sprint
    public func getSprint(id: Int) {
        self.requestManager.getSprint(id: id) { (sprint) in
            self.delegate?.didGetSprint(sprint: sprint)
        }
    }
    
    public func getIssues(sprint: Int) {
        self.requestManager.getIssues(sprint: sprint) { (issues) in
            self.delegate?.didGetAllIssues(sprint: sprint, issues: issues)
        }
    }
    
    //MARK: Issue
    public func getIssue(issue: String, fields: [String] = [], expand:[String] = []) {
        self.requestManager.getIssue(issueIdOfKey: issue, fields: fields, expand: expand) { (issue) in
            self.delegate?.didGetIssue(issue: issue)
        }
    }
    
    public func getIssueEstimation(issue: String) {
        self.requestManager.getIssueEstimation(issue: issue) { (issue, estimation) in
            self.delegate?.didGetIssueEstimation(issue: issue, estimation: estimation)
        }
    }
}
