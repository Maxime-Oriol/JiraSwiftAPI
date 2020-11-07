//
//  JiraRequest.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

class JiraRequest {
    
    public let cacheManager = JiraCacheManager()
    let config:JiraRequestConfig
    
    
    init(server: String, token: String, boardId: Int, projectId: String) {
        config = JiraRequestConfig(server: server,
                                   token: token,
                                   boardId: boardId,
                                   projectId: projectId)
    }
    
    //MARK: -- Execute request
    open func execute(request: JiraRequestBuilder, completion: @escaping ((Data) -> Void)) {
        guard let urlRequest = request.build(config: config),
              let url = urlRequest.url?.absoluteString else {
            return
        }
        
        guard self.cacheManager.value(route: url) == nil else {
            if let cache = self.cacheManager.value(route: url) as? Data {
                completion(cache)
            }
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let responseData = data {
                if self.cacheManager.enabled  && request.method == .get {
                    self.cacheManager.preserve(route: url, data: responseData)
                }
                
                completion(responseData)
                
            } else if error != nil {
                print(error!.localizedDescription)
            }
        }.resume()
    }
    
    //MARK: -- Cache managment
    func enableCache(_ enabled: Bool) {
        self.cacheManager.enabled = enabled
    }
    
    func clearCache() {
        self.cacheManager.clear()
    }
}

struct JiraRequestConfig {
    let server: String
    let token:String
    let boardId:Int
    let projectId:String
}
