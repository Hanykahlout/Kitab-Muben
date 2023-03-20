//
//  SuraHeaderView.swift
//  KitabMubin
//
//  Created by Hany Alkahlout on 24/01/2023.
//

import UIKit

class SuraView: UIView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var suraNameLabel: UILabel!
    @IBOutlet weak var suraTextLabel: CopyableLabel!
    @IBOutlet weak var basmalaLabel: UILabel!
    @IBOutlet weak var suraHeaderView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    private func initialization(){
        Bundle.main.loadNibNamed("SuraView", owner: self, options: nil)
        mainView.fixInView(self)
        
    }
    
   
    
}







