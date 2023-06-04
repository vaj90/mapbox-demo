//
//  PropertyDetailController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-02.
//

import UIKit
import SwiftCarousel
class PropertyDetailController: UIViewController {
    var carouselView: SwiftCarousel!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        setUpView()
    }
    lazy var viewBody: UIView = {
        let v  = UIView()
        v.backgroundColor = UIColor.init(hexString: "#15A9FC")
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return v
    }()
    

    func setUpView(){
        let height = navigationController?.navigationBar.frame.maxY
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(viewBody)
        viewBody.anchor(
            top: view.bottomAnchor, left: view.leftAnchor,
            bottom: view.bottomAnchor, right: view.rightAnchor,
            paddingTop: -15, paddingLeft: 0,
            paddingBottom: -15, paddingRight: 0,
            width: 0, height: 0)
    }
    
    @objc private func goBack(){
        print("tapped")
    }
}
extension PropertyDetailController: SwiftCarouselDelegate {
    
}
