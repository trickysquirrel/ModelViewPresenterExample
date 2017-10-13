//
//  AssetDetailsScreenObjectModel.swift
//  ExampleUITests
//
//  Created by Richard Moult on 13/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example

class AssetDetailsScreenObjectModel: ScreenObjectModel {

    // MARK: - UI Elements

    private var assetTitle: XCUIElement {
        return app.staticTexts[Access.assetDetailsView.id]
    }

    // MARK: - UI Elements to identiy screen when navigating and waiting for screen to appear

    override func screenIdentifyingElements() -> [XCUIElement] {
        return [assetTitle]
    }

    // MARK: verifications


    // MARK: actions

//    @discardableResult
//    func tapBack(fileStatic: StaticString = #file, file: String = #file, line: UInt = #line) -> ScreenObjectModel {
//        return NavigationBarObjectModel(context: context, parent: parent).tapBackButton(fileStatic: fileStatic, file: file, line: line)
//    }



}

