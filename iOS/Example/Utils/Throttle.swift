//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


protocol Throttling {
    func value(withDelay delay: TimeInterval, object: String, running runner: AsyncRunner<String>)
}


class Throttle: Throttling {

    private var throttleTimer: Timer?

    func value(
        withDelay delay: TimeInterval,
        object: String,
        running runner: AsyncRunner<String>) {

        throttleTimer?.invalidate()
        throttleTimer = nil
        throttleTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { (timer) in
            runner.run(object)
        }
    }

}
