//
//  RandomerService.swift
//  Randomers
//
//  Created by ChengRosman on 29/05/20.
//  Copyright © 2020 Rosman Cheng. All rights reserved.
//

import Foundation
import AFNetworking
import SQLite3

typealias CompletionBlock = () -> Void

class RandomerService: NSObject
{
    private var pageIndex = 0
    private var pageSize = 10
    
    // I have not found the search APIs, so this is not done
    private var keyWord: String?

    let randomers: NSMutableArray = NSMutableArray();
    
    func resetPage() {
        pageIndex = 0
        randomers.removeAllObjects()
    }
    
    func setupKeyWord(keyWord: String?) {
        self.keyWord = keyWord
    }
    
    func fetchRandomers(finished: @escaping (_ succeed: Bool) -> Void)
    {
        let manager = AFHTTPSessionManager()
        let url = Environment.shared.baseUrl
        
        manager.get(
            url,
            parameters: ["page": pageIndex, "results": pageSize],
            headers: nil,
            progress: nil,
            success: { [weak self] (operation: URLSessionDataTask, response: Any?) in
                if let responseObject = response as? NSDictionary {
                    let results = responseObject["results"] as! [Any]
                    self?.randomers.addObjects(from: results)
                    self?.pageIndex += 1
                }
                finished(true)
            },
            failure: { (operation: URLSessionDataTask?, error: Error) in
                print("Error: " + error.localizedDescription)
                finished(false)
            }
        )
    }
    
    // I don't have too much time to do Sqlite/Offline features due to time limitation
    func fetchOfflineRandomers() {
        
    }
}
