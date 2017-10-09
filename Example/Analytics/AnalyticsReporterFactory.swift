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

    let adobeAnalyticsReporter: AdobeAnalyticsReporting

    func makeAssetCollectionReporter() -> AssetCollectionReporter {
        return AssetCollectionReporter(adobeAnalyticsReporter: adobeAnalyticsReporter)
    }
}
