//
//  ReaderDetailTableViewCell.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 08/08/2022.
//

import UIKit
import AVFoundation

class ReaderDetailTableViewCell: UITableViewCell {
    
    // MARK: - Outlet's
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var suraNameLabel: UILabel!
    @IBOutlet weak var suraStatusLabel: UILabel!
    @IBOutlet weak var suraStatusImage: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    
    // MARK: - Properties
    var downloadAudio: (()->Void)?
    var playPauseAction: ((String,Bool)->Void)?
    var isDownloaded = false
    var downloadedAudioUpdateAction : ((_ url:String)->Void)?
    var dataSource: ReaderDetailCellViewModel? {
        willSet {
            guard let newValue else { return }
            configure(with: newValue)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
        suraStatusImage.isUserInteractionEnabled = true
        suraStatusImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(downloadAudioAction)))
        slider.addTarget(self, action: #selector(sliderObserving), for: .valueChanged)
    }
    
    // MARK: - Methods
    private func setupAppearance() {
        containerView.addCornerRadius(8)
    }
    
    private func configure(with viewModel: ReaderDetailCellViewModel?) {
        guard let viewModel else { return }
        suraNameLabel.text = viewModel.suraName
        playPauseButton.isSelected = viewModel.isSelected
        isFileDownloaded(url: viewModel.audioURL ?? "")
        
    }
    
    private func isFileDownloaded(url:String){
        guard let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        if let audioUrl = URL(string: url) {
            // then lets create your document folder url
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let fileName = audioUrl.lastPathComponent
            let urlArr = audioUrl.absoluteString.components(separatedBy: "/")
            let readerName = urlArr[urlArr.count - 2]
            let destinationUrl = documentsDirectoryURL.appendingPathComponent("\(readerName)_\(fileName)")
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                DispatchQueue.main.async { [weak self] in
                    self?.suraStatusImage.image = UIImage(named: "Check_mark")
                    self?.suraStatusLabel.text = "تم التنزيل علي الجهاز"
                    
                    self?.isDownloaded = true
                    self?.downloadedAudioUpdateAction?(destinationUrl.absoluteString)
                }
            }else{
                self.suraStatusImage.image = UIImage(named: "down_icon")
                self.suraStatusLabel.text =  "غير منزله"
                self.isDownloaded = false
                
            }
        }
    }
    
    // MARK: - Actions
    
    
    @objc private func downloadAudioAction(){
        downloadAudio?()
    }
    
    func playPuase(isSelected:Bool){
        playPauseButton.isSelected = isSelected
        var url = dataSource?.audioURL ?? ""
        if isDownloaded{
            if let audioUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                url = destinationUrl.absoluteString
            }
        }
        playPauseAction?(url,isSelected)
    }
    
    @objc private func sliderObserving(){
        var url = dataSource?.audioURL ?? ""
        if isDownloaded{
            if let audioUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
                let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                
                let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
                url = destinationUrl.absoluteString
            }
        }
        if url == AudioPlayerManager.shared().url{
            let seconds : Int64 = Int64(slider.value)
            let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
            
            AudioPlayerManager.shared().player?.seek(to: targetTime)
            if playPauseButton.isSelected{
                AudioPlayerManager.shared().player?.play()
            }
        }
    }
    
    
    @IBAction func playPuaseAction(_ sender: Any) {
        playPuase(isSelected: !playPauseButton.isSelected)
    }
    
}



