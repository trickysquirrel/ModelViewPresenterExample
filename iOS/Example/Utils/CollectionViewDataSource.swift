//
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
import UIKit


class CollectionViewDataSource<CellType, DataType>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource where CellType: UICollectionViewCell {

	typealias CellObjectClosure = (_ cell: CellType, _ object: DataType) -> ()
	typealias ObjectIndexPathClosure = (_ object: DataType, _ indexPath: IndexPath) -> ()
    typealias ObjectClosure = (_ object: DataType) -> (String)

	private var sections: [CollectionSection<DataType>] = []
    private var configureCellClosure: CellObjectClosure = { _, _ in }
    private var cellIdentifierClosure: ObjectClosure = { _ in return "closure not set" }
    private var selectCellClosure: ObjectIndexPathClosure = { _, _ in }
	private weak var collectionView: UICollectionView?

	func configure(collectionView: UICollectionView?) {
		self.collectionView = collectionView
		self.collectionView?.dataSource = self
		self.collectionView?.delegate = self
	}

    func reload(
        sections: [CollectionSection<DataType>],
        cellIdentifier: @escaping ObjectClosure,
        configureCell: @escaping CellObjectClosure,
        selectCell: @escaping ObjectIndexPathClosure
    ) {
        self.cellIdentifierClosure = cellIdentifier
        self.configureCellClosure = configureCell
        self.selectCellClosure = selectCell
        reloadData(sections: sections)
    }

	private func reloadData(sections: [CollectionSection<DataType>]) {
		guard let collectionView = collectionView else {
			print("warning collectionView nil please use configure");
			return
		}
		self.sections = sections
		collectionView.reloadData()
	}

	// MARK: table view delegate

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return sections.count
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sections[safe: section]?.rows.count ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let row = sections[safe:indexPath.section]?.rows[safe:indexPath.row] else { return UICollectionViewCell() }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifierClosure(row.data), for: indexPath) as? CellType else { return UICollectionViewCell() }
		configureCellClosure(cell, row.data)
		return cell
	}

	private func objectAtIndexPath(_ indexPath: IndexPath) -> DataType? {
		return sections[safe:indexPath.section]?.rows[safe:indexPath.row]?.data
	}

	// MARK: CollectionView delegate

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let viewModel = objectAtIndexPath(indexPath) {
			selectCellClosure(viewModel, indexPath)
		}
	}

}
