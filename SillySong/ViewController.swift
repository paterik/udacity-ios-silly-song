//
//  ViewController.swift
//  SillySong
//
//  Created by Patrick Paechnatz on 06.04.17.
//  Copyright © 2017 Patrick Paechnatz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    //
    // MARK: IBOutlet variables
    //
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var lyricsView: UITextView!
    @IBOutlet weak var lblAppTitle: UILabel!
    
    //
    // MARK: Constants (Special)
    //
    
    let appCommon = AppCommon.sharedInstance
    
    //
    // MARK: Constants (Normal)
    //
    
    let lyricFontNames = ["HelveticaNeue-CondensedBlack", "Impact", "Futura-CondensedExtraBold"]
    let lyricFontNameFallback = "Arial"
    let lyricFontSize: CGFloat = 28.0
    let lyricTemplate = [
        "<FULL_NAME>, <FULL_NAME>, Bo B<SHORT_NAME>",
        "Banana Fana Fo F<SHORT_NAME>",
        "Me My Mo M<SHORT_NAME>",
        "<FULL_NAME>"].joined(separator: "\n")
    
    //
    // MARK: Variables
    //
    
    var lyricTextViewAttributes: [String : Any]!
    var lyricParagraphStyle: NSMutableParagraphStyle!
    var lyricTextViewAttributedText: NSMutableAttributedString!
    var lyricFontNameUsed: String!
    
    //
    // MARK: UIView Methods (overrides)
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
     
        prepareControls( true )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        
        unSubscribeToKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        nameField.delegate = self
    }
}

