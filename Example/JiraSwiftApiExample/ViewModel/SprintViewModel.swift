//
//  SprintViewModel.swift
//  JiraSwiftApiExample
//
//  Created by ORIOL.OMNILOG, MAXIME on 12/10/2020.
//

import JiraSwiftAPI

class SprintViewModel {
    
    private var allSprints:[JiraSprint] = []
    public var sprintId: Int = 0

    private var sprint:JiraSprint?
    private var issues:JiraIssues?
    private var estimationField: String?
    private var issuesInProgress: [JiraIssue] = []
    private var issuesDOD:[JiraIssue] = []
    private var newIssuesDOD:[JiraIssue] = []
    private var newBugDOD:[JiraIssue] = []
    private var newIssuesSprint:[JiraIssue] = []
    
    func reset() {
        self.sprint = nil
        self.issues = nil
        self.issuesInProgress = []
        self.issuesDOD = []
        self.newIssuesDOD = []
        self.newBugDOD = []
        self.newIssuesSprint = []
    }

    func getSprintsForDropdown(completion: @escaping ([JiraSprint]) -> Void) {
        
        RequestManager.shared.getLastsSprints(offset: 20) { [weak self] (sprints) in
            guard let sprints = sprints,
                  let self = self else {
                completion([])
                return
            }
            
            self.allSprints = sprints.values.sorted {
                guard let firstStart = $0.startDate,
                      let secondStart = $1.startDate else {
                    return false
                }
                return firstStart > secondStart
            }
            
            completion(self.allSprints)
        }
    }
    
    func getSprintFrom(index: Int) -> JiraSprint? {
        return allSprints[index]
    }
    
    func loadAllIssues(sprint: Int, completion: @escaping (Int) -> Void) {
        self.sprintId = sprint
        
        var extraFields:[String] = []
        if estimationField != nil { extraFields.append(estimationField!) }
    
        RequestManager.shared.getSprint(sprintId: self.sprintId) { (sprint) in
            self.sprint = sprint
            RequestManager.shared.getTicketsInSprint(sprint: self.sprintId, extraFields: extraFields) { (sprintId, issues) in
                self.issues = issues
                self.sortIssues()
                completion(self.issues?.issues.count ?? 0)
            }
        }
    }
    
    private func sortIssues() {
        guard let issues = self.issues?.issues,
              let sprint = self.sprint,
              let startDate = sprint.startDate,
              let endDate = sprint.endDate else {
            return
        }
        
        // Issues in progress = Ready, en cours, code review
        issuesInProgress = issues.filter { State.dodKO.contains($0.fields.status.name) }
        
        // Issues DOD = A Packager ou +
        issuesDOD = issues.filter { State.dodOK.contains($0.fields.status.name) }
        
        // Issues DOD pendant le sprint = Passé à A packager pendant le sprint
        newIssuesDOD = issues.filter {
            guard let histories = $0.changelog?.histories else {
                return false
            }
            for history in histories {
                guard let created = history.created else {
                    continue
                }
                if created > startDate && created < endDate {
                    for item in history.items {
                        if item.toString == State.aPackager.rawValue {
                            return true
                        }
                    }
                }
            }
            return false
        }
        
        // New bug DOD pendant le sprint = Tickets de bug passés en A packager pendant le sprint
        newBugDOD = newIssuesDOD.filter {
            return $0.fields.issuetype.name == IssueType.anomalie.rawValue || $0.fields.issuetype.name == IssueType.bugRecette.rawValue
        }
        
        // New issues in sprint = Issues ajoutées pendant le sprint
        newIssuesSprint = issues.filter {
            guard let histories = $0.changelog?.histories else {
                return false
            }
            for history in histories {
                guard let created = history.created else {
                    continue
                }
                if created > startDate && created < endDate {
                    for item in history.items {
                        if item.toString == State.ready.rawValue || (item.field == "Sprint" && item.to == String(sprintId)) {
                            return true
                        }
                    }
                }
            }
            return false
        }
    }
    
    func countNewTicketsSprint() -> Int {
        return newIssuesSprint.count
    }
    
    func countResolvedBugsInSprint(component: Component? = nil) -> Int {
        if component == nil {
        return newBugDOD.count
        } else if let component = component {
            return newBugDOD.filter { $0.fields.components.first?.name == component.rawValue }.count
        }
        return 0
    }
    
    func countTicketsDodOK() -> Int {
        return issuesDOD.count
    }
    
    func countNewTicketsDod(component: Component? = nil) -> Int {
        if component == nil {
            return newIssuesDOD.count
        } else if let component = component {
            return newIssuesDOD.filter {
                $0.fields.components.first { $0.name == component.rawValue } != nil
            }.count
        }
        return 0
    }
    
    func countTicketsDodKO(component: Component? = nil) -> Int {
        if component == nil {
            return issuesInProgress.count
        } else if let component = component {
            return issuesInProgress.filter {
                $0.fields.components.first { $0.name == component.rawValue } != nil
            }.count
        }
        return 0
    }
    
    func retrieveEstimationField(sprint: Int, completion: ((String?) -> Void)?){
        RequestManager.shared.getFirstEstimatedIssue(sprint: sprint) { (issue) in
            guard let issue = issue else {
                completion?(nil)
                return
            }
            
            RequestManager.shared.getEstimation(issue: issue.id) { (estimation) in
                guard let estimation = estimation else {
                    completion?(nil)
                    return
                }
                
                self.estimationField = estimation.fieldId
                completion?(self.estimationField)
            }
        }
    }
    
    func calculateVelocity(component: Component? = nil) -> Int {
        guard let field = self.estimationField else {
            return 0
        }
        if component == nil {
            let estimations = newIssuesDOD.map {
                $0.fields.extra[field] as? Int ?? 0 }
            return estimations.reduce(0, +)
        } else if let component = component {
            let estimations:[Int] = newIssuesDOD.map {
                if $0.fields.components.first?.name == component.rawValue {
                    return $0.fields.extra[field] as? Int ?? 0
                }
                return 0
            }
            return estimations.reduce(0, +)
        }
        
        return 0
    }
    
    func countTickets(component: Component) -> Int {
        guard let issues = issues?.issues else {
            return 0
        }
        let tickets = issues.filter {
            let matching = $0.fields.components.filter { $0.name == component.rawValue }
            return matching.count > 0
        }
        return tickets.count
    }
    
    func countAddedBug(component: Component) -> Int {
        let list = newIssuesSprint.filter {
            let type = [IssueType.anomalie.rawValue, IssueType.bugRecette.rawValue].contains($0.fields.issuetype.name)
            let component = $0.fields.components.first { $0.name == component.rawValue }
            return type && component != nil
        }
        return list.count
    }
}
