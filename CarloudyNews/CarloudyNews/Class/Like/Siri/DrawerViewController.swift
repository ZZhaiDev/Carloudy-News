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

private let topics = ["business",
                      "entertainment",
                      "health",
                      "science",
                      "sports",
                      "technology"]




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
    
    lazy var homeViewModel = HomeViewModel()
    let startSpeech = "tell me what kind of news you want"
    var textReturnedFromSiri = ""
    let searchingSpeech = "OK, searching for "
    let closeSpeech = "I did not hear anything, closing"
    let okcloseSpeech = "ok, closing"
    let sorrySpeech = "sorry, please say `business`, `entertainment`, `health`, `science`, `sports`, `technology`"
    
    var workItem: DispatchWorkItem?
    let queue = DispatchQueue(label: "Network Queue")
    weak var timer_checkTextIfChanging : Timer?
    weak var timer_sendingData: Timer?
    weak var timer_forBaseSiri_inNavigationController: Timer?  ///每0.5秒 检测说的什么
    
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


// MARK:- Siri
extension DrawerViewController{
    func startSiriSpeech(){
        animationview.start()
        carloudySpeech.microphoneTapped()
        self.createTimerForBaseSiri_checkText()
        self.delay3Seconds_createTimer()
//        siriButton.setTitle("listening", for: .normal)
//        siriButton.setTitleColor(UIColor.red, for: .normal)
//        siriButton.isEnabled = false
    }
    
    func endSiriSpeech(){
        animationview.stop()
        carloudySpeech.endMicroPhone()
        timer_checkTextIfChanging?.invalidate()
        timer_forBaseSiri_inNavigationController?.invalidate()
        timer_checkTextIfChanging = nil
        timer_forBaseSiri_inNavigationController = nil
    }
    
    func endSendingData(){
        self.timer_sendingData?.invalidate()
        self.timer_sendingData = nil
    }
    
    func dismissContoller(delay: Int = 0){
        if synthesizer.isSpeaking{
           synthesizer.stopSpeaking(at: .immediate)
        }
        
        synthesizer.delegate = nil
        endSendingData()
        endSiriSpeech()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            if let parentVC = self.parent as? PrimaryViewController{
                parentVC.dismiss(animated: true, completion: {
                    ZJPrint(UIApplication.topViewController())
                    if let vc = UIApplication.topViewController() as? LikeViewController{
                        ZJPrint(vc)
                        startGlobleHeyCarloudyNews(vc: vc)
                    }
                })
            }
        }
        
    }
    
    
    fileprivate func delay3Seconds_createTimer(){
        let delayTime = DispatchTime.now() + Double(Int64(5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            if carloudySpeech.audioEngine.isRunning == true{
                self.createTimerForBaseSiri_checkiftextChanging()
            }
        }
    }
    
    fileprivate func createTimerForBaseSiri_checkiftextChanging(){
        if timer_checkTextIfChanging == nil{
            timer_checkTextIfChanging?.invalidate()
            timer_checkTextIfChanging = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(checkTextIsChanging), userInfo: nil, repeats: true)
        }
    }
    
    fileprivate func createTimerForBaseSiri_checkText(){
        if timer_forBaseSiri_inNavigationController == nil{
            timer_forBaseSiri_inNavigationController?.invalidate()
            timer_forBaseSiri_inNavigationController = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self](_) in
                self?.textReturnedFromSiri = (carloudySpeech.checkText().lowercased())
                //let result = self?.textReturnedFromSiri
                if self?.textReturnedFromSiri != ""{
                    self?.createTimerForBaseSiri_checkiftextChanging()
                }
            })
            
        }
        
    }
    
    @objc func checkTextIsChanging(){
        guard carloudySpeech.checkTextChanging() == false else {return}
        ZJPrint(self.textReturnedFromSiri)
        if self.textReturnedFromSiri != ""{
            endSiriSpeech()
            
            if self.textReturnedFromSiri.lowercased().contains("close") || self.textReturnedFromSiri.lowercased().contains("stop"){
                ZJPrint("2222222222------------------------------------------------------------------------------------")
                speak(string: okcloseSpeech)
                return
            }
            
            UIView.animate(withDuration: 0.5) {
//                self.imageViewWidthConstraint.constant = 120
//                self.imageViewHeightConstraint.constant = 120
                self.imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            
            imageView.startAnimating()
            
            speak(string: searchingSpeech + "`\(self.textReturnedFromSiri)`")
            loadData(topic: self.textReturnedFromSiri)
        
        }else{      //长时间没说话
            if (UIApplication.topViewController() as? LikeViewController) != nil{
                
                return
            }
            //MARK: -- 这里有问题，dismiss 后重开 会说closespeech
            speak(string: closeSpeech)
            endSiriSpeech()
            
        }
    }
    
    fileprivate func loadData(topic: String){
        if topics.contains(topic.lowercased()){
            let timeInterVal: Int = 8
           let str = "https://newsapi.org/v2/top-headlines?country=us&category=\(topic)&apiKey=b7f7add8d89849be8c82306180dac738"
            homeViewModel.loadNews(str: str) {
                DispatchQueue.main.async {
                    self.speak(string: "`got it`, sending data to carloudy... you can say: `change topic`, or `close` any time.", rate: 0.55)
                    let articles: [Article] = self.homeViewModel.articles
//                    for (index, article) in articles.enumerated(){
//                        if let title = article.title{
//                            ZJPrint(title)
//                            self.queue.asyncAfter(deadline: .now() + .seconds(index * timeInterVal), execute: {
//                                DispatchQueue.main.async {
//                                    sendMessageToCarloudy(title: title)
//                                }
//
//                            })
//                        }
//                    }
                    
                    if self.timer_sendingData == nil{
                        self.timer_sendingData?.invalidate()
                        let maxIndex = articles.count
                        let article = articles[0]
                        if let title = article.title{
                            sendMessageToCarloudy(title: title)
                        }
                        var index = 1
                        self.timer_sendingData = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterVal), repeats: true, block: { (_) in
                            let article = articles[index]
                            if let title = article.title{
                                sendMessageToCarloudy(title: title)
                            }
                            index += 1
                            if index >= maxIndex{
                                self.dismissContoller()
                            }
                        })
                    }
                    
                }
            }
        }else{
            speak(string: sorrySpeech, rate: 0.55)
        }
    }
}


