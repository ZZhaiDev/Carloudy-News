//
//  DrawerViewController.swift
//  ShortcutsDrawer
//
//  Created by Phill Farrugia on 10/16/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit
import CarloudyiOS
import AVFoundation

/// A View Controller which displays content and is intended to be displayed
/// as a Child View Controller, that can be panned and translated over the top
/// of a Parent View Controller.






class DrawerViewController: UIViewController, UIGestureRecognizerDelegate, UISearchBarDelegate {


    @IBOutlet internal weak var tableView: UITableView!
    internal var panGestureRecognizer: UIPanGestureRecognizer?
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var headerViewTitleLabel: UILabel!
    @IBOutlet weak var animationview: SwiftyWaveView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var expansionState: ExpansionState = .compressed {
        didSet {
            if expansionState != oldValue {
                configure(forExpansionState: expansionState)
            }
        }
    }

    /// Delegate used to send panGesture events to the Parent View Controller
    /// to enable translation of the viewController in it's parent's coordinate system.
    weak var delegate: DrawerViewControllerDelegate?

    /// Determines if the panGestureRecognizer should ignore or handle a gesture. Used
    /// in the case of subview's with gestureRecognizers conflicting with the `panGestureRecognizer`
    /// such as the tableView's scrollView recognizer.
    private var shouldHandleGesture: Bool = true
    /// if its ture, will change topic and stop sending
    private var finishSendingData: Bool = false
    
     var isStartReadTheNews: Bool = false
     var sendingDataIndex: Int = 0
    
    lazy var homeViewModel = HomeViewModel()
    let startSpeech = "tell me what kind of news you want"
    var textReturnedFromSiri = ""
    let searchingSpeech = "OK, searching for "
    let closeSpeech = "I did not hear anything, closing"
    let okcloseSpeech = "ok, closing"
    let sorrySpeech = "sorry, please say `business`, `entertainment`, `health`, `science`, `sports`, `technology`"
    let timeInterVal: Int = 8
    
    var workItem: DispatchWorkItem?
    let queue = DispatchQueue(label: "Network Queue")
    weak var timer_checkTextIfChanging : Timer?
    weak var timer_sendingData: Timer?
    weak var timer_forBaseSiri_inNavigationController: Timer?  ///每0.5秒 检测说的什么
    weak var timer_checkText: Timer?
    
    lazy var synthesizer : AVSpeechSynthesizer = {
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        return synthesizer
    }()
    
//    fileprivate lazy var animImageView : UIImageView = { [unowned self] in
//        let imageView = UIImageView(image: UIImage(named: "guzhang2"))
//        imageView.center = self.view.center
//        imageView.animationImages = [UIImage(named : "guzhang1")!, UIImage(named : "guzhang2")!, UIImage(named : "guzhang3")!]
//        imageView.animationDuration = 0.3
//        imageView.animationRepeatCount = LONG_MAX
//        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
//        return imageView
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        drawerViewSetup()
        setupImageViewAnimation()
        
        GloableSiriFunc.shareInstance.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopGlobleHeyCarloudyNews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animationview.stop()
        }
        GloableSiriFunc.shareInstance.sendWaringLabelToCarloudy(title: "Say business, entertainment, health, science..")
        speak(string: startSpeech, rate: 0.58)
    }
    
    func setupImageViewAnimation(){
        imageView.animationImages = [UIImage(named : "guzhang1")!, UIImage(named : "guzhang2")!, UIImage(named : "guzhang3")!]
        imageView.animationDuration = 0.3
        imageView.animationRepeatCount = LONG_MAX
        imageView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin]
    }
    
    deinit {
        ZJPrint("deinit")
    }

}





extension DrawerViewController{
    private func drawerViewSetup(){
        setupGestureRecognizers()
        configureAppearance()
        configureTableView()
        configure(forExpansionState: expansionState)
    }
    
