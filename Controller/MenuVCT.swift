//
//  MenuVCTableViewController.swift
//  Cessabit
//
//  Created by Marcus Houtzager on 9/16/19.
//  Copyright © 2019 Marcus Houtzager. All rights reserved.
//

import UIKit

enum MenuItems: Int{
    case Home
    case Subscriptions
    case ManageAlerts
    case LogOut
}

class MenuVCT: UITableViewController {

    @IBOutlet weak var HomeIcon: UIImageView!
    @IBOutlet weak var SubscriptionIcon: UIImageView!
    @IBOutlet weak var ManageAlertsIcon: UIImageView!
    @IBOutlet weak var LogOutIcon: UIImageView!
    
    var didTapMenuType: ((MenuItems) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeIcon.image = UIImage.fontAwesomeIcon(name: .home, style: .solid, textColor: #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1882352941, alpha: 1), size: CGSize(width:200, height:200))
        SubscriptionIcon.image = UIImage.fontAwesomeIcon(name: .calendar, style: .solid, textColor: #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1882352941, alpha: 1), size: CGSize(width:200, height:200))
        ManageAlertsIcon.image = UIImage.fontAwesomeIcon(name: .eye, style: .solid, textColor: #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1882352941, alpha: 1), size: CGSize(width:200, height:200))
        LogOutIcon.image = UIImage.fontAwesomeIcon(name: .angleLeft, style: .solid, textColor: #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1882352941, alpha: 1), size: CGSize(width:200, height:200))
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuItem = MenuItems(rawValue: indexPath.row) else { return }
        dismiss(animated: true){[weak self] in
            self?.didTapMenuType?(menuItem)
        }
    }


}
