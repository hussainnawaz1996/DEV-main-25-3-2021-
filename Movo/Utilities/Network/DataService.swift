//
//  DataService.swift
//  HooleyAPIs
//
//  Created by Usama Sadiq on 1/3/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
//import GoogleSignIn

class DataService {
    
    static let shared = DataService()
    
    var categoryList: [Category] = [Category]()
    
    func fetchData(fromURL urlStr:String,parameters:Dictionary<String,Any>,completionHandler:@escaping (_ error:Error?, _ json:Dictionary<String,Any>?)->Void) -> Void {

        let url = URL(string: urlStr)!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        if let profile = ProfileDetails.instance.getProfileDetails(){
            request.addValue("\(profile.accessToken)", forHTTPHeaderField: "auth")
        }

        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            if let error = error{
                completionHandler(error, nil)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        completionHandler(nil, json)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completionHandler(error, nil)
                }
            }
        })

        task.resume()
    }
    
    
    func fetchGetData(fromURL urlStr:String, parameters:Dictionary<String,Any>?, completionHandler:@escaping (_ error:Error?, _ json:Dictionary<String,Any>?)->Void) -> Void {

        guard let url = URL(string: urlStr) else{
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy =  ReachabilityTest.isConnectedToNetwork() ? .useProtocolCachePolicy : .returnCacheDataDontLoad

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let profile = ProfileDetails.instance.getProfileDetails(){
            request.addValue("\(profile.accessToken)", forHTTPHeaderField: "auth")
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            if let error = error{
                completionHandler(error, nil)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        completionHandler(nil, json)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completionHandler(error, nil)
                }
            }
        })
        task.resume()
    }

    func postRequest(fromURL urlStr:String,media:[Media], parameters:Parameters?,completionHandler:@escaping (_ error:Error?, _ json:Dictionary<String,Any>?)->Void) {
        
        guard let url = URL(string: urlStr) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let profile = ProfileDetails.instance.getProfileDetails(){
            request.addValue("\(profile.accessToken)", forHTTPHeaderField: "auth")
        }
        
        let dataBody = createDataBody(withParameters: parameters, media: media, boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if let error = error{
                completionHandler(error, nil)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        completionHandler(nil, json)
                    }
                } catch let error {
                    print(error.localizedDescription)
                    completionHandler(error, nil)
                }
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

