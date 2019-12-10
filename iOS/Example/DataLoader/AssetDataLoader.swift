//
//  AssetDataLoader.swift
//  Example
//
//  Created by Richard Moult on 10/12/19.
//  Copyright © 2019 Richard Moult. All rights reserved.
//

import Foundation

struct AssetDataLoader<T> where T: Decodable {

    private let resource: String

    init(resource: String) {
        self.resource = resource
    }

    func load(running runner: AsyncRunner<Result<T, Error>>) {

        let generalError = NSError(domain: "Could not load data from resource file", code: 0, userInfo: nil)
        guard let location = Bundle.main.path(forResource: resource, ofType: "json") else {
            runner.run(.failure(generalError))
            return
        }

        let resourceUrl = URL(fileURLWithPath: location)

        guard
            let data = try? Data(contentsOf: resourceUrl),
            let dataModel = try? JSONDecoder().decode(T.self, from: data) else {
                runner.run(.failure(generalError))
                return
        }

        // adding in a delay before responding to simulate network delays
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            runner.run(.success(dataModel))
        }
    }
}
