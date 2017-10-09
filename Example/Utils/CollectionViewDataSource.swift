//
//  CollectionViewDataSource.swift
//  Example
//
//  Created by Richard Moult on 4/10/17.
//  Copyright © 2017 Richard Moult. All rights reserved.
//

import Foundation
import UIKit


class CollectionViewDataSource<CellType, DataType>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource where CellType: UICollectionViewCell {

	typealias ConfigureCellBlock = (_ cell: CellType, _ object: DataType) -> ()
	typealias SelectCellBlock = (_ object: DataType, _ indexPath: IndexPath) -> ()

	private var sections: [CollectionSection<DataType>] = []
	private var configureCellBlock: ConfigureCellBlock?
	private var selectCellBlock: SelectCellBlock?
	private weak var collectionView: UICollectionView?


	// MARK: Public methods

	func configure(collectionView: UICollectionView?) {
		self.collectionView = collectionView
		self.collectionView?.dataSource = self
		self.collectionView?.delegate = self
	}


	func reloadData(sections: [CollectionSection<DataType>]) {
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
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: row.cellIdentifier, for: indexPath) as? CellType else { return UICollectionViewCell() }
		configureCellBlock?(cell, row.data)
		return cell
	}


	func objectAtIndexPath(_ indexPath: IndexPath) -> DataType? {
		return sections[safe:indexPath.section]?.rows[safe:indexPath.row]?.data
	}

	// MARK: Update table row helpers

	func resetRows(viewModels: [DataType], cellIdentifier: String) {
		let collectionSections =  CollectionSection<DataType>(title: nil, rows: viewModels.map { CollectionRow<DataType>(data: $0, cellIdentifier: cellIdentifier) })
		reloadData(sections: [collectionSections])
	}

	// MARK: Event handlers

	func onEventConfigureCell(configureCell: @escaping ConfigureCellBlock) {
		configureCellBlock = configureCell
	}

	func onEventItemSelected(selectCell: @escaping SelectCellBlock) {
		selectCellBlock = selectCell
	}

	// MARK: CollectionView delegate

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let viewModel = objectAtIndexPath(indexPath) {
			selectCellBlock?(viewModel, indexPath)
		}
	}

}
