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
        let path = "/rest/agile/1.0/sprint/{sprintId}".replacingOccurrences(of: "{sprintId}", with: String(id))
        
        self.get(path: path, parameters: nil) { (result) in
            let sprint:JiraSprint? = JiraParser.decode(data: result)
            completion?(sprint)
        }
    }
    
    func getIssues(sprint: Int, completion: ((JiraIssues?) -> Void)?) {
        let path = "/rest/agile/1.0/sprint/{sprintId}/issue".replacingOccurrences(of: "{sprintId}", with: String(sprint))
        
        self.get(path: path, parameters: nil) { (result) in
            let issues:JiraIssues? = JiraParser.decode(data: result)
            completion?(issues)
        }
    }
}
