//
//  ViewController.swift
//  JiraSwiftApiExample
//
//  Created by ORIOL.OMNILOG, MAXIME on 09/10/2020.
//

import Cocoa
import JiraSwiftAPI

class ViewController: NSViewController {
    
    private let requestManager = RequestManager()

    override var representedObject: Any? {
        didSet {
        
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func countTicketsForLastSprint(_ sender: Any) {
        self.requestManager.callAPI()
    }
}
