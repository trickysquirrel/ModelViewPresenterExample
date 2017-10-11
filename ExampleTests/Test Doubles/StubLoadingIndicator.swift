//
//  StubLoadingIndicator.swift
//  ExampleTests
//
//  Created by Richard Moult on 10/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import XCTest
@testable import Example


class StubLoadingIndicator: LoadingIndicatorProtocol {

    var didCallStatusBarWithLoading: Bool?
    var didCallViewWithLoading: Bool?
    var didCallViewWithView: UIView?

    func statusBar(_ loading: Bool) {
        didCallStatusBarWithLoading = loading
    }

    func view(view: UIView, loading: Bool) {
        didCallViewWithLoading = loading
        didCallViewWithView = view
    }

}
