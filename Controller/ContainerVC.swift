//
//  ContainerVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/16/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureHomeController()
    }
    
    
    func configureHomeController(){
        let homeController = HomeVC()
        let controller = UINavigationController(rootViewController: homeController)
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
