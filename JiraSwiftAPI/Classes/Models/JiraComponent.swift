//
//  JiraComponent.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public struct JiraComponent: JiraObject {
    public var id: String
    public var name: String
    public var description: String?
    
    public static func parse(data: Data) -> JiraObject? {
        do {
        return try JSONDecoder().decode(JiraComponent.self, from: data)
        } catch {
            return nil
        }
    }
}
