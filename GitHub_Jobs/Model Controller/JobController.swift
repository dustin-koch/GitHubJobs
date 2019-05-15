//
//  JobController.swift
//  GitHub_Jobs
//
//  Created by Dustin Koch on 5/14/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation

class JobController {
    
    //MARK: - Singleton
    static let shared = JobController()

    //MARK: - Properties
    let baseURL = URL(string: "https://jobs.github.com/positions.json?description=")
    var jobs: [Job]?
    var jobString: String = "iOS"
    var location: Any = "San Jose, CA"
    
    //MARK: - CRUD functions
    func fetchJobsWith(searchTerm: String, location: String, completion: @escaping () -> Void) {
        guard let url = baseURL else { return }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let descriptionSearchQuery = URLQueryItem(name: "description", value: searchTerm)
        let locationQuery = URLQueryItem(name: "location", value: location)
        components?.queryItems = [descriptionSearchQuery, locationQuery]
        
        guard let finalURL = components?.url else { return }
        print(finalURL)
        
        let dataTask = URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let jobsArray = try jsonDecoder.decode([Job].self, from: data)
                let newArray = jobsArray.compactMap({$0})
                self.jobs = newArray
                completion()
            } catch {
                print(error.localizedDescription)
                return
            }
        }
        dataTask.resume()    
    }//END OF FETCH JOBS
}//END OF CLASS
