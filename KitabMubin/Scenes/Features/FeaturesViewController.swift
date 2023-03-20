//
//  FeaturesViewController.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 05/08/2022.
//

import UIKit

class FeaturesViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule() -> FeaturesViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FeaturesViewController") as! FeaturesViewController
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    var viewModel: FeaturesViewModelProtocol?
    
    // MARK: - Methods
    override func assignDelegates() {
        super.assignDelegates()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func registerCells() {
        super.registerCells()
        collectionView.registerCellNib(cellClass: FeatureCollectionViewCell.self)
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        navigationItem.title = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(closeDidTap))
        containerView.backgroundColor = .white
        collectionView.backgroundColor = .white
    }
}

// MARK: - View controller lifecycle methods
extension FeaturesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoadingIndicator()
        viewModel = FeaturesViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationTo()
        hideLoadingIndicator()
    }
    
    @objc
    private func closeDidTap() {
        dismiss(animated: true)
    }
}

// MARK: - Private Methods
extension FeaturesViewController {
    private func setChildViewController(viewController: UIViewController?) {
        removeChildViewController()
        guard let controller = viewController else { return }
        addChild(controller)
        controller.view.frame = containerView.frame
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    private func removeChildViewController() {
        self.children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
    }
    
    private func navigationTo() {
        guard let model = viewModel?.selectedFeatureItem else { return }
        switch model.featureId {
        case "Feature_One":
            let vc = AlfahrisViewController.initModule()
            setChildViewController(viewController: vc)
            containerView.layoutIfNeeded()
        case "Feature_Two":
            let vc = AlajizaViewController.initModule()
            setChildViewController(viewController: vc)
        case "Feature_Three":
            let vc = FawasilViewController.initModule()
            setChildViewController(viewController: vc)
        case "Feature_Four":
            let vc = SettingViewController.initModule()
            setChildViewController(viewController: vc)
        default:
            break
        }
    }
}

extension FeaturesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSection ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as FeatureCollectionViewCell
        cell.dataSource = viewModel?.dataSourceForIndex(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel?.calculateCellSize(collectionView: collectionView) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel?.minimumLineSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel?.minimumInteritemSpacing ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.didSelectItem(at: indexPath)
        collectionView.reloadData()
        navigationTo()
    }
}
