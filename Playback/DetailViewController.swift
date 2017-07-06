//
//  DetailViewController.swift
//  Playback
//
//  Created by Christopher Truman on 6/29/17.
//  Copyright © 2017 Christopher Truman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        let webButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(openSafari))
        navigationItem.rightBarButtonItem = webButton
    }
    
    func openSafari() {
        if let detail = detailItem {
            UIApplication.shared.open(URL(string: detail)!)
        }
    }

    var detailItem: String? {
        didSet {
            configureView()
        }
    }


}

