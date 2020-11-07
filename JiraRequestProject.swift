//
//  JiraRequestProject.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 15/10/2020.
//

extension JiraRequest {
    // GET /rest/agile/1.0/board/{boardId}/version

    // Returns all versions from a board, for a given board ID. This only includes versions that the user has permission to view. Note, if the user does not have permission to view the board, no versions will be returned at all. Returned versions are ordered by the name of the project from which they belong and then by sequence defined by user.
    func getVersions(completion: (([JiraVersion]) -> Void)?) {
        
        let builder = JiraRequestBuilder()
        builder.path = "/rest/api/2/project/{projectIdOrKey}/versions"
        
        self.execute(request: builder) { (result) in
            do {
                let versions = try JSONDecoder().decode(Array<JiraVersion>.self, from: result)
                completion?(versions)
            } catch {
                completion?([])
            }
        }
    }
    
    func updateVersion(version: JiraVersion, completion: ((JiraVersion?) -> Void)?) {
        do {
            let data = try JSONEncoder().encode(version)
            
            let builder = JiraRequestBuilder()
            builder.path = "/rest/api/2/version/"+String(version.id)
            builder.method = .put
            builder.data = data
            
            self.execute(request: builder) { (data) in
                guard let version = JiraVersion.parse(data: data) as? JiraVersion else {
                    completion?(nil)
                    return
                }
                completion?(version)
            }
            
        } catch {
            print("Error while encoding Version")
            completion?(nil)
            return
        }
    }
}
