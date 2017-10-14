//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation


struct CollectionRow<T> {
	let data:T
	let cellIdentifier: String
}


struct CollectionSection<T> {
	let title: String?
	let rows:[CollectionRow<T>]
}
