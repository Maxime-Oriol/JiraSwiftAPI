//
//  APIDelegate.swift
//  JiraSwiftApiExample
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

import Foundation
import JiraSwiftAPI

class RequestManager {
    private var jiraManager:JiraAPI
    private var previousSprint: JiraSprint?
    
    init() {
        // You have to create your own "Configuration" struct with credentials
        // Go there to create your token ; works only for cloud hosted projects :
        // https://id.atlassian.com/manage-profile/security/api-tokens
        
        
        self.jiraManager = try! JiraAPI(server: Configuration.server,
                                        username: Configuration.username,
                                        password: Configuration.token,
                                        boardId: Configuration.boardId)
        
        self.jiraManager.delegate = self
        self.jiraManager.enableCache(enabled: false)
    }
    
    func callAPI() {
        self.jiraManager.getAllVersions()
    }

}


extension RequestManager: JiraAPIDelegate {    
    
    func didGetAllVersions(versions: JiraVersions?) {
        guard let versions = versions else {
            print("There is no available versions")
            return
        }
        
        print("Versions are:")
        for version in versions.values {
            print(version.name)
        }
    }
}
