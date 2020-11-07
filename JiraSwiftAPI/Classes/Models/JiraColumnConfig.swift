//
//  JiraColumnConfig.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 11/10/2020.
//

public struct JiraColumnConfig: JiraObject {
    public var columns:[JiraColumn]
    
    public static func parse(data: Data) -> JiraObject? {
        do {
            return try JSONDecoder().decode(JiraColumnConfig.self, from: data)
        } catch {
            return nil
        }
    }
}
