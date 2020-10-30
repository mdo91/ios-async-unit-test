//
//  ImageClient.swift
//  DogPatch
//
//  Created by Mdo on 27/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

protocol ImageService {
    func downloadImage(from url:URL,
                       completion: @escaping (UIImage?, Error?) ->Void) ->URLSessionDataTask?
    
    func setImage(on imageView:UIImageView,
                  fromURL url:URL,
                  withPlaceHolder placeHolder: UIImage?)
}

class ImageClient {
    
    //MARK: Static properties
    static let shared = ImageClient(responseQueue: .main, session: .shared)
    //MARK: - Instance Properties
    var cachedImageForURL:[URL:UIImage]
    var cachedTaskForImageView: [UIImageView:URLSessionDataTask]
    
    var responseQueue:DispatchQueue?
    var session:URLSession

    init(responseQueue:DispatchQueue?,
         session:URLSession) {
        cachedImageForURL = [:]
        cachedTaskForImageView = [:]
        self.responseQueue = responseQueue
        self.session = session

    }
    
}
extension ImageClient: ImageService{
    func downloadImage(from url: URL, completion: @escaping (UIImage?, Error?) -> Void) -> URLSessionDataTask? {
        
        if let image = cachedImageForURL[url]{
            print("value is \(url)")
            completion(image,nil)
            return nil
        }
        let dataTask = session.dataTask(with: url){ data, response, error in
            if let data = data, let image = UIImage(data: data){
                
                self.cachedImageForURL[url] = image
                //todo dispatch
                self.dispatch(image:image,completion: completion)
            }else{
                
                self.dispatch(completion: completion)
            }
             
        }
        
        dataTask.resume()
        return dataTask
    }
    
    private func dispatch(image:UIImage? = nil,
                          error:Error? = nil,
                          completion:@escaping (UIImage?,Error?) -> Void){
        
        guard let responseQueue = responseQueue else{
            
            completion(image,error)
            return
        }
        
        responseQueue.async {
            completion(image,error)
        }
    }
    
    func setImage(on imageView: UIImageView, fromURL url: URL, withPlaceHolder placeHolder: UIImage?) {
       // print("url the value is: \(url)")
        cachedTaskForImageView[imageView]?.cancel()
        imageView.image = placeHolder
        cachedTaskForImageView[imageView] =
            downloadImage(from: url) {
            [weak self] image, error in
           
            guard let self = self else { return}
            self.cachedTaskForImageView[imageView] = nil
            
            guard let image = image else{
                print("set Image Failed with error: " + String(describing: error))
                return
            }
            
            imageView.image = image
            
        }
    }
      
}
