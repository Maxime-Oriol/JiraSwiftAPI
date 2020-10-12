//
//  JiraRequest.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

class JiraRequest {
    
    public let cacheManager = JiraCacheManager()
    private let server: String
    private let token:String
    public let boardId:Int
    
    init(server: String, token: String, boardId: Int) {
        
        self.server = server
        self.token = token
        self.boardId = boardId
    }
    
    //MARK: -- Cache managment
    
    func enableCache(_ enabled: Bool) {
        self.cacheManager.enabled = enabled
    }
    
    func clearCache() {
        self.cacheManager.clear()
    }
    
    //MARK: -- Main method
    open func get(path: String, parameters: [JiraRequestQuery: String]?, completion: @escaping ((Data) -> Void)) {
        let route = self.compileRoute(path: path)
        let queryParameters:[URLQueryItem] = self.generateQueryString(parameters: parameters)
        var urlComponents = URLComponents(string: server+route)
        if queryParameters.count > 0 {
            urlComponents?.queryItems = queryParameters
        }
        guard let url = urlComponents?.url else {
            print("Unable to build request url with query items")
            return
        }
        
        guard self.cacheManager.value(route: url.absoluteString) == nil else {
            if let cache = self.cacheManager.value(route: route) as? Data {
                completion(cache)
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic "+token, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let responseData = data {
                if self.cacheManager.enabled {
                    self.cacheManager.preserve(route: url.absoluteString, data: responseData)
                }
                
                completion(responseData)
                
            } else if error != nil {
                print(error!.localizedDescription)
            }
        }.resume()
    }
    
    open func compileRoute(path: String) -> String {
        return path.replacingOccurrences(of: "{boardId}", with: String(self.boardId))
    }
    
    open func generateQueryString(parameters: [JiraRequestQuery: String]?) -> [URLQueryItem] {
        guard let parameters = parameters else {
            return []
        }
        
        var params:[URLQueryItem] = []
        parameters.forEach {
            let query = URLQueryItem(name: $0.key.rawValue, value: $0.value)
            params.append(query)
        }
        return params
    }
}
