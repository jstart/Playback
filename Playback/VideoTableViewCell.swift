//
//  VideoTableViewCell.swift
//  Playback
//
//  Created by Christopher Truman on 7/6/17.
//  Copyright © 2017 Christopher Truman. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var callout: UILabel!
    
    func configure(title: String, url: String) {
        self.title.text = title
        callout.text = url
    }
}
