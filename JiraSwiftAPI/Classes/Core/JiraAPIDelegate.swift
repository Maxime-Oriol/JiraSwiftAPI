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
    func didGetEpics(epics: JiraEpics?)
    func didGetIssuesForBoard(issues: JiraIssues?)
}

//MARK: -- Make all methods optional
public extension JiraAPIDelegate {
    func didGetBoard(board: JiraBoard?) { }
    func didGetAllSprints(sprints:JiraSprints?) { }
    func didGetSprint(sprint: JiraSprint?) { }
    func didGetAllIssues(sprint: Int, issues: JiraIssues?) { }
    func didGetIssuesForBacklog(issues: JiraIssues?) { }
    func didGetConfiguration(configuration: JiraConfiguration?) { }
    func didGetEpics(epics: JiraEpics?) { }
    func didGetIssuesForBoard(issues: JiraIssues?) { }
}
