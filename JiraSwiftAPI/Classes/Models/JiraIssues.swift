//
//  JiraIssues.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public struct JiraIssues: JiraObject {
    
    
    public let expand: String
    public let startAt: Int
    public let maxResults: Int
    public let total: Int
    public var issues:[JiraIssue]
    
    public static func parse(data: Data, extraFields: [String] = []) -> JiraObject? {
        do {
            var item = try JSONDecoder().decode(JiraIssues.self, from: data)
            
            if extraFields.count > 0 {
                do {
                    guard let obj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject],
                          let issuesList = obj["issues"] as? [[String: AnyObject]] else {
                        return item
                    }
                    var parsedIssues:[JiraIssue] = []
                    for json in issuesList {
                        let data = try JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                        guard let fields = json["fields"] as? [String:AnyObject],
                              var issue = JiraIssue.parse(data: data) as? JiraIssue else {
                            continue
                        }
                        
                        for extra in extraFields {
                            issue.fields.extra[extra] = fields[extra]
                        }
                        parsedIssues.append(issue)
                    }
                    item.issues = parsedIssues
                    return item
                } catch {
                    return item
                }
            }
            
            return item
        } catch {
            return nil
        }
    }
}

