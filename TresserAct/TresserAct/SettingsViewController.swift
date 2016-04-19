//
//  SettingsViewController.swift
//  TresserAct
//
//  Created by neelam on 18/04/16.
//  Copyright © 2016 magic software. All rights reserved.
//

import UIKit
import AVFoundation

protocol SettingsViewControllerDelegate {
    func didSaveSettings()
}


class SettingsViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

     @IBOutlet weak var tbSettings: UITableView!
    
    var delegate: SettingsViewControllerDelegate!
    let speechSettings = NSUserDefaults.standardUserDefaults()
    
    var rate: Float!
    
    var pitch: Float!
    
    var volume: Float!
    
    var arrVoiceLanguages: [Dictionary<String, String!>] = []
    
    var selectedVoiceLanguage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        tbSettings.delegate = self
//        tbSettings.dataSource = self
        
        // Make the table view with rounded contents.
       // tbSettings.layer.cornerRadius = 15.0
        
        
        rate = speechSettings.valueForKey("rate") as! Float
        pitch = speechSettings.valueForKey("pitch") as! Float
        volume = speechSettings.valueForKey("volume") as! Float
        
        
        prepareVoiceList()

    }
    
    func prepareVoiceList() {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            let voiceLanguageCode = (voice as AVSpeechSynthesisVoice).language
            
            let languageName = NSLocale.currentLocale().displayNameForKey(NSLocaleIdentifier, value: voiceLanguageCode)
            
            let languageDictionary = ["languageName": languageName, "languageCode": voiceLanguageCode]
            print("languageDictionary \(languageDictionary)")
            // arrVoiceLanguages.append(dictionary) as! String
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCellWithIdentifier("idCellVoicePicker", forIndexPath: indexPath) as UITableViewCell
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
