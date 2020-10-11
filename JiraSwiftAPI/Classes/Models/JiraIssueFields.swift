//
//  JiraIssueFields.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public struct JiraIssueFields: JiraObject {
    
    public var issuetype: JiraIssueType
    public var summary: String
    public var timespent: Int?
    public var aggregatetimespent: Int?
    public var status:JiraIssueStatus
    public var components: [JiraComponent]
    public var description: String
    public var timetracking: JiraTimeTracking
    public var closedSprints: [JiraSprint]?
    
    private var _statuscategorychangedate: String?
    private var _created: String
    
    public var statuscategorychangedate: Date? {
        guard let date = _statuscategorychangedate else {
            return nil
        }
        // 2018-11-20T10:46:09.189+01:00
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        return formatter.date(from: date)
    }
    
    public var created: Date? {
        // 2018-11-20T10:46:09.189+01:00
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        return formatter.date(from: _created)
    }
    
    public enum CodingKeys: String, CodingKey {
        case _statuscategorychangedate  = "statuscategorychangedate"
        case summary                    = "summary"
        case issuetype                  = "issuetype"
        case timespent                  = "timespent"
        case aggregatetimespent         = "aggregatetimespent"
        case _created                   = "created"
        case status                     = "status"
        case components                 = "components"
        case description                = "description"
        case timetracking               = "timetracking"
        case closedSprints              = "closedSprints"
    }
}
