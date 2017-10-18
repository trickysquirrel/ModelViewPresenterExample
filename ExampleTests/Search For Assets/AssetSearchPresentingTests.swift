//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest

class AssetSearchPresentingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
    }

    // first returns  loading=true
    // if search string less than 3, return information to enter more characters
    // if search string >= 3 then make request for information
    // if new search string = old search string do nothing
    // if error return loading=false, error title,msg
    // if success and no data return loading=false, userinfo = "no results please try again"
    // if success and data, return loading=false, success [viewModel]
    // if requesting another search then delete the old one and create a new one
    
}
