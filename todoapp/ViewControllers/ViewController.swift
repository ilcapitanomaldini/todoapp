//
//  ViewController.swift
//  todoapp
//
//  Created by VM on 10/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Tab: Int {
        case today = 0
        case later = 1
        
        static var count: Int = {
            return 2
        }()
        
        func updateTab(slider: UIView, left constraint: NSLayoutConstraint, with tab: UITabBar) {
            let leftConstant: CGFloat = CGFloat(self.rawValue) * (tab.frame.width / CGFloat(Tab.count))
            UIView.animate(withDuration: 0.5, animations: {
                constraint.constant = leftConstant
            })
            slider.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tabBarSlider: UIView!
    @IBOutlet weak var sliderWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sliderLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var vcHolder: UIView!
    
    var activeTab: Tab = .today {
        willSet {
            newValue.updateTab(slider: tabBarSlider, left: sliderLeftConstraint, with: tabBar)
            switch newValue {
            case .today:
                attach(viewController: todayViewController, removeVC: laterViewController)
            default:
                attach(viewController: laterViewController, removeVC: todayViewController)
            }
        }
    }
    
    lazy var todayViewController: TodayViewController = {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: TodayViewController.reuseIdentifier) as? TodayViewController, let items = self.viewModel?.getTodaysItems() else {
            return TodayViewController()
        }
        viewController.toDoItems = items
        return viewController
    }()
    
    lazy var laterViewController: LaterViewController = {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: LaterViewController.reuseIdentifier) as? LaterViewController, let items = self.viewModel?.getLaterItems() else {
            return LaterViewController()
        }
        viewController.toDoItems = items
        return viewController
    }()
    
    var viewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewModel(delegate: self)
        setupRefresh()
        tabBar.delegate = self
        sliderWidthConstraint.constant = tabBar.frame.width / CGFloat(Tab.count)
        tabBar.selectedItem = tabBar.items?[0]
        if let selectedItem = tabBar.selectedItem {
            self.tabBar(tabBar, didSelect: selectedItem)
        }
    }
    
    func setupRefresh() {
        refreshButton.layer.cornerRadius = refreshButton.frame.size.height / CGFloat(2)
        //FIXME: Magic number and styles and fonts should be placed elsewhere.
        refreshButton.backgroundColor = .white
        refreshButton.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
    }
    
    @objc func refreshTapped() {
        refreshButton.isUserInteractionEnabled = false
        viewModel?.refreshData()
    }
    
    func attach(viewController: UIViewController, removeVC: UIViewController) {
        if !self.children.contains(viewController) {
            addChild(viewController)
            vcHolder.addSubview(viewController.view)
            removeVC.willMove(toParent: nil)
            removeVC.view.removeFromSuperview()
            removeVC.removeFromParent()
        }
    }
}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let activeIndex = tabBar.items?.firstIndex(of: item), let activeTab = Tab(rawValue: activeIndex) else {
            return
        }
        self.activeTab = activeTab
    }
}

extension ViewController: MainVMDelegate {
    func dataUpdated() {
        refreshButton.isUserInteractionEnabled = true
        switch self.activeTab {
        case .today:
            DispatchQueue.main.async {
                self.todayViewController.refreshViews(with: self.viewModel?.getTodaysItems())
            }
        case .later:
            DispatchQueue.main.async {
                self.laterViewController.refreshViews(with: self.viewModel?.getLaterItems())
            }
        }
    }
}
