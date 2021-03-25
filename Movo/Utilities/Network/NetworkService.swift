//
//  DataService.swift
//  HooleyAPIs
//
//  Created by Usama Sadiq on 1/3/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

enum RequestType:String {
    
    case post = "POST"
    case get = "GET"
}
typealias Parameters = Dictionary<String,Any>

let session = URLSession.shared

class NetworkService {
    
    static let shared = NetworkService()
    
    func fetchData(requestType:RequestType,fromURL urlStr:String,parameters:Dictionary<String,Any>,completionHandler:@escaping (_ error:Error?, _ jsonData:Data?, _ statusCode:Int?)->Void) -> Void {

        guard let urlString = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        
        if requestType.rawValue == RequestType.post.rawValue{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }else{
            request.cachePolicy =  ReachabilityTest.isConnectedToNetwork() ? .useProtocolCachePolicy : .returnCacheDataDontLoad
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let profile = ProfileDetails.instance.getProfileDetails(){
            print(profile.accessToken)
            request.addValue("Bearer \(profile.accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            var statusCode : Int?

            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                print("statusCode: \(httpResponse.statusCode)")
                
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 401 {
                        print("Logout")
                        if !urlStr.contains(API.Account.logout) {
                            ProfileDetails.instance.removeProfileOnLogout()
                            ModeSelection.instance.signupMode()
                            return
                        }
                    }
                }
            }
            
            if let error = error{
                completionHandler(error, nil, statusCode)
            }else{
                completionHandler(nil, data, statusCode)
            }
        })
        
        task.resume()
        
    }
    
    func postRequest(fromURL urlStr:String,media:[Media], parameters:Parameters?,completionHandler:@escaping (_ error:Error?, _ jsonData:Data?, _ statusCode:Int?)->Void) {

        
        guard let url = URL(string: urlStr) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let profile = ProfileDetails.instance.getProfileDetails(){
            print(profile.accessToken)
            request.addValue("\(profile.accessToken)", forHTTPHeaderField: "authorization")
        }
        
        let dataBody = createDataBody(withParameters: parameters, media: media, boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            var statusCode : Int?
            if let httpResponse = response as? HTTPURLResponse {
                statusCode = httpResponse.statusCode
                
                print("statusCode: \(httpResponse.statusCode)")
                
                let stringHeader = HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                print(stringHeader)
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 401 {
                        if !urlStr.contains(API.Account.logout) {
                            ProfileDetails.instance.removeProfileOnLogout()
                            ModeSelection.instance.signupMode()
                            return
                        }
                    }
                }
            }
            
            if let error = error{
                completionHandler(error, nil, statusCode)
            }else{
                completionHandler(nil, data, statusCode)
            }
        }
        task.resume()
    }
    
    private func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    private func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)" + "\(lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
}