    private func configureAppearance() {
        view.layer.cornerRadius = 8.0
        view.layer.masksToBounds = true
    }
    
    
    private func configure(forExpansionState expansionState: ExpansionState) {
        switch expansionState {
        case .compressed:
            animateHeaderTitle(toAlpha: 0.0)
            tableView.panGestureRecognizer.isEnabled = false
            break
        case .expanded:
            animateHeaderTitle(toAlpha: 1.0)
            tableView.panGestureRecognizer.isEnabled = false
            break
        case .fullHeight:
            animateHeaderTitle(toAlpha: 1.0)
            if tableView.contentOffset.y > 0.0 {
                panGestureRecognizer?.isEnabled = false
            } else {
                panGestureRecognizer?.isEnabled = true
            }
            tableView.panGestureRecognizer.isEnabled = true
            break
        }
    }
    
    /// Animates the title in the header to visible/invisible in the compression state.
    private func animateHeaderTitle(toAlpha alpha: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.headerViewTitleLabel.alpha = alpha
        }
    }
    
    // MARK: - Gesture Recognizers
    
    private func setupGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(panGestureDidMove(sender:)))
        panGestureRecognizer.cancelsTouchesInView = false
        panGestureRecognizer.delegate = self
        
        view.addGestureRecognizer(panGestureRecognizer)
        self.panGestureRecognizer = panGestureRecognizer
    }
    
    @objc private func panGestureDidMove(sender: UIPanGestureRecognizer) {
        guard shouldHandleGesture else { return }
        let translationPoint = sender.translation(in: view.superview)
        let velocity = sender.velocity(in: view.superview)
        
        switch sender.state {
        case .changed:
            delegate?.drawerViewController(self, didChangeTranslationPoint: translationPoint, withVelocity: velocity)
        case .ended:
            delegate?.drawerViewController(self,
                                           didEndTranslationPoint: translationPoint,
                                           withVelocity: velocity)
        default:
            return
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    /// Called when the `panGestureRecognizer` has to simultaneously handle gesture events with the
    /// tableView's gesture recognizer. Chooses to handle or ignore events based on the state of the drawer
    /// and the tableView's y contentOffset.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        let velocity = panGestureRecognizer.velocity(in: view.superview)
        tableView.panGestureRecognizer.isEnabled = true
        
        if otherGestureRecognizer == tableView.panGestureRecognizer {
            switch expansionState {
            case .compressed:
                return false
            case .expanded:
                return false
            case .fullHeight:
                if velocity.y > 0.0 {
                    // Panned Down
                    if tableView.contentOffset.y > 0.0 {
                        return true
                    }
                    shouldHandleGesture = true
                    tableView.panGestureRecognizer.isEnabled = false
                    return false
                } else {
                    // Panned Up
                    shouldHandleGesture = false
                    return true
                }
            }
        }
        return false
    }
    
    /// Called when the user scrolls the tableView's scroll view. Resets the scrolling
    /// when the user hits the top of the scrollview's contentOffset to support seamlessly
    /// transitioning between the scroll view and the panGestureRecognizer under the user's finger.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let panGestureRecognizer = panGestureRecognizer else { return }
        
        let contentOffset = scrollView.contentOffset.y
        if contentOffset <= 0.0 &&
            expansionState == .fullHeight &&
            panGestureRecognizer.velocity(in: panGestureRecognizer.view?.superview).y != 0.0 {
            shouldHandleGesture = true
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    //    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    //        delegate?.drawerViewController(self, didChangeExpansionState: .fullHeight)
    //    }
    
    // MARK: - Sample Cell Data
    
    internal static let sampleAppIcons: [UIImage] = [
        UIImage(named: "News")!,
        UIImage(named: "News")!,
        UIImage(named: "News")!,
        UIImage(named: "News")!,
        UIImage(named: "News")!,
        UIImage(named: "News")!,
        ]
    
    internal static let sampleAppTitles: [String] = [
        "Business",
        "Entertainment",
        "Health",
        "Science",
        "Sports",
        "Technology"
    ]
    
    internal static let sampleAppDescriptions: [String] = [
        "From newsapi.org",
        "From newsapi.org",
        "From newsapi.org",
        "From newsapi.org",
        "From newsapi.org",
        "From newsapi.org"
    ]
}
