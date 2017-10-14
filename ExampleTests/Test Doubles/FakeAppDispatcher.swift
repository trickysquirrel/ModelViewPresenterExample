//
//  Created by Richard Moult on 12/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
@testable import Example

struct FakeAppDispatcher: AppDispatching {

    func makeBackgroundQueue() -> DispatchQueue {
        return DispatchQueue.main
    }

    func runMainAsync(_ block:@escaping ()->()) {
        block()
    }

}
