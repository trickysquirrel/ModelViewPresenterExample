//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

protocol LifecycleReporting {
    func viewDidAppear()
}

struct LifecycleReporter: LifecycleReporting {

    let reporter: AnalyticsReporting
    let name: String

    func viewDidAppear() {
        reporter.sendAction(name: name, data: ["lifecycle": "show"])
    }
}
