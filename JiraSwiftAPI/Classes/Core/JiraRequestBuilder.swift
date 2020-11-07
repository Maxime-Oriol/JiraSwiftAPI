//
//  JiraRequestBuilder.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 15/10/2020.
//

class JiraRequestBuilder {
    
    public var path: String = ""
    public var parameters: [JiraRequestQuery: String] = [:]
    public var method: JiraHttpMethod = .get
    public var data: Data? = nil
    
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
    
    func build(config: JiraRequestConfig) -> URLRequest? {
        let route = self.makeRoute(path: path, config: config)
        let queryParameters:[URLQueryItem] = self.generateQueryString(parameters: parameters)
        var urlComponents = URLComponents(string: config.server+route)
        if queryParameters.count > 0 {
            urlComponents?.queryItems = queryParameters
        }
        guard let url = urlComponents?.url else {
            print("Unable to build request url with query items")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic "+config.token, forHTTPHeaderField: "Authorization")
        request.httpBody = data
        
        return request
    }
    
    func makeRoute(path: String, config: JiraRequestConfig) -> String {
        let result = path.replacingOccurrences(of: "{boardId}", with: String(config.boardId))
            .replacingOccurrences(of: "{projectIdOrKey}", with: config.projectId)
        
        return result
        //
    }
}
