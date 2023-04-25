//
//  IntroInfoController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-04-22.
//
import UIKit

class IntroInfoController: UIViewController {
    
    let question : UILabel = {
        let label = UILabel()
        label.text = "What is your"
        label.font = UIFont(name: "Ubuntu-Light", size: 40)
        label.textColor = .white
        return label
    }()
    let qFname : UILabel = {
        let label = UILabel()
        label.text = "first name?"
        label.font = UIFont(name: "Ubuntu-Bold", size: 40)
        label.textColor = .white
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavBar()
    }
    
    func createNavBar(){
        let leftImage = UIImage(named: "left-arrow")
        let leftBtnItem = UIBarButtonItem(image: leftImage, style: .plain, target: self, action: #selector(goBack))
        let rightBtnItem = UIBarButtonItem(title: "1/8", style: .plain, target: self, action: nil)
        view.backgroundColor = .blue
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = leftBtnItem
        navigationItem.rightBarButtonItem = rightBtnItem
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    @objc private func goBack(){
        
    }
 
}

