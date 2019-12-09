//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit
import SDWebImage

class AssetCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "MovieCell"

	@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!

	func configure(viewModel: AssetViewModel) {
		imageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
        labelTitle.text = viewModel.title
	}

}
