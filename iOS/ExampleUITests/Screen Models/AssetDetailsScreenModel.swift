//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example

class AssetDetailsScreenModel: ViewControllerScreenModel {

    // MARK: - UI Elements

    private var assetTitle: XCUIElement {
        return app.staticTexts[Accessibility.assetDetailsView.id]
    }

    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    override func screenIdentifyingElements() -> [XCUIElement] {
        return [assetTitle]
    }

    // MARK: Verifications


    // MARK: Actions

}

