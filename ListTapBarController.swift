//
//  ListTapBarController.swift
//  FriendForFare
//
//  Created by Visarut on 12/4/2559 BE.
//  Copyright © 2559 BE Newfml. All rights reserved.
//

import Foundation
import XLPagerTabStrip

protocol RequestFormDelegate:class {
    func requestFormDidClose()
    func requestFormDidCompleteAction()
}

protocol ListTapBarDelegate: class {
    func didMoveController(index:Int)
}

class ListTapBarController: ButtonBarPagerTabStripViewController {
    
    //mark - ui
    let buttonColor = UIColor.systemColor
    let unselectedIconColor = UIColor.unSelectedColor
//    var alertBarButton = UIBarButtonItem()
    //mark - property
    @IBOutlet weak var joinAlertController: UIBarButtonItem!

    
    weak var requestFormDelegate: RequestFormDelegate?
    
    override func viewDidLoad() {
        buttonBarSetting()
        super.viewDidLoad()
        layoutInitial()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "JoinAlert": break
        default:
            break
        }
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let itemInfo = [
            IndicatorInfo(title: "ALL LIST"),
            IndicatorInfo(title: "MY LIST"),
            IndicatorInfo(title: "HISTORY"),
        ]

        let child_0 = AllListViewController()
        child_0.itemInfo = itemInfo[0]
        child_0.delegate = self
        let child_1 = MyListViewController(style: .plain, itemInfo: itemInfo[1])
        let child_2 = HistoryListViewController(style: .plain, itemInfo: itemInfo[2])
        
        
        //        child_1.delegate = self
        //        child_2.delegate = self
        //        child_3.delegate = self
        
        
        return [child_0, child_1, child_2]
    }
    
}

extension ListTapBarController:ListTapBarDelegate {
    func didMoveController(index: Int) {
        DispatchQueue.main.async {
            self.moveToViewControllerAtIndex(index, animated: true)
        }
        
    }
}

extension ListTapBarController : UIPopoverPresentationControllerDelegate {
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.none
//    }
}

// MARK: - function
extension ListTapBarController {
    
    func closeAction() {
        self.requestFormDelegate?.requestFormDidClose()
    }
    
    
    func joinAlertAction() {
        
        let vc = UITableViewController(style: .grouped)
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize   = CGSize(width: 300.0, height: 300.0)
        
        let popvc = vc.popoverPresentationController
        popvc?.permittedArrowDirections = UIPopoverArrowDirection.up
        popvc?.delegate = self
//        popvc?.sourceView = vc
//        popvc?.sourceRect = CGRectMake(alertBarButton.frame.width / 2, alertBarButton.frame.height,0,0)
        present(vc, animated: true, completion: nil)

        
    }
    
    
    func alert() {
        let message = "this is sample text dummy."
        let alert = UIAlertController(title: "", message:message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: UIAlertActionStyle.cancel, handler: {
            _ in
            
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = UIColor.systemColor
        
    }
    
    
}

extension ListTapBarController:UITextFieldDelegate {
    func alertControllerTextFieldDidChange(_ sender: AnyObject) {
        let alert:UIAlertController = self.presentedViewController as! UIAlertController
        let textField = alert.textFields?.first
        let action = alert.actions.last
        action?.isEnabled = (textField?.text?.characters.count)! > 0
        
    }
}

// MARK: - UI
extension ListTapBarController {
    
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
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .black
            oldCell?.label.font = UIFont.systemFont(ofSize: 14)
            newCell?.label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        
    }
    
    func layoutInitial() {
//        title = "Feed"
        containerView.isScrollEnabled = false
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    
//    func setRequestRightButton() {
//        searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.searchAction))
//        self.navigationItem.rightBarButtonItems = [searchBarButton]
//    }
    

    
}
