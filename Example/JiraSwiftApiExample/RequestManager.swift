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
        
        // Go there to create your token ; works only for cloud hosted projects :
        // https://id.atlassian.com/manage-profile/security/api-tokens
        let config = (
            server: "https://myAmazingProject.atlassian.net",
            username: "myPersonalLogin",
            token: "generatedPrivateToken",
            boardId: 1
        )
        
        self.jiraManager = try! JiraAPI(server: config.server, username: config.username, password: config.token, boardId: config.boardId)
        self.jiraManager.delegate = self
        self.jiraManager.enableCache(enabled: false)
    }
    
    func callAPI() {
        self.jiraManager.getConfiguration()
    }

}


extension RequestManager: JiraAPIDelegate {
    
    func didGetConfiguration(configuration: JiraConfiguration?) {
        guard let configuration = configuration else {
            print("There is no available configuration")
            return
        }
        
        print("Configuration name: "+configuration.name)
    }
}
