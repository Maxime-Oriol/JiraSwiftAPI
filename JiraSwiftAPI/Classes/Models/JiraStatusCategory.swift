//
//  JiraStatusCategory.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public struct JiraStatusCategory: JiraObject {
    public var id: Int
    public var key: String
    public var colorName: String
    public var name: String
    
    public static func parse(data: Data) -> JiraObject? {
        do {
            return try JSONDecoder().decode(JiraStatusCategory.self, from: data)
        } catch {
            return nil
        }
    }
}
