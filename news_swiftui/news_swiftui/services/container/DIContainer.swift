//
//  DIContainer.swift
//  MoviesSearch
//
//  Created by 1 on 16.02.2019.
//  Copyright © 2019 1. All rights reserved.
//

import UIKit

protocol IDIContainer {
    var networkService: INetworkService { get }
    var networkConfiguration: INetworkConfiguration { get }
}

class DIContainer: IDIContainer {
    lazy var networkService: INetworkService  = {
        return NetworkService()
    }()
    
    lazy var networkConfiguration: INetworkConfiguration = {
        return NetworkConfiguration()
    }()
}
