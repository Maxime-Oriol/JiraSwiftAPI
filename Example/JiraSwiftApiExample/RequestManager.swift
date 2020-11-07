//
//  APIDelegate.swift
//  JiraSwiftApiExample
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

import Foundation
import JiraSwiftAPI

class RequestManager {
    
    public static var shared: RequestManager {
        get {
            if self._instance == nil {
                self._instance = RequestManager()
            }
            
            return self._instance!
        }
    }
    private static var _instance: RequestManager? = nil
    
    private var jiraManager:JiraAPI
    
    init() {
        
        // Create your own Configuration Struct containing your credentials
        // Go there to create your token ; works only for cloud hosted projects :
        // https://id.atlassian.com/manage-profile/security/api-tokens
        
        self.jiraManager = try! JiraAPI(server: Configuration.server,
                                        username: Configuration.username,
                                        password: Configuration.token,
                                        boardId: Configuration.boardId,
                                        projectId: Configuration.projectId)
        self.jiraManager.enableCache(enabled: false)
    }
    
    func getLastsSprints(offset:Int = 0,
                               completion: ((JiraSprints?) -> Void)?) {
        self.jiraManager.getAllSprints(startAt: offset, states: [.closed, .active]) { (sprints) in
            completion?(sprints)
        }
    }
    
    func getSprint(sprintId: Int, completion: ((JiraSprint?) -> Void)?) {
        self.jiraManager.getSprint(id: sprintId) { (sprint) in
            completion?(sprint)
        }
    }
    
    func getTicketsInSprint(sprint: Int, extraFields: [String] = [], completion: ((Int, JiraIssues?) -> Void)?) {
        self.jiraManager.getIssues(sprint: sprint, maxResults: 5000, jql: "status != '"+State.backlog.rawValue+"'", expand: ["changelog"], extraFields: extraFields) { (sprint, issues) in
            guard let issues = issues else {
                completion?(0, nil)
                return
            }
            
            completion?(issues.issues.count, issues)
        }
    }
    
    func getIssuesDodOk(sprint: Int, completion: ((JiraIssues?) -> Void)?) {
        let status = ["'A Packager'", "'Review Fonctionnel'", "'Review QA'", "Fini"]
        let jql = "status in ("+status.joined(separator: ",")+")"
        
        self.jiraManager.getIssues(sprint: sprint, maxResults: 5000, jql: jql) { (sprint, issues) in
            completion?(issues)
        }
    }
    
    func getFirstEstimatedIssue(sprint: Int, completion: ((JiraIssue?) -> Void)?) {
        let jql = "'Story points' > 0"
        
        self.jiraManager.getIssues(sprint: sprint, maxResults: 1, jql: jql) { (sprint, issues) in
            let issue = issues?.issues.first
            completion?(issue)
        }
    }
    
    func getEstimation(issue: String, completion: ((JiraEstimation?) -> Void)?) {
        self.jiraManager.getIssueEstimation(issue: issue) { (issue, estimation) in
            completion?(estimation)
        }
    }
    
    func getUnreleasedVersions(completion: (([JiraVersion]) -> Void)?) {
        self.jiraManager.getAllVersions() { (versions) in
            completion?(versions.filter { $0.released == false && $0.archived == false })
        }
    }
    
    func updateVersion(version: JiraVersion, completion: ((JiraVersion?) -> Void)?) {
        self.jiraManager.updateVersion(version: version) { (version) in
            completion?(version)
        }
    }
}
