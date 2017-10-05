//
//  MoviesCollectionViewCell.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import UIKit
import SDWebImage

class MoviesCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var imageView: UIImageView!

	func configure(viewModel: MovieViewModel) {
		imageView.sd_setImage(with: viewModel.imageUrl, completed: nil)
	}

}