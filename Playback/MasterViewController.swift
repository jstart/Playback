//
//  MasterViewController.swift
//  Playback
//
//  Created by Christopher Truman on 6/29/17.
//  Copyright © 2017 Christopher Truman. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    let defaults = UserDefaults(suiteName: "group.truman.Playback")
    var recentURLs = [String]()
    var recentTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .UIApplicationWillEnterForeground, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    }
    
    func refresh() {
        if ((defaults?.array(forKey: "URLs") as? [String]) == nil) {
            defaults?.set([], forKey: "URLs")
        }
        guard let URLs = defaults?.array(forKey: "URLs") as? [String] else { return }
        recentURLs = URLs
        
        if ((defaults?.array(forKey: "Titles") as? [String]) == nil) {
            defaults?.set([], forKey: "Titles")
        }
        guard let titles = defaults?.array(forKey: "Titles") as? [String] else { return }
        recentTitles = titles
        
        tableView.reloadData()
    }

    // MARK: - Table View
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! VideoTableViewCell

        let title = recentTitles[indexPath.row]
        let url = recentURLs[indexPath.row]
        cell.configure(title: title, url: url)
        
        return cell
    }
    
    func openSafari(_ url: String) {
        UIApplication.shared.open(URL(string: url)!)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = recentURLs[indexPath.row]
        openSafari(url)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            recentURLs.remove(at: indexPath.row)
            defaults?.set(recentURLs, forKey: "URLs")
            recentTitles.remove(at: indexPath.row)
            defaults?.set(recentTitles, forKey: "Titles")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

