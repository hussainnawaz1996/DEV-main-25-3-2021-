//
//  URLSession+Extension.swift
//  Movo
//
//  Created by Ahmad on 14/12/2020.
//

import Foundation


extension URLSession {
    
    func cancelRequest(withURL urlString:String) -> Void {
        session.getAllTasks { (sessionTasksList) in
            sessionTasksList.forEach({ (sessionTask) in
                if let url = sessionTask.originalRequest?.url {
                    if url.absoluteString.contains(urlString) {
                        sessionTask.cancel()
                    }
                }
            })
        }
    }
}
