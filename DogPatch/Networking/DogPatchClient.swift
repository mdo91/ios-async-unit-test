//
//  DogPatchClient.swift
//  DogPatch
//
//  Created by Mdo on 26/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import Foundation

protocol DogPatchService {
    func getDogs(completion: @escaping([Dog]?, Error?)->Void)->URLSessionDataTask
}
protocol DataTaskMaker {
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
extension URLSession:DataTaskMaker{}
class DogpatchClient{
    
    let baseURL:URL
    let session:DataTaskMaker
    let responseQueue:DispatchQueue?
    
    static let shared = DogpatchClient(baseURL: URL(string: "https://dogpatchserver.herokuapp.com/api/v1/")!, session: URLSession.shared, responseQueue: .main)
    
    init(baseURL:URL,
         session:DataTaskMaker,
         responseQueue:DispatchQueue?) {
        self.session = session
        self.baseURL = baseURL
        self.responseQueue = responseQueue
    }
    
    func getDogs(completion:
        @escaping ([Dog]?, Error?) -> Void) -> URLSessionDataTask {
        
        let url = URL(string: "dogs", relativeTo: baseURL)!
        let task = session.dataTask(with: url){ [weak self] data, response, error in
            guard let self =  self else{ return}
            guard let response = response as? HTTPURLResponse, response.statusCode == 200,
            error == nil, let data = data else{
                self.dispatchResult(error: error, completion: completion)
                return
                
            }
            let decoder = JSONDecoder()
            do{
                let dogs =  try decoder.decode([Dog].self, from: data)
                self.dispatchResult(models: dogs, completion: completion)
            } catch{
                self.dispatchResult(error: error, completion: completion)
            }
            
        }
        task.resume()
        return task
    }
    
    private func dispatchResult<Type>(
        models: Type? = nil,
        error:Error? = nil,
        completion: @escaping (Type?, Error?)-> Void){
        guard let responseQueue = responseQueue else{
            completion(models,error)
            return
        }
        
        responseQueue.async {
            completion(models,error)
        }
    }
    
}

extension DogpatchClient:DogPatchService{
    
    
}
