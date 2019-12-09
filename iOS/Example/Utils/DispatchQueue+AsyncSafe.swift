//
//  Copyright © 2019 Richard Moult. All rights reserved.
//

import Foundation

public extension DispatchQueue {

    func asyncSafe(execute work: @escaping @convention(block) () -> Void) {
        if OperationQueue.current?.underlyingQueue == self {
            work()
        } else {
            self.async {
                work()
            }
        }
    }
}
