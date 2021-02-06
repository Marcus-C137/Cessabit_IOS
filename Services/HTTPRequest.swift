//
//  HTTPRequest.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/20/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import Foundation

enum HTTPError:Error{
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct HTTPRequest{
    let resourceURL: URL
    
    init(endpoint: String){
        let resourceString = "http://192.168.1.4/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else{ fatalError()}
        self.resourceURL = resourceURL
        
    }
    
    func post(_ messageToSave:Message, completion: @escaping(Result<Message, HTTPError>)->Void){
        do{
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(messageToSave)
            let dataTask = URLSession.shared.dataTask(with: urlRequest){data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let jsonData = data else{
                        completion(.failure(.responseProblem))
                        return
                }
                
                do{
                    let  messageData = try JSONDecoder().decode(Message.self, from: jsonData)
                    completion(.success(messageData))
                }catch{
                    completion(.failure(.decodingProblem))
                        
                }
                }
            dataTask.resume()
        }catch{
            completion(.failure(.encodingProblem))
        }
    }
    
    func getWiFiNetworks(completion: @escaping(Result<[Hol], Error>))
}
