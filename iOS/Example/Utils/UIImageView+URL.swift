//
//  Created by Richard Moult on 10/12/19.
//

import UIKit
import SDWebImage

extension UIImageView {

    func setImage(from url: URL?, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.sd_setImage(with: url) { downLoadedImage, _, cacheType, _ in
            switch cacheType {
            case .disk, .memory:
                self.image = downLoadedImage
                completion?()
            case .none:
                fallthrough
            @unknown default:
                self.alpha = 0
                if animated {
                    UIView.transition(with: self, duration: 0.25, options: UIView.AnimationOptions.transitionCrossDissolve, animations: { () -> Void in
                        self.image = downLoadedImage
                        self.alpha = 1
                    }, completion: { _ in
                        completion?()
                    })
                } else {
                    self.image = downLoadedImage
                    self.alpha = 1
                    completion?()
                }
            }
        }
    }

}
