//
//  MHCollectionViewCell.swift
//  MHCalendarDemo
//
//  Created by Luong Minh Hiep on 9/11/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

class MHCollectionViewCell: UICollectionViewCell {
    
    static func nibName() -> String {
        return String(describing: self)
    }
    
    static func identifier() -> String {
        return nibName()
    }

    static func register(to collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: nibName(), bundle: nil), forCellWithReuseIdentifier: identifier())
    }
    
    static func dequeue(from collectionView: UICollectionView, indexPath: IndexPath) -> MHCollectionViewCell? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier(), for: indexPath) as? MHCollectionViewCell
    }
    
    static func newCell() -> MHCollectionViewCell {
        let nibs = Bundle.main.loadNibNamed(nibName(), owner: self, options: nil)
        let cell = nibs?.first as? MHCollectionViewCell
        return cell!
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    var currentDate: Date!
    var isCellSelectable: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func selectedForLabelColor(_ color: UIColor) {
        titleLabel.layer.cornerRadius = titleLabel.frame.size.width/2
        titleLabel.layer.backgroundColor = color.cgColor
        titleLabel.textColor = UIColor.white
    }
    
    func deSelectedForLabelColor(_ color: UIColor) {
        titleLabel.layer.backgroundColor = UIColor.clear.cgColor
        titleLabel.textColor = color
    }
    
    
    func setTodayCellColor(_ backgroundColor: UIColor) {
        titleLabel.layer.cornerRadius = titleLabel.frame.size.width/2
        titleLabel.layer.backgroundColor = backgroundColor.cgColor
        titleLabel.textColor  = UIColor.white
    }
}
