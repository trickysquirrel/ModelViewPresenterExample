//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation

extension Collection {

	/// Returns the element at the specified index if it is within bounds, otherwise nil.
	subscript (safe index: Index) -> Iterator.Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
