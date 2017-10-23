//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
@testable import Example

class StubThrottle: Throttling {

    public var shouldReturnValue = true
    private(set) var didCallWithDelay: TimeInterval?
    private(set) var didCallWithObject: String?

    func value(withDelay delay: TimeInterval, object: String,  response: @escaping (String)->()) {
        didCallWithDelay = delay
        didCallWithObject = object
        if shouldReturnValue == true {
            response(object)
        }
    }
}
