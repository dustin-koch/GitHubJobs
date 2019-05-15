//
//  Job2.swift
//  GitHub_Jobs
//
//  Created by Dustin Koch on 5/14/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation

struct Job: Decodable, Equatable {
    let url: String?
    let company: String?
    let title: String?
    let description: String?
}

