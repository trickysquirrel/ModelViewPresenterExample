//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

protocol AppDispatching {
    func makeBackgroundQueue() -> DispatchQueue
    func runMainAsync(_ block:@escaping ()->())
}

struct AppDispatcher: AppDispatching {

    func makeBackgroundQueue() -> DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }

    func runMainAsync(_ block:@escaping ()->()) {
        DispatchQueue.main.async {
            block()
        }
    }

}
