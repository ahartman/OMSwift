//
//  Pager.swift
//  OptieMonitor
//
//  Created by André Hartman on 12/11/16.
//
import UIKit
class Pager: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pages = [UIViewController]()
    var pagesTitles = ["Intraday","Intraday grafiek","Interday","Interday grafiek"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = mainColor
        self.delegate = self
        self.dataSource = self

        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Intraday")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "IntraGraph")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "Interday")
        let page4: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "InterGraph")
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
 
        setViewControllers([page1], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        self.title = String(pagesTitles[0])
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let previousIndex = (currentIndex == 0) ? pages.count - 1 : currentIndex - 1
        self.title = String(pagesTitles[currentIndex])
        return pages[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = (currentIndex == pages.count - 1) ? 0: currentIndex + 1
        self.title = String(pagesTitles[currentIndex])
        return pages[nextIndex]
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
