//
//  JiraIssueHistory.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 13/10/2020.
//

public struct JiraIssueHistory: JiraObject {
    
    public let id: String
    private let _created: String?
    public let items: [JiraHistoryItem]
    
    public var created: Date? {
        guard let date = _created else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        return formatter.date(from: date)
    }
    
    public enum CodingKeys: String, CodingKey {
        case id        = "id"
        case _created  = "created"
        case items     = "items"
    }
    
    public static func parse(data: Data) -> JiraObject? {
        do {
            return try JSONDecoder().decode(JiraIssueHistory.self, from: data)
        } catch {
            return nil
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        _created = try container.decode(String.self, forKey: ._created)
        items = try container.decode(Array<JiraHistoryItem>.self, forKey: .items)
        
    }
}
