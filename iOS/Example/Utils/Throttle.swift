//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


protocol Throttling {
    func value(withDelay delay: TimeInterval, object: String,  response: @escaping (String)->())
}


class Throttle: Throttling {

    private var throttleTimer: Timer?

    func value(withDelay delay: TimeInterval, object: String,  response: @escaping (String)->()) {
        throttleTimer?.invalidate()
        throttleTimer = nil
        if #available(iOS 10.0, *) {
            throttleTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
                response(object)
            }
        } else {
            // Fallback on earlier versions
        }
    }

}
