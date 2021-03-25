//
//  HooleyPostApi.swift
//  hooley
//
//  Created by Usama Sadiq on 10/25/18.
//  Copyright © 2018 messagemuse. All rights reserved.
//

import Foundation

class HooleyAPIGeneric<response: Codable> {
    
    static func fetchRequest(apiURL:String ,onCompletion: @escaping (Result<response,Error>) -> Void) {
        print(apiURL)
        NetworkService.shared.fetchData(requestType: .get, fromURL: apiURL, parameters: [:]) { (error:Error?, jsonData:Data?, statusCode: Int?) in
            
            if let err = error {
                let errr = CustomError(description: err.localizedDescription)
                onCompletion(.failure(errr))
            }else{
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: jsonData!, options: [])
                    print(jsonResponse)

                    if statusCode == 200 {
                        let responseModel = try JSONDecoder().decode(response.self, from: jsonData!)
                        onCompletion(.success(responseModel))
                    } else {
                        let responseModel = try JSONDecoder().decode(NotSuccessModel.self, from: jsonData!)
                        let error = CustomError(description: responseModel.messages ?? "")
                        onCompletion(.failure(error))
                    }
                } catch let error {
                    let err = CustomError(description: error.localizedDescription)
                    onCompletion(.failure(err))
                }
            }
        }
    }
}

class HooleyPostAPIGeneric<request: Codable,response: Codable> {
    
    static func postRequest(apiURL:String, requestModel:request,onCompletion: @escaping (Result<response,Error>) -> Void) {

        guard let parameters = requestModel.dictionary else { return }
        
        print(parameters.convertToJSONString())
        NetworkService.shared.fetchData(requestType: .post, fromURL: apiURL, parameters: parameters) { (error:Error?, jsonData:Data?, statusCode:Int?) in
            if let err = error{
                let errr = CustomError(description: err.localizedDescription)
                onCompletion(.failure(errr))
            }else{
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: jsonData!, options: [])
                    print(jsonResponse)
                    
                    if statusCode == 200 {
                        let responseModel = try JSONDecoder().decode(response.self, from: jsonData!)
                        onCompletion(.success(responseModel))
                    } else {
                        let responseModel = try JSONDecoder().decode(NotSuccessModel.self, from: jsonData!)
                        let error = CustomError(description: responseModel.messages ?? "")
                        onCompletion(.failure(error))
                    }
                } catch let error {
                    let errr = CustomError(description: error.localizedDescription)
                    onCompletion(.failure(errr))
                }
            }
        }
    }
}

class HooleyPostMultipartAPIGeneric<request: Codable,response: Codable> {
    
    static func fetchRequest(key:String? = nil, apiURL:String, media:[Media], requestModel:request, onCompletion: @escaping (Result<response,Error>) -> Void) {

        guard let parameters = requestModel.dictionary else { return }

        print(parameters.convertToJSONString())
        NetworkService.shared.postRequest(fromURL: apiURL, media: media, parameters: parameters) { (error:Error?, jsonData:Data?, statusCode:Int?) in
            if let err = error{
                let errr = CustomError(description: err.localizedDescription)
                onCompletion(.failure(errr))
            }else{
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: jsonData!, options: [])
                    print(jsonResponse)

                    if statusCode == 200 {
                        let responseModel = try JSONDecoder().decode(response.self, from: jsonData!)
                        onCompletion(.success(responseModel))
                    } else {
                        let responseModel = try JSONDecoder().decode(NotSuccessModel.self, from: jsonData!)
                        let error = CustomError(description: responseModel.messages ?? "")
                        onCompletion(.failure(error))
                    }
                } catch let error {
                    let errr = CustomError(description: error.localizedDescription)
                    onCompletion(.failure(errr))
                }
            }
        }
    }

}
