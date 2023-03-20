//
//  SplashViewController.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 24/07/2022.
//

import UIKit

/// Splash ViewController state type enum
enum SplashViewState {
    case Start
    case Downloading
    case Completed
}

class SplashViewController: UIViewController {
    
    // MARK: - init Module
    static func initModule(currentState: SplashViewState = .Start) -> SplashViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SplashViewController") as! SplashViewController
        vc.currentState = currentState
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var startDownloadView: UIView!
    @IBOutlet weak var startDownloadButton: UIButton!
    @IBOutlet weak var downloadingView: UIView!
    @IBOutlet weak var downloadingProgressView: UIProgressView!
    @IBOutlet weak var downloadingProgressLabel: UILabel!
    @IBOutlet weak var completedDownloadView: UIView!
    @IBOutlet weak var completedProgressView: UIProgressView!
    @IBOutlet weak var completedProgressLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    // MARK: - Properties
    private var timer: Timer?
    var currentState: SplashViewState = .Start
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerHandler), userInfo: nil, repeats: false)
    }
    
    @objc private func timerHandler() {
        configureView(currentState: .Completed)
    }
}

// MARK: - View controller lifecycle methods
extension SplashViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView(currentState: currentState)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - Private Methods
extension SplashViewController {
    private func configureView(currentState: SplashViewState) {
        self.currentState = currentState
        switch currentState {
        case .Start:
            setupStartDownloadViewAppearance()
        case .Downloading:
            setupDownloadingProgressViewAppearance()
        case .Completed:
            setupCompletedProgressViewAppearance()
        }
    }
    
    private func setupStartDownloadViewAppearance() {
        startDownloadView.isHidden = false
        downloadingView.isHidden = true
        completedDownloadView.isHidden = true
        startDownloadButton.cornerRadiusView(radius: 8)
    }
    
    private func setupDownloadingProgressViewAppearance() {
        downloadingView.isHidden = false
        startDownloadView.isHidden = true
        completedDownloadView.isHidden = true
        downloadingProgressView.addCornerRadius(6)
    }
    
    private func setupCompletedProgressViewAppearance() {
        completedDownloadView.isHidden = false
        downloadingView.isHidden = false
        startDownloadView.isHidden = true
        completedButton.cornerRadiusView(radius: 8)
        completedProgressView.addCornerRadius(6)
    }
}

// MARK: - IBActions
extension SplashViewController {
    @IBAction func startDownloadButtonDidTap(_ sender: Any) {
        configureView(currentState: .Downloading)
        startTimer()
    }
    
    @IBAction func completedButtonDidTap(_ sender: Any) {
        let vc = QuranViewController.initModule(page: 1)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .flipHorizontal
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