extension DrawerViewController: AVSpeechSynthesizerDelegate{
    func speak(string: String, rate: CGFloat = 0.58){
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = Float(rate)
        synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        if utterance.speechString == startSpeech{
            
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if (UIApplication.topViewController() as? LikeViewController) != nil{
            return
        }
        ZJPrint(utterance.speechString)
        if utterance.speechString == okcloseSpeech{
            self.dismissContoller()
        }else if utterance.speechString == startSpeech{
            startSiriSpeech()
//            animationview.stop()
            
        }else if utterance.speechString.hasPrefix(searchingSpeech){
        }else if utterance.speechString == closeSpeech{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                //                self.endSiriSpeech()
                self.dismissContoller()
            }
        }else if utterance.speechString == sorrySpeech{
            speak(string: startSpeech)
        }else if utterance.speechString.hasPrefix("`got it`, sending data to carloudy"){
            animationview.start()
            carloudySpeech.microphoneTapped()
            timer_forBaseSiri_inNavigationController?.invalidate()
            timer_forBaseSiri_inNavigationController = nil
            timer_forBaseSiri_inNavigationController = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self](_) in
                self?.textReturnedFromSiri = (carloudySpeech.checkText().lowercased())
                //let result = self?.textReturnedFromSiri
                guard self?.textReturnedFromSiri.lowercased() != nil else {return}
                ZJPrint(carloudySpeech.audioEngine.isRunning)
                // MARK:- 如果这里超过一分钟 audioEngine.isRunning 不工作怎么办？
                if (self?.textReturnedFromSiri.lowercased().contains("change topic"))! || (self?.textReturnedFromSiri.lowercased().contains("change the topic"))!{
                    
                    self?.endSendingData()
                    self?.endSiriSpeech()
                    self?.speak(string: (self?.startSpeech)!)
                }else if (self?.textReturnedFromSiri.lowercased().contains("stop"))! || (self?.textReturnedFromSiri.lowercased().contains("close"))!{
                    self?.speak(string: (self?.okcloseSpeech)!, rate: 0.53)
                    self?.timer_forBaseSiri_inNavigationController?.invalidate()
                    ZJPrint("1111111-------------------------------------------------------------------------------")
                    
                }
            })
            
        }
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