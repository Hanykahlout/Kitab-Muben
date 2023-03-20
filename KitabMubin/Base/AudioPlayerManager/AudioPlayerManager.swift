//
//  AudioPlayerManager.swift
//  KitabMubin
//
//  Created by Hany Alkahlout on 11/01/2023.
//

import Foundation
import AVFoundation

class AudioPlayerManager{
    
    private static let sharedInstance:AudioPlayerManager = {
        return AudioPlayerManager()
    }()
    var url = ""
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    
    
    private init(){}
    
    class func shared() -> AudioPlayerManager {
        return sharedInstance
    }
    
    func addLink(url:String){
        self.url = url
        let url = URL(string: url)
        if let url = url{
            playerItem = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: playerItem)
        }
    }
    
    func play(){
        guard let player = player else { return }
        if player.rate == 0
        {
            player.play()
        } else {
            player.pause()
        }
    }
        
    func pause(){
        player?.pause()
    }
    
    func clear(){
        url = ""
        player = nil
        playerItem = nil
        
        
    }
}
