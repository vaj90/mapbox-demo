//
//  TagListController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-06.
//
import UIKit
import QuartzCore
class TagCollectionViewCell : UICollectionViewCell {
    static let identifier = "cell"
    lazy var link: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.init(hexString: "#68B2F0")
        lbl.font = UIFont(name:"Ubuntu-Bold", size: 16.0)
        lbl.layer.borderColor = UIColor.init(hexString: "#68B2F0").cgColor
        lbl.layer.borderWidth = 1.0
        lbl.layer.cornerRadius = 15
        lbl.textAlignment = .center
        var taplbl =  UITapGestureRecognizer(target: self, action: #selector(btnClick(_:)))
        lbl.addGestureRecognizer(taplbl)
        lbl.isUserInteractionEnabled = true
        return lbl
    }()


    @objc func btnClick(_ sender: Any){
        print("click")
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configure( with item: String){
        link.text = item
    }
    override init(frame: CGRect) {
          super.init(frame: frame)

          addUIItem()
      }
    func addUIItem(){
        addSubview(link)
        link.layer.masksToBounds = true
        link.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    override func layoutSubviews() {
        let cvSize = contentView.frame.size
        link.frame = CGRect(x: 0, y: 0, width: cvSize.width, height: cvSize.height)
    }
    @IBAction func googleIt(_ sender: Any){
        //let str = link.text
    }
}
class TagListController: UIViewController {
    
    var collectionview: UICollectionView!
    
    let countries = ["Armenia","Azerbaijan","Bahrain","Bangladesh","Bhutan","Brunei", "Cambodia","China","Cyprus","Georgia","India","Indonesia","Iran","Iraq","Israel", "Japan","Jordan","Kazakhstan","Kuwait","Kyrgyzstan","Laos","Lebanon","Malaysia","Maldives","Mongolia","Myanmar","Nepal","North Korea","Oman","Pakistan","Palestine","Philippines","Qatar","Russia","Saudi Arabia","Singapore","South Korea","Sri Lanka","Syria","Taiwan","Tajikistan","Thailand","Timor Leste","Turkey","Turkmenistan","United Arab Emirates","Uzbekistan","Vietnam","Yemen"]
    var titleLbl : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hexString: "#1D82D6")
        label.text = "Countries in Asia"
        label.font = UIFont(name:"Ubuntu-Bold", size: 18.0)
        label.textAlignment = .center
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        setUpView()
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        collectionview.showsHorizontalScrollIndicator = false
    }
    lazy var viewBody: UIView = {
        let v  = UIView()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 20)
        collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        v.addSubview(titleLbl)
        titleLbl.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 20, paddingRight: 0,
            width: 0, height: 0)
        let innerv  = UIView()
        v.addSubview(innerv)
        innerv.anchor(
            top: titleLbl.bottomAnchor, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 20, paddingLeft: 20,
            paddingBottom: 20, paddingRight: 20,
            width: 0, height: 0)
        innerv.addSubview(collectionview)
        collectionview.anchor(
            top: innerv.topAnchor, left: innerv.leftAnchor,
            bottom: innerv.bottomAnchor, right: innerv.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return v
    }()
    
    lazy var topNav: UIView = {
        let v  = UIView()
        let img = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = UIColor.init(hexString: "#1D82D6")
        
        let tapImg =  UITapGestureRecognizer(target: self, action: #selector(goBack))
        imgV.addGestureRecognizer(tapImg)
        imgV.isUserInteractionEnabled = true
        
        let lblStep = UILabel()
        lblStep.textColor = UIColor.init(hexString: "#1D82D6")
        lblStep.text = "1/8"
        lblStep.font = UIFont(name:"Ubuntu-Bold", size: 16.0)
        lblStep.textAlignment = .center
        
        let tapSkip = UITapGestureRecognizer(target: self, action: #selector(goSkip))
        lblStep.addGestureRecognizer(tapSkip)
        lblStep.isUserInteractionEnabled = true
        
        v.addSubview(imgV)
        v.addSubview(lblStep)
        imgV.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 15,
            paddingBottom: 5, paddingRight: 0,
            width: 32, height: 32)
        lblStep.anchor(
            top: nil, left: nil,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 5, paddingRight: 15,
            width: 32, height: 32)

        v.backgroundColor =  .white
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        v.layer.zPosition = 1
        return v
    }()
    
    func setUpView(){
        let height = navigationController?.navigationBar.frame.maxY
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(topNav)
        topNav.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 50, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: /*height?.native ??*/ 44)
    
        
        view.addSubview(viewBody)
        viewBody.anchor(
            top: topNav.bottomAnchor, left: topNav.leftAnchor,
            bottom: view.bottomAnchor, right: topNav.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        //viewBody.backgroundColor = .gray
    }
    
    @objc private func goBack(){
        print("tapped")
    }
    @objc private func goNext(){
        let nextController = AgeInfoController()
        self.navigationController?.pushViewController(nextController, animated: true )
        print("next")
    }
    @objc private func goSkip(){
        print("skip")
    }
 
}
extension TagListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as! TagCollectionViewCell
        cell.link.text = countries[indexPath.row]
        //cell.backgroundColor = .gray
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("\(countries[indexPath.row])")
        /*let str = countries[indexPath.row]
        let link = "https://www.google.com/search?q=\(str)"
        if let url = URL(string:link) {
            UIApplication.shared.open(url)
        }*/
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = countries[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width + 10, height: 30)
    }

}
