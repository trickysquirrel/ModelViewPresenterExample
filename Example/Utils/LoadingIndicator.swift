//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit
import MBProgressHUD


protocol LoadingIndicatorProtocol {
    func statusBar(_ loading: Bool)
    func view(view: UIView, loading: Bool)
}


struct LoadingIndicator: LoadingIndicatorProtocol {

    func statusBar(_ loading: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = loading
    }

    func view(view: UIView, loading: Bool) {
        if loading {
            MBProgressHUD.showAdded(to: view, animated: true)
        }
        else {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
}
