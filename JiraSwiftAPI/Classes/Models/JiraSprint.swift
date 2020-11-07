//
//  JiraSprint.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

public struct JiraSprint: JiraObject {
    
    public var id: Int
    public var link: URL
    public var state:JiraSprintState
    public var name:String
    private var _startDate:String?
    private var _endDate:String?
    
    public var startDate: Date? {
        guard let date = _startDate else {
            return nil
        }
        // 2018-11-20T10:46:09.189+01:00
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: date)
    }
    
    public var endDate: Date? {
        guard let date = _endDate else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        return formatter.date(from: date)
    }
    
    public enum CodingKeys: String, CodingKey {
        case id        = "id"
        case link      = "self"
        case state     = "state"
        case name      = "name"
        case _startDate = "startDate"
        case _endDate   = "endDate"
    }
    
    public static func parse(data: Data) -> JiraObject? {
        do {
            return try JSONDecoder().decode(JiraSprint.self, from: data)
        } catch {
            return nil
        }
    }
}
