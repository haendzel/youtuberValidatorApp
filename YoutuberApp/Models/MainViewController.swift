//
//  ViewController.swift
//  YoutuberApp
//
//  Created by Filip Handzel on 16/08/2020.
//  Copyright © 2020 Filip Handzel. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class MainViewController: UIViewController {

    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var webPlayerView: WKYTPlayerView!
    @IBOutlet weak var alignTopHeader: NSLayoutConstraint!
    
    var videoId: String = "1sJlFzUQVmY"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        webPlayerView.load(withVideoId: videoId)
        //webPlayerView.playVideo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        webPlayerView.isHidden = true;
        alignTopHeader.constant -= view.bounds.width
        playVideoButton.layer.cornerRadius = 8.0;
        playVideoButton.layer.masksToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        alignTopHeader.constant = 50
        UIView.animate(withDuration: 0.8, delay: 0.5, options: .curveEaseOut, animations: { [weak self] in
        self?.view.layoutIfNeeded() }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.webPlayerView.isHidden = false
        }
        
        
    }
    
    //MARK: Functions
    
    
    func getErrorAlert() {
        let alert = UIAlertController(title: "Ooops!", message: "Wrong id or url to play video from Youtube.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: IBActions

    @IBAction func playVideoClicked(_ sender: Any) {
        self.view.endEditing(true)
        let inputText:String = textField.text!
        if inputText.count == 11 && inputText.count > 0 {
            
            print("Input text: ", inputText)
            videoId = inputText
            webPlayerView.load(withVideoId: videoId)
            
        } else if inputText.count > 11 {
            
            if let videoIdFromUrl = getYoutubeId(youtubeUrl: inputText) {
                print("Video id from url: ", videoIdFromUrl)
                webPlayerView.load(withVideoId: videoIdFromUrl)
            } else {
                getErrorAlert()
            }
        } else {
            getErrorAlert()
        }
    }
    
}

