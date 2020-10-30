//
//  AsynchronounsTestCase.swift
//  AsynchronounsTestCase
//
//  Created by Mdo on 30/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import XCTest
@testable import DogPatch
class AsynchronounsTestCase: XCTestCase {


    var expectation:XCTestExpectation!
    let timeOut:TimeInterval = 2
    
    override func setUp() {
        super.setUp()
        
        expectation = expectation(description: "Server response in reasonable time!")
    }
    
    func test_noServerResponse(){
        
        let url = URL(string: "doggone")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.expectation.fulfill()}
            
            
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            XCTAssertNil(response)
        }.resume()
        
        waitForExpectations(timeout: timeOut)
    }
    
    func test_decodeDogs(){
        
        let url = URL(string: "https://dogpatchserver.herokuapp.com/api/v1/dogs")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            defer {self.expectation.fulfill()}
            
            XCTAssertNil(error)
            
            do{
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                XCTAssertNoThrow(
                              try JSONDecoder().decode([Dog].self, from: try XCTUnwrap(data))
                )
  
            }catch{
            
                
            }
            
            
            
        }.resume()
        
        waitForExpectations(timeout: timeOut)
        
    }
    
    func test_404(){
         let url = URL(string: "https://dogpatchserver.herokuapp.com/api/v1/cats")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.expectation.fulfill()}
            XCTAssertNil(error)
            do{
               let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 404)
                
                XCTAssertThrowsError(
                    try JSONDecoder().decode([Dog].self, from: try XCTUnwrap(data))
                ){ error in
                    
                    guard case DecodingError.typeMismatch = error else{
                        XCTFail("\(error)")
                        return
                    }
                    
                }
            }catch{
                
            }
        }.resume()
        
        waitForExpectations(timeout: timeOut)
        
    }
    
    func test_decodeDogtors(){
        struct OrthopedicDogtor: Decodable {
          let id: String
          let sellerID: String
          let about: String
          let birthday: Date
          let breed: String
          let breederRating: Double
          let cost: Decimal
          let created: Date
          let imageURL: URL
          let name: String

          let bones: [Int]
        }
        
        let url = URL(string: "https://dogpatchserver.herokuapp.com/api/v1/dogs")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            defer { self.expectation.fulfill()}
            XCTAssertNil(error)
            do{
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                let data = try XCTUnwrap(data)
                
                _ = try JSONDecoder().decode([OrthopedicDogtor].self, from: data)
            }catch{
                switch error{
                    
                case DecodingError.keyNotFound(let key, _): XCTAssertEqual(key.stringValue, "bones")
                default: XCTFail("error unknown: \(error)")
                }
            }
        }.resume()
        
        waitForExpectations(timeout: timeOut)
        
    }
    
    func test_client()throws{
        
        struct FakeDataMaker:DataTaskMaker{
            let data:Data
            static let dummtURL: URL = URL(string: "dummy")!
            init()throws{
                let testBundle = Bundle(for: AsynchronounsTestCase.self)
                let url = try XCTUnwrap(testBundle.url(forResource: "dogs", withExtension: "json"))
                data = try Data(contentsOf: url)
                
            }
            func dataTask(with _: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
                
               
                completionHandler(data,HTTPURLResponse(url: Self.dummtURL, statusCode: 200, httpVersion: nil, headerFields: nil),
                                  nil
                )
                final class FakeDataTask:URLSessionDataTask{
                    
                    override init(){
                        
                    }
                }
                
                return FakeDataTask()
            }
            
            
            
        }
        
        _ = DogpatchClient(baseURL: FakeDataMaker.dummtURL, session: try FakeDataMaker(), responseQueue: nil).getDogs(completion: { (dogs, error) in
            defer {self.expectation.fulfill()}
            
            XCTAssertEqual(dogs?.count, 4)
            XCTAssertNil(error)
            
        })
        
        waitForExpectations(timeout: timeOut)
        
    }

}
