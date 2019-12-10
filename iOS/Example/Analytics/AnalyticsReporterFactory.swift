//
//  Copyright © 2019 Richard Moult. All rights reserved.
//

import Foundation

/// A common place to make all reporters
/// By having all reporters generated in one place we can easily focus our testing in this area if we choose,
/// substituing LifecycleReporting for ViewController unit tests we only then need to test that the method is called and not the preceise side effects

struct AnalyticsReporterFactory {

    let reporter: AnalyticsReporting

    func makeAssetCollectionReporter() -> LifecycleReporting {
        return LifecycleReporter(reporter: reporter, name: "MoviesCollectionShown")
    }

    func makeSearchReporter() -> LifecycleReporting {
        return LifecycleReporter(reporter: reporter, name: "Search")
    }
}
