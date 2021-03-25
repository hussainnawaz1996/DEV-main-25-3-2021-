//
//  WebAPIs.swift
//  HooleyAPIs
//
//  Created by Usama Sadiq on 1/8/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

struct ResponseModel{
    var isSuccessful : Bool!
    var exception : String!
}


typealias CompletionHandlerSuccessResponse = (_ error:Error?, _ responseModel:ResponseModel?)->Void
class WebAPIs {
    static let shared = WebAPIs()
    
    typealias completionHandler = (_ error:Error?,_ jsonResponse:Dictionary<String,Any>?) -> ()
    
//
//    func getUSStateCities(completionHandler:@escaping (_ error:Error?, _ stateCityModel:GetStateCitiesModels?) -> Void) {
//
//        if let path = Bundle.main.path(forResource: "citystatecountry", ofType: "json") {
//            do {
//
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                do {
//                    let responseModel = try JSONDecoder().decode(GetStateCitiesModels.self, from: data)
//                    completionHandler(nil, responseModel)
//                } catch let error {
//                    completionHandler(error, nil)
//                }
//            } catch {
//                completionHandler(error, nil)
//            }
//        }
//
//    }
    
}
