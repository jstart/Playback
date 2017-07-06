//
//  ActionRequestHandler.swift
//  Playback Action
//
//  Created by Christopher Truman on 6/29/17.
//  Copyright © 2017 Christopher Truman. All rights reserved.
//

import UIKit
import MobileCoreServices

extension Float {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

class ActionRequestHandler: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var speed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem else { return }
        guard let provider = item.attachments?.first as? NSItemProvider else { return }
        guard provider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) else { return }
        provider.loadItem(forTypeIdentifier: kUTTypePropertyList as String, options: nil, completionHandler: {
            (list, error) in
            guard let results = list as? NSDictionary else { return }
            OperationQueue.main.addOperation {
                self.itemLoadCompletedWithPreprocessingResults(results[NSExtensionJavaScriptPreprocessingResultsKey] as! [String: Any]? ?? [:])
            }
        })
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let value = String(format: "%.1f", sender.value)
        speed.text = value
    }
    
    @IBAction func close(_ sender: Any) {
        runRequest(speed: slider.value.roundTo(places: 1))
    }
    
    func runRequest(speed: Float) {
        // Do not call super in an Action extension with no user interface
        let jsDict = [ NSExtensionJavaScriptFinalizeArgumentKey : [ "speed" : speed ]]
        let extensionItem = NSExtensionItem()
        extensionItem.attachments = [ NSItemProvider(item: jsDict as NSSecureCoding, typeIdentifier: kUTTypePropertyList as String)]

        extensionContext!.completeRequest(returningItems: [extensionItem], completionHandler: nil)
    }
    
    func itemLoadCompletedWithPreprocessingResults(_ javaScriptPreprocessingResults: [String: Any]) {
        let value = javaScriptPreprocessingResults["speed"] as! Float
        speed.text = "\(value)"
        slider.value = value
        
        let baseURI = javaScriptPreprocessingResults["baseURI"] as! String
        print(baseURI)
        title = baseURI
        
        let defaults = UserDefaults(suiteName: "group.truman.Playback")
        var URLs = defaults?.array(forKey: "URLs") as? [String] ?? [String]()
        
        if !URLs.contains(baseURI) {
            URLs.append(baseURI)
            defaults?.set(URLs, forKey: "URLs")
        }
    }

}
