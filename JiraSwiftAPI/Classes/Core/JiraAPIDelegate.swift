//
//  JiraAPIDelegate.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public protocol JiraAPIDelegate {
    func didGetBoard(board: JiraBoard?)
    func didGetAllSprints(sprints:JiraSprints?)
    func didGetSprint(sprint: JiraSprint?)
    func didGetAllIssues(sprint: Int, issues: JiraIssues?)
    func didGetIssuesForBacklog(issues: JiraIssues?)
    func didGetConfiguration(configuration: JiraConfiguration?)
}

//MARK: -- Make all methods optional
public extension JiraAPIDelegate {
    func didGetBoard(board: JiraBoard?) { }
    func didGetAllSprints(sprints:JiraSprints?) { }
    func didGetSprint(sprint: JiraSprint?) { }
    func didGetAllIssues(sprint: Int, issues: JiraIssues?) { }
    func didGetIssuesForBacklog(issues: JiraIssues?) { }
    func didGetconfiguration(configuration: JiraConfiguration?) { }
}
