//
//  NestedSampleController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-06-07.
//
import UIKit
import QuartzCore

struct Country: Codable {
    var continent: String
    var countries: [String]
}
class CountryTableViewCell : UITableViewCell {
    static let identifier = "cell"
    lazy var countryLbl: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hexString: "#1D82D6")
        label.text = ""
        label.font = UIFont(name:"Ubuntu-Bold", size: 18.0)
        return label
    }()
    func createBtn(name: String) -> UIButton{
        let btn = UIButton()
        btn.setTitle("\(name)", for: .normal)
        btn.setTitleColor(UIColor.init(hexString: "#1D82D6"), for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = UIFont(name:"Ubuntu-Light", size: 16.0)
        btn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner ]
        btn.layer.borderColor = UIColor.init(hexString: "#1D82D6").cgColor
        btn.layer.borderWidth = 2
        let img = UIImage(named:"star")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return btn
    }
    @objc private func btnClick(_ sender: UIButton){
        let btn = sender
        if let title = btn.currentTitle {
            print(title)
        }
    }
    var btns: [UIButton]!
    var country: Country!
    func configure(){
        countryLbl.text = "\(country.continent.capitalized)"
        let iV = UIScrollView()
        let v = contentView
        btns = country!.countries.map {
            createBtn(name: $0)
        }
        
        var xAxis = 0
        var yAxis = 0
        var lastHeight = 0
        let innerVSize = Int(self.frame.width) - 90
        var currenBtnSize = 0
        DispatchQueue.main.async {
            self.btns.map{
                let btn = $0
                iV.addSubview(btn)
                
                let label = UILabel(frame: CGRect.zero)
                label.text = btn.currentTitle
                label.sizeToFit()
                
                let len =  Int(CGFloat(label.frame.width + 45))
                btn.frame = CGRect(x: xAxis, y: yAxis, width: len, height: 30)
                currenBtnSize = currenBtnSize + len
                xAxis = xAxis + len + 5
                if currenBtnSize > innerVSize {
                    yAxis = yAxis + 40
                    xAxis = 0
                    currenBtnSize =   0
                }
                
                lastHeight = yAxis
            }

            print(lastHeight)
            v.addSubview(iV)
            iV.anchor(top: self.countryLbl.bottomAnchor, left: v.leftAnchor, bottom: nil, right: v.rightAnchor,
                      paddingTop: 10, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 0, height: CGFloat(lastHeight))
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(countryLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        let cvSize = contentView.frame.size
        countryLbl.frame = CGRect(x: 0, y: 0, width: cvSize.width , height: 20)
    }
    
}
class NestedSampleController: UIViewController{
    lazy var tableView: UITableView = UITableView()
    let asia = ["Armenia","Azerbaijan","Bahrain","Bangladesh","Bhutan","Brunei", "Cambodia","China","Cyprus","Georgia","India","Indonesia","Iran","Iraq","Israel", "Japan","Jordan","Kazakhstan","Kuwait","Kyrgyzstan","Laos","Lebanon","Malaysia","Maldives","Mongolia","Myanmar","Nepal","North Korea","Oman","Pakistan","Palestine","Philippines","Qatar","Russia","Saudi Arabia","Singapore","South Korea","Sri Lanka","Syria","Taiwan","Tajikistan","Thailand","Timor Leste","Turkey","Turkmenistan","United Arab Emirates","Uzbekistan","Vietnam","Yemen"]
    let northAmerica = ["Antigua and Barbuda","Bahamas","Barbados","Belize","Canada","Costa Rica","Cuba","Dominica","Dominican Republic","El Salvador","Grenada","Guatemala","Haiti","Honduras","Jamaica","Mexico","Nicaragua","Panama","Saint Kitts and Nevis","Saint Lucia","Saint Vincent and the Grenadines","Trinidad and Tobago","United States of America"]
    var views: [UIView]!
    var countryList: [Country]!
    var list = ["Asia", "North America"]
    var titleLbl : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hexString: "#1D82D6")
        label.text = "Area"
        label.font = UIFont(name:"Ubuntu-Bold", size: 18.0)
        label.textAlignment = .center
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        countryList = [
            Country(continent: "asia", countries: asia),
            Country(continent: "north-america", countries: northAmerica)
        ]

        setUpView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.identifier)
        //tableView.estimatedRowHeight = 500
        //tableView.rowHeight = UITableView.automaticDimension
    }
    
    lazy var viewBody: UIView = {
        let v = UIView()
        v.addSubview(titleLbl)
        titleLbl.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 10, paddingRight: 0,
            width: 0, height: 30)
        
        let iV = UIView()
        v.addSubview(iV)
        iV.anchor(top: titleLbl.bottomAnchor, left: v.leftAnchor, bottom: v.bottomAnchor, right: v.rightAnchor,
                  paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)

        
        DispatchQueue.main.async {
            iV.addSubview(self.tableView)
            self.tableView.anchor(
                top: iV.topAnchor, left: iV.leftAnchor,
                bottom: iV.bottomAnchor, right: iV.rightAnchor,
                paddingTop: 0, paddingLeft: 0,
                paddingBottom: 0, paddingRight: 0,
                width: 0, height: 0)
            self.tableView.reloadData()
        }
      
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
    
        v.addSubview(imgV)
        imgV.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: nil,
            paddingTop: 0, paddingLeft: 15,
            paddingBottom: 5, paddingRight: 0,
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
extension NestedSampleController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier) as! CountryTableViewCell
        cell.country = countryList[indexPath.row]
        cell.configure()
    
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cnt = countryList[indexPath.row].countries.count
        let vHeight = (cnt/3) * 40
        return CGFloat(vHeight + 140)
    }

}
