//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

extension Collection {

	/// Returns the element at the specified index iff it is within bounds, otherwise nil.
	subscript (safe index: Index) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
