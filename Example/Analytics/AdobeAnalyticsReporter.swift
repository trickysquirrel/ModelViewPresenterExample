//
//  AdobeAnalyticsReporter.swift
//  Example
//
//  Created by Richard Moult on 9/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

protocol AdobeAnalyticsReporting {
    func sendAction(name: String, data: [String:Any]?)
}

struct AdobeAnalyticsReporter: AdobeAnalyticsReporting {

    func sendAction(name: String, data: [String:Any]?) {
        // call adobe library here and pass on the data
    }
}
