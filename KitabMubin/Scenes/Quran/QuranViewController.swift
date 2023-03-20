//
//  QuranViewController.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 03/08/2022.
//

import UIKit

class QuranViewController: BaseViewController {
    
    // MARK: - init Module
    static func initModule(page: Int) -> QuranViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "QuranViewController") as! QuranViewController
        vc.page = page
        
        return vc
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var jozzLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var suraNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var savePageButton: UIButton!
   
    
    @IBAction func nextPage(_ sender: Any) {
        if page < viewModel?.getQuran().count ?? 0 {
            nextPage()
        }
    }
    
    @IBAction func perviousPage(_ sender: Any) {
        if page > 1 {
            previousPage()
        }
    }
    
    
    
    var lines: [String]?
    
    // MARK: - Properties
    private var page: Int = 1
    private var viewModel: MoshfViewModel? {
        didSet {
            collectionView.reloadData()
            collectionView.scrollToItem(at: IndexPath(row: page - 1, section: 0), at: .right, animated: false)
        }
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        pageLabel.addCornerRadius(12)
        suraNameLabel.font = UIFont(name: "KFGQPCHAFSUthmanicScript-Regula", size: 24)
    }
    
    
}

// MARK: - View controller lifecycle methods
extension QuranViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .init("UpdateSavedStatus"), object: nil, queue: .main) { notify in
            guard let isSelected = notify.object as? Bool else { return }
            self.savePageButton.isSelected = isSelected
        }
        setUpCollectionView()
        savePageButton.layer.cornerRadius = 15
        showLoadingIndicator()
        loadQuran()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Private Methods
extension QuranViewController {
    private func loadQuran() {
        JsonLoader.shared.loadJsonDataFromFile("Quran_hafs") { data in
            if let jsonData = data {
                do {
                    let decodedData = try JSONDecoder().decode([QuranModel].self, from: jsonData)
                    DispatchQueue.main.async { [weak self] in
                        self?.viewModel = MoshfViewModel(dataSource: decodedData, page: self?.page ?? 0)
                        self?.hideLoadingIndicator()
                    }
                }
                catch {
                    hideLoadingIndicator()
                    showMessage(message: error.localizedDescription)
                }
            }
        }
    }
    
}

extension QuranViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    private func setUpCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: "QuranCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "QuranCollectionViewCell")
        addCompositionalLayout()
    }
    
    private func addCompositionalLayout(){
        let layout = UICollectionViewCompositionalLayout {sectionIndex,enviroment in
            return self.mainSection()
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func mainSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(UIScreen.main.bounds.height * 0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        //         PLay with some animation and scrollOffest
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        return section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.getQuran().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuranCollectionViewCell", for: indexPath) as! QuranCollectionViewCell
        
        let pages = viewModel!.getQuran()
        let sure = pages[indexPath.row].sure
        cell.setDate(sure: sure)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let pages = viewModel!.getQuran()
        let page = pages[indexPath.row]
        pageLabel.text = "الصفحة \(page.number)"
        self.page = page.number
        jozzLabel.text = "الجزء \(page.jozz)"
        suraNameLabel.text = "سورة \(page.sure.first?.name ?? "")"

        savePageButton.isSelected = RealmManager.sharedInstance.fetchObjects(SavedPage.self)?.contains(where: {$0.pageNumber == page.number}) ?? false

        UserDefaults.standard.set(page.sure.first?.name ?? "", forKey: "current_sura_name")
        UserDefaults.standard.set(page.number, forKey: "current_page_number")
        NotificationCenter.default.post(name: .init("ReloadQuranPage"), object: nil)
    }
    
}


// MARK: - Selectors
extension QuranViewController {

    private func nextPage() {
        page += 1
        collectionView.scrollToItem(at: IndexPath(row: page - 1, section: 0), at: .left, animated: true)
    }
    
    private func previousPage() {
        page -= 1
        collectionView.scrollToItem(at: IndexPath(row: page - 1, section: 0), at: .right, animated: true)
    }
    
    func getLinesArrayOfString(in textView: UITextView) -> [String] {
        
        /// An empty string's array
        var linesArray = [String]()
        
        guard let text = textView.text, let font = textView.font else {return linesArray}
        
        let rect = textView.frame
        
        let myFont = CTFontCreateWithFontDescriptor(font.fontDescriptor, 0, nil)
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttribute(kCTFontAttributeName as NSAttributedString.Key, value: myFont, range: NSRange(location: 0, length: attStr.length))
        
        let frameSetter: CTFramesetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path: CGMutablePath = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: 100000), transform: .identity)
        
        let frame: CTFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        guard let lines = CTFrameGetLines(frame) as? [Any] else {return linesArray}
        
        for line in lines {
            let lineRef = line as! CTLine
            let lineRange: CFRange = CTLineGetStringRange(lineRef)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString: String = (text as NSString).substring(with: range)
            linesArray.append(lineString)
        }
        return linesArray
    }
    
}

// MARK: - IBActions
extension QuranViewController {
    @IBAction func backDidTap(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookMarkDidTap(_ sender: Any) {
        savePageButton.isSelected = !savePageButton.isSelected

        savePageButton.isSelected ? viewModel?.savePage(index:page - 1) : viewModel?.unsavePage(page:page)
        NotificationCenter.default.post(name: .init("ReloadFawasil"), object: nil)
    }
}


