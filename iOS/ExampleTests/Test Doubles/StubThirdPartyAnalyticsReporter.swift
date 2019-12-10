//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class StubThirdPartyAnalyticsReporter: AnalyticsReporting {

    private(set) var sentActionList: [(name: String, data: [String:Any]?)] = []

    func sendAction(name: String, data: [String:Any]?) {
        sentActionList.append((name:name, data:data))
    }
}

