//
//  AnalyticsReporterFactory.swift
//  Example
//
//  Created by Richard Moult on 5/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


protocol AnalyticsReporterFactoryProtocol {
    func makeAssetCollectionReporter() -> AssetCollectionReporter
}


struct AnalyticsReporterFactory: AnalyticsReporterFactoryProtocol {

    // this should have access to 3rd party lib that can send info

    func makeAssetCollectionReporter() -> AssetCollectionReporter {
        return AssetCollectionReporter()
    }
}
