//
//  ViewController.swift
//  TresserAct
//
//  Created by neelam on 15/04/16.
//  Copyright © 2016 magic software. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {

     @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textImage: UIImageView?
    let imageName = "Lenore.png"
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var rate: Float!
    
    var pitch: Float!
    
    var volume: Float!
    
    var totalUtterances: Int! = 0
    
    var currentUtterance: Int! = 0
    
    var totalTextLength: Int = 0
    
    var spokenTextLengths: Int = 0
    
    
//    let image = UIImage(named: imageName)
//    let imageView = UIImageView(image: image!)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        speechSynthesizer.delegate = self
        textView.editable = false;
         textView.text = "abc"
        
        if !loadSettings() {
            registerDefaultSettings()
        }
        
        let image = UIImage(named: imageName)
        textImage?.image = image
        performImageRecognition(image!);
        voiceSynthesizer(textView.text);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
   
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance)
    {
        spokenTextLengths = spokenTextLengths + utterance.speechString.utf16.count + 1
        print("spokenTextLengths \(spokenTextLengths)")
//        let progress: Float = Float(spokenTextLengths * 100 / totalTextLength)
//        pvSpeechProgress.progress = progress / 100
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didStartSpeechUtterance utterance: AVSpeechUtterance){
        currentUtterance = currentUtterance + 1
        print("currentUtterance \(currentUtterance)")
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance){
        let progress: Float = Float(spokenTextLengths + characterRange.location) * 100 // Float(totalTextLength)
        print("progress \(progress)")
    }
    
  func voiceSynthesizer(sentence: String) {
    
    let speechUtterance = AVSpeechUtterance(string: sentence)
    
    speechUtterance.rate = rate
    speechUtterance.pitchMultiplier = pitch //0.5 to 2.0 default = 1.0
    speechUtterance.volume = volume //0.0 to 1.0 default 1.0
    
    speechSynthesizer.speakUtterance(speechUtterance)
    }
    
    func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate //AVSpeechUtteranceMinimumSpeechRate (0.0),AVSpeechUtteranceDefaultSpeechRate,AVSpeechUtteranceMaximumSpeechRate (1.0)
        pitch = 0.1
        volume = 0.2
        
        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setFloat(rate, forKey: "rate");
//        defaults.setFloat(pitch, forKey: "pitch")
//        defaults.setFloat(volume, forKey: "volume")
       
        
        let defaultSpeechSettings = ["rate": rate, "pitch": pitch, "volume": volume]
        defaults.setObject(defaultSpeechSettings, forKey: "dicValue");
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultSpeechSettings)
    }
    
    func loadSettings() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults() as NSUserDefaults
        
        if let theRate: Float = userDefaults.valueForKey("rate") as? Float {
            rate = theRate
            pitch = userDefaults.valueForKey("pitch") as! Float
            volume = userDefaults.valueForKey("volume") as! Float
            
            return true
        }
        
        return false
    }
    
    @IBAction func pauseSpeech(sender: AnyObject) {
        speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        
    }
    
    @IBAction func stopSpeech(sender: AnyObject) {
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    @IBAction func resumeSpeech(sender: AnyObject) {
       // speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        
        if !speechSynthesizer.speaking {
            let textParagraphs = textView.text.componentsSeparatedByString("\n")
            
            // Add these lines.
            totalUtterances = textParagraphs.count
            currentUtterance = 0
            totalTextLength = 0
            spokenTextLengths = 0
            
             for pieceOfText in textParagraphs {
                let speechUtterance = AVSpeechUtterance(string: pieceOfText)
                speechUtterance.rate = rate
                speechUtterance.pitchMultiplier = pitch
                speechUtterance.volume = volume
                speechUtterance.postUtteranceDelay = 1.505
                
                totalTextLength = totalTextLength + pieceOfText.characters.count
                
                speechSynthesizer.speakUtterance(speechUtterance)
            }
        }
        else{
            speechSynthesizer.continueSpeaking()
        }
    }

    func performImageRecognition(image: UIImage) {
        // 1
        let tesseract = G8Tesseract()
        // 2
        tesseract.language = "eng+fra"
        // 3
        tesseract.engineMode = .TesseractCubeCombined
        // 4
        tesseract.pageSegmentationMode = .Auto
        // 5
        tesseract.maximumRecognitionTime = 60.0
        // 6
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        // 7
        textView.text = tesseract.recognizedText
        print("text \(textView.text)");
        textView.editable = true
        
        
        // 8
    }

}

