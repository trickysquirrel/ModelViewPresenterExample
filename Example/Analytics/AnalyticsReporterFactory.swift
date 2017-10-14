//
//  Created by Richard Moult on 5/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct AnalyticsReporterFactory {

    let adobeAnalyticsReporter: AdobeAnalyticsReporting

    func makeAssetCollectionReporter() -> MovieCollectionReporter {
        return MovieCollectionReporter(adobeAnalyticsReporter: adobeAnalyticsReporter)
    }
}
