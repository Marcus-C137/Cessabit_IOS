//
//  ViewController.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/10/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var Background: UIImageView!
    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var LoginBtn: UIButton!
    
    var player:AVAudioPlayer!
    //hello
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let path = Bundle.main.path(forResource: "Fart-Common-Everyday-Fart_Mike-Koenig", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
        }catch let error as NSError{
            print(error.description)
        }
    }

    @IBAction func LoginBtnClicked(_ sender: Any) {
        Background.isHidden = false
        Logo.isHidden = false
        LoginBtn.isHidden = true
        
        UIView.animate(withDuration: 2.3, animations: {
            self.Logo.frame = CGRect(x:0, y:100,width:200,height:230)
        }) {(finished) in
            self.player.play()
        }
            
        
    }
    

}

