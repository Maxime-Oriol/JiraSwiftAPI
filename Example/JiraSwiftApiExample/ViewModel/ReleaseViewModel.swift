//
//  ReleaseViewModel.swift
//  JiraSwiftApiExample
//
//  Created by ORIOL.OMNILOG, MAXIME on 15/10/2020.
//

import JiraSwiftAPI

class ReleaseViewModel {
    
    private var allVersions:[JiraVersion] = []
    
    func getReleasesForDropdown(completion: (([JiraVersion]) -> Void)?) {
        RequestManager.shared.getUnreleasedVersions { [weak self] (versions) in
            guard let weakSelf = self else {
                self?.allVersions = []
                completion?(self?.allVersions ?? [])
                return
            }
            weakSelf.allVersions = versions
            completion?(weakSelf.allVersions)
        }
    }
    
    func getVersionFrom(index: Int) -> JiraVersion? {
        return allVersions[index]
    }
    
    func releaseVersion(version: JiraVersion, date: Date, completion: (([JiraVersion]) -> Void)?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: date)
        
        version.setReleased(at: dateStr)
        RequestManager.shared.updateVersion(version: version) { [weak self] (version) in
            guard let version = version,
                  let self = self else {
                completion?([])
                return
            }
            let index = self.allVersions.firstIndex { $0.id == version.id }
            guard index != nil else {
                completion?(self.allVersions)
                return
            }
            self.allVersions.remove(at: index!)
            completion?(self.allVersions)
        }
    }
    
    func changelogRequest(version: JiraVersion) -> URLRequest? {
        let absoluteString = Configuration.server+"/secure/ReleaseNote.jspa?projectId="+String(version.projectId)+"&version="+version.id
        guard let url = URL(string: absoluteString) else {
            return nil
        }
        
        let tokenSource = Configuration.username+":"+Configuration.token
        guard let data = tokenSource.data(using: .utf8) else {
            return nil
        }
        let token = data.base64EncodedString()
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic "+token, forHTTPHeaderField: "Authorization")
        
        return request
    }
}
