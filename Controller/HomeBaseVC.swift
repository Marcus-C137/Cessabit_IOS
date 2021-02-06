//
//  HomeBaseVC.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/17/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit
import FontAwesome_swift

class HomeBaseVC: UIViewController {
    let transition = SlideInTransition()

    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var topView: UIView?
    @IBOutlet weak var BarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = "Your Devices"
        topView?.removeFromSuperview()
        let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
        view.addSubview(HomeVC!.view)
        self.topView = HomeVC!.view
        addChild(HomeVC!)
        configBarButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.title = "Your Devices"
        topView?.removeFromSuperview()
        let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
        view.addSubview(HomeVC!.view)
        self.topView = HomeVC!.view
        addChild(HomeVC!)
    }
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        guard let MenuVC = storyboard?.instantiateViewController(withIdentifier: "MenuVCT") as? MenuVCT else{return}
        MenuVC.didTapMenuType = { menuItems in
            self.transitionToNew(menuItems)
        }
        MenuVC.modalPresentationStyle = .overCurrentContext
        MenuVC.transitioningDelegate = self
        present(MenuVC, animated: true)
    }
    
    func transitionToNew(_ menuItem: MenuItems){
        topView?.removeFromSuperview()
        //IAPService.instance.isSubscriptionActive { (active) in
            //if active{
                switch menuItem{
                case .Home:
                    self.navigationBar.title = "Your Devices"
                    let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
                    self.view.addSubview(HomeVC!.view)
                    self.topView = HomeVC!.view
                    self.addChild(HomeVC!)
                case .Subscriptions:
                    self.navigationBar.title = "Subscriptions"
                    let subscriptionVC = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionsVC")
                    self.view.addSubview(subscriptionVC!.view)
                    self.topView = subscriptionVC!.view
                    self.addChild(subscriptionVC!)
                case .ManageAlerts:
                    self.navigationBar.title = "Manage Alerts"
                    let ManageAlertsVC = self.storyboard?.instantiateViewController(withIdentifier: "ManageAlertsVC")
                    self.view.addSubview(ManageAlertsVC!.view)
                    self.topView = ManageAlertsVC!.view
                    self.addChild(ManageAlertsVC!)
                case .LogOut:
                    AuthService.instance.logoutUser()
                    let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                    self.present(LoginVC!, animated: true, completion: nil)
                default:
                    break
                    
              }
            //}else{
//                switch menuItem{
//                case .Home:
//                    self.navigationBar.title = "Your Devices"
//                    let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
//                    self.view.addSubview(HomeVC!.view)
//                    self.topView = HomeVC!.view
//                    self.addChild(HomeVC!)
//                case .LogOut:
//                    AuthService.instance.logoutUser()
//                    let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
//                    self.present(LoginVC!, animated: true)
//                default:
//                    let UnsubscribedVC = self.storyboard?.instantiateViewController(withIdentifier: "UnsubscribedVC")
//                    self.present(UnsubscribedVC!, animated: true)
//                }
            //}
        //}
    }

    func configBarButton(){
        let attributes = [NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: 20, style: .solid)]
        BarButton.setTitleTextAttributes(attributes, for: .normal)
        BarButton.title = String.fontAwesomeIcon(name: .bars)
    }
}

extension HomeBaseVC: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) ->UIViewControllerAnimatedTransitioning?{
        transition.isPresenting = false
        return transition
    }
}
