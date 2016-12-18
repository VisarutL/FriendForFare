//
//  FriendTabBarController.swift
//  FriendForFare
//
//  Created by Visarut on 12/11/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import Foundation
import XLPagerTabStrip

protocol FriendTabBarDelegate:class {
    func friendTabBarDidClose()
    func friendTabBarDidComplete()
}

class FriendTabBarController:ButtonBarPagerTabStripViewController {
    
    //mark - ui
    let buttonColor = UIColor.systemColor
    let unselectedIconColor = UIColor.unSelectedColor
    var searchBarButton = UIBarButtonItem()
    //mark - property
    
    override func viewDidLoad() {
        buttonBarSetting()
        super.viewDidLoad()
        layoutInitial()
        setRightButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    weak var friendTabBarDelgate: FriendTabBarDelegate?
    
    func setRightButton() {
        setRequestRightButton()
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let itemInfo = [
            IndicatorInfo(title: "FRIEND"),
            IndicatorInfo(title: "FRIEND REQUESTS"),
            ]
        
        let child_0 = FriendListViewController(style: .plain, itemInfo: itemInfo[0])
        let child_1 = FriendRequestListViewController(style: .plain, itemInfo: itemInfo[1])
        
        
        //        child_1.delegate = self
        //        child_2.delegate = self
        //        child_3.delegate = self
        
        
        return [child_0, child_1]
    }
    
}

// MARK: - function
extension FriendTabBarController {
    
    func closeAction() {
        self.friendTabBarDelgate?.friendTabBarDidClose()
    }
    
    func searchAction() {
        
        let searchController = SearchFeedViewController(style: .plain)
        let nvc = UINavigationController(rootViewController: searchController)
        self.present(nvc, animated: true, completion: nil)
        
        
    }
    
    func rejectAction() {
        rejectPopup()
    }
    
    func approveAction() {
        approvePopup()
    }
    
//    func alert() {
//        let message = "this is sample text dummy."
//        let alert = UIAlertController(title: "", message:message, preferredStyle: .alert)
//        let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler: {
//            _ in
//            
//        })
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//        alert.view.tintColor = UIColor.systemColor
//        
//    }
    
    func approvePopup() {
        let message = "this is sample text dummy for approve."
        let alert = UIAlertController(title: "", message:message, preferredStyle: .alert)
        let cancle = UIAlertAction(title: "cancle", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Approve", style: .default, handler: {
            _ in
            
            self.friendTabBarDelgate?.friendTabBarDidComplete()
            
        })
        alert.addAction(cancle)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.systemColor
        
    }
    
    func rejectPopup() {
        let message = "this is sample text dummy for reject submition."
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancle = UIAlertAction(title: "cancle", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "reject", style: .default) {
            _ in
            if let field = alert.textFields {
                //                let rejectRemark = field[0].text
                //                let requestID = "New"
                //                let statusID = "lorem"
                
                self.friendTabBarDelgate?.friendTabBarDidComplete()
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = "reject remark"
            textField.addTarget(self, action: #selector(ListTapBarController.alertControllerTextFieldDidChange(_:)), for: .editingChanged)
            textField.delegate = self
        }
        action.isEnabled = false
        alert.addAction(cancle)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.systemColor
    }
    
    
    
}

extension FriendTabBarController:UITextFieldDelegate {
    func alertControllerTextFieldDidChange(_ sender: AnyObject) {
        let alert:UIAlertController = self.presentedViewController as! UIAlertController
        let textField = alert.textFields?.first
        let action = alert.actions.last
        action?.isEnabled = (textField?.text?.characters.count)! > 0
        
    }
}

// MARK: - UI
extension FriendTabBarController {
    
    func buttonBarSetting() {
        
        settings.style.buttonBarBackgroundColor = UIColor.tabbarColor
        settings.style.buttonBarItemBackgroundColor = UIColor.tabbarColor
        settings.style.selectedBarBackgroundColor = UIColor.black
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Light", size:14) ?? UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .tabbarColor
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = .black
        }
        
    }
    
    func layoutInitial() {
        title = "Friend"
        containerView.isScrollEnabled = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    
    func setRequestRightButton() {
        searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchAction))
        self.navigationItem.rightBarButtonItems = [searchBarButton]
    }

    
}
