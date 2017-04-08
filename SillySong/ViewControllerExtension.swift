//
//  ViewControllerExtension.swift
//  SillySong
//
//  Created by Patrick Paechnatz on 06.04.17.
//  Copyright © 2017 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {

    //
    // MARK: Prepare/Setup Methods
    //
    
    func prepareControls(
       _ enabled: Bool) {
        
        lblAppTitle.isHidden = !enabled
        nameField.isHidden = !enabled
    }
    
    func prepareTextViewControl(
       _ textView: UITextView) {
        
        lyricParagraphStyle = NSMutableParagraphStyle()
        lyricParagraphStyle.lineBreakMode = .byWordWrapping;
        lyricParagraphStyle.alignment = .center;
        lyricFontNameUsed = getAvailableLyricFontName(lyricFontNames)
        
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 1, height: 1)
        shadow.shadowBlurRadius = 1
        shadow.shadowColor = UIColor(netHex: 0x23A7CE)
        
        lyricTextViewAttributes = [
            // NSStrokeColorAttributeName : UIColor(netHex: 0x23A7CE),
            // NSStrokeWidthAttributeName : -3
            NSShadowAttributeName: shadow,
            NSForegroundColorAttributeName : UIColor.white,
            NSParagraphStyleAttributeName: lyricParagraphStyle,
            NSFontAttributeName : UIFont(name: lyricFontNameUsed, size: lyricFontSize)!,
            
            ] as [String : Any]
        
        lyricsView.delegate = self
        lyricsView.backgroundColor = UIColor.clear
        
        lyricTextViewAttributedText = NSMutableAttributedString(string: lyricsView.text)
        lyricTextViewAttributedText.addAttributes(
            lyricTextViewAttributes,
            range: NSRange(location: 0, length: lyricsView.text!.characters.count)
        )
        
        lyricsView.attributedText = lyricTextViewAttributedText
    }
    
    //
    // MARK: System/Event-Subscriber Methods
    //
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.keyboardWillAppear),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.keyboardWillDisappear),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    func unSubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.UIKeyboardWillShow, object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.UIKeyboardWillHide, object: nil
        )
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        
        view.frame.origin.y = 0
        lblAppTitle.isHidden = false
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            if nameField.isFirstResponder {
                self.view.frame.origin.y =  keyboardSize * -1
            }
            
            lblAppTitle.isHidden = true
        }
    }
    
    //
    // MARK: Lyric Methods
    //
    
    /*
     * small helper method for cleanUp any of my app input views
     */
    func resetInputFields() {
    
        nameField.text = ""
        lyricsView.text = ""
    }
    
    /*
     * takes the name entered in the nameField generates the personalized lyrics, and displays the lyrics in lyricsView.
     */
    func displayLyrics(
       _ lyricsTemplate: String,
       _ fullName: String) -> String {
      
        if let shortName = getShortName(fullName) {
        
            let lyrics: String = lyricsTemplate
                .replacingOccurrences(of: "<SHORT_NAME>", with: shortName)
                .replacingOccurrences(of: "<FULL_NAME>", with: fullName.capitalizingFirstLetter())
            
            return lyrics
        }
        
        return ""
    }
    
    /*
     * check for shortable name, return position of first vowel or false if position is 0 || no occurance found
     */
    func isNameShortable (
       _ name: String,
        
         completionHandlerForNameShortable: @escaping (
       _ success: Bool?,
       _ vowelPosition: Int?)
        
        -> Void) {
        
        if name.isEmpty { completionHandlerForNameShortable(false, 0) }
        
        let _nameLength = name.lengthOfBytes(using: .utf8)
        var _lastPos = _nameLength
        
        for _vowel in vowels {
            // convert vowel to real character
            let vowel = Character(_vowel)
            // determine index position of that char inside name
            if let _index = name.characters.index(of: vowel) {
                // evaluate real position inside that name
                let pos = name.characters.distance(from: name.startIndex, to: _index)
                
                if pos < _lastPos { _lastPos = pos }
                
                if debugMode { print("found a valid vowel (\(vowel)) at position: [\(pos)]") }
            }
        }
        
        if _lastPos != _nameLength {
            // validate true if position of that vowel > 0 (so names starting with a vowel will be ignored)
            completionHandlerForNameShortable(_lastPos > 0, _lastPos)
            
            return
        }
        
        completionHandlerForNameShortable(false, 0)
    }
    
    /*
     * get the shorten version of given name using pre-validator function isNameShortable
     */
    func getShortName(
       _ name: String) -> String? {
        
        if name.isEmpty { return nil }
        
        var _name = name.lowercased()
        
        isNameShortable(_name) {
            
            (success, position) in
        
            if success == true { _name = _name.substring(from: position!) }
        }
        
        return _name
    }
    
    /*
     * get first available font name from perpared array of possible fontNames
     */
    func getAvailableLyricFontName(
       _ fontNamesAvailable: [String]) -> String {
        
        for fontName in fontNamesAvailable {
            if appCommon.isFontNameAvailable(fontName: fontName) {
                return fontName
            }
        }
        
        return lyricFontNameFallback
    }
    
    //
    // MARK: Delegate Methods
    //

    /*
     * reset input fields on any input start
     */
    func textFieldDidBeginEditing(
       _ textField: UITextField) {
        
        resetInputFields()
    }
    
    /*
     * also reset input fields on any reset txtView icon click
     */
    func textFieldShouldClear(
       _ textField: UITextField) -> Bool {
        
        resetInputFields()
        
        return true
    }
    
    /*
     * handle logic on exit name textView input and generate lyrics
     */
    func textFieldShouldReturn(
       _ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        
        if textField.text == nil || textField.text!.isEmpty {
            lyricsView.text = ""
        } else {
            lyricsView.text = displayLyrics(lyricTemplate, textField.text!)
            prepareTextViewControl(lyricsView)
            nameField.resignFirstResponder()
            nameField.text = ""
        }
        
        return false
    }
}
