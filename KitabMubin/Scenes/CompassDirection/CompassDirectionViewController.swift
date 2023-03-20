//
//  CompassDirectionViewController.swift
//  KitabMubin
//
//  Created by Moamen Abd Elgawad on 17/08/2022.
//

import UIKit

class CompassDirectionViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule() -> CompassDirectionViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CompassDirectionViewController") as! CompassDirectionViewController
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var ivCompassBack: UIImageView!
    @IBOutlet weak var ivCompassNeedle: UIImageView!
    
    // MARK: - Properties
    var compassManager: CompassDirectionManager?
    
    // MARK: - Method
    
    override func setupAppearance() {
        super.setupAppearance()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back-Nav")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
    }
    
    @objc
    private func closeDidTap() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - View controller lifecycle methods
extension CompassDirectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        compassManager = CompassDirectionManager(dialerImageView: ivCompassBack, pointerImageView: ivCompassNeedle)
        compassManager?.initManager()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Private Methods
extension CompassDirectionViewController {
}

// MARK: - IBActions
extension CompassDirectionViewController {
    
}
