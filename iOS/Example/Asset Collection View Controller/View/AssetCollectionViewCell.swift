//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit

class AssetCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = "MovieCell"

	@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!

	func configure(viewModel: AssetViewModel) {
        imageView.setImage(from: viewModel.imageUrl)
        labelTitle.text = viewModel.title
	}

}
