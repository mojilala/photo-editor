//
//  StickerCollectionViewCell.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 4/23/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit
import SDWebImage

class StickerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stickerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setStickerImage(from url: String) {
        stickerImage.sd_setShowActivityIndicatorView(true)
        stickerImage.sd_setIndicatorStyle(.gray)
        stickerImage.sd_setImage(with: URL(string: url))
    }

}
