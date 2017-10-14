//
//  Created by Richard Moult on 10/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class StubAdobeAnalyticsReporter: AdobeAnalyticsReporting {

    private(set) var sentActionList: [(name: String, data: [String:Any]?)] = []

    func sendAction(name: String, data: [String:Any]?) {
        sentActionList.append((name:name, data:data))
    }
}

