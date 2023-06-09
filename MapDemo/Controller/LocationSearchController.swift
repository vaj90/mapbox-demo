//
//  LocationSearchController.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-05-22.
//

import UIKit
struct Neighbourhood {
    var neighbourhoodId: Int
    var neighbourhoodName : String
    //var neighbourhoodImage : UIImage
    //var neighbourhoodDesc : String
}
struct Neighbourhoods: Codable {
    var returnCode: Int
    var data: [NeighbourhoodItem]
}
struct NeighbourhoodItem: Codable {
    var id: Int
    var name: String
}
class NeighbourhoodTableViewCell : UITableViewCell {
    static let identifier = "NeighbourhoodCell"
    lazy var cancelImage : UIImageView = {
        let _cancelImg = UIImageView()
        let img = UIImage(named:"cross")?.withRenderingMode(.alwaysTemplate)
        _cancelImg.image = img
        _cancelImg.tintColor = UIColor.init(hexString: "#1d82d6")
        _cancelImg.isUserInteractionEnabled = true
        let tapImg =  UITapGestureRecognizer(target: self, action: #selector(btnClick(_:)))
        _cancelImg.addGestureRecognizer(tapImg)
        _cancelImg.isUserInteractionEnabled = true
       return _cancelImg
    }()
    @objc func btnClick(_ sender: Any){
        print("click")
    }
    let neighbourhoodName = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        //contentView.addSubview(cancelImage)
        contentView.addSubview(neighbourhoodName)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        let cvSize = contentView.frame.size
        //cancelImage.frame = CGRect(x: 5, y: 6, width: 30, height: 30)
        neighbourhoodName.frame = CGRect(x: 15, y: 0, width: cvSize.width, height: cvSize.height)
    }
    
}

class LocationSearchController: UIViewController {
    lazy var searchBar:UISearchBar = UISearchBar()
    lazy var tableView: UITableView = UITableView()
    var neighbourhoods: [NeighbourhoodItem]!
    var filteredData: [NeighbourhoodItem]!
    let cellSpacingHeight: CGFloat = 5
    var selectedCells:[Int] = []
    var selectedNeighbourhoods: [NeighbourhoodItem]! = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hexString: "#f3f9ff")
        getList()
        filteredData = []
        setUpView()
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NeighbourhoodTableViewCell.self, forCellReuseIdentifier: NeighbourhoodTableViewCell.identifier)
        tableView.backgroundView = UIView()
        tableView.backgroundColor = .white
        tableView.allowsMultipleSelection = true
    }
    lazy var viewBody: UIView = {
        let v  = UIView()
        let lblSelectedNeigh = UILabel()
        lblSelectedNeigh.textColor =  UIColor.init(hexString: "#1d82d6")
        lblSelectedNeigh.text = "Selected Neighbourhoods"
        lblSelectedNeigh.font = UIFont(name:"Ubuntu-Light", size: 16.0)
        lblSelectedNeigh.textAlignment = .left
        let btnSubmit = UIButton()
        btnSubmit.setTitle("Submit", for: .normal)
        btnSubmit.setTitleColor(UIColor.init(hexString: "#1d82d6"), for: .normal)
        btnSubmit.backgroundColor = UIColor.init(hexString: "#00ffff")
        btnSubmit.layer.cornerRadius = 5
        btnSubmit.titleLabel?.font = UIFont(name:"Ubuntu-Bold", size: 16.0)
        btnSubmit.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner ]
        btnSubmit.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        v.addSubview(lblSelectedNeigh)
        lblSelectedNeigh.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 20, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 20)
        
        v.addSubview(btnSubmit)
        btnSubmit.anchor(
            top: nil, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 20, paddingLeft: 0,
            paddingBottom: 10, paddingRight: 0,
            width: 0, height: 40)
        
        v.addSubview(tableView)
        tableView.anchor(
            top: lblSelectedNeigh.bottomAnchor, left: v.leftAnchor,
            bottom: btnSubmit.topAnchor, right: v.rightAnchor,
            paddingTop: 20, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)
        tableView.backgroundColor = UIColor.init(hexString: "#f3f9ff")
        
        v.backgroundColor = UIColor.init(hexString: "#f3f9ff")
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return v
    }()
    
    
    
    lazy var topNav: UIView = {
        let v  = UIView()
        let innerview = UIView()
        let tapImg =  UITapGestureRecognizer(target: self, action: #selector(goBack))
        
        let img = UIImage(named:"left-arrow")?.withRenderingMode(.alwaysTemplate)
        var imgV = UIImageView(image: img!)
        imgV.tintColor = UIColor.init(hexString: "#1d82d6")
        imgV.addGestureRecognizer(tapImg)
        imgV.isUserInteractionEnabled = true
        
        v.addSubview(innerview)
        innerview.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 40)
        
        innerview.backgroundColor = .white
        
        innerview.addSubview(imgV)
        imgV.anchor(
            top: innerview.topAnchor, left: innerview.leftAnchor,
            bottom: innerview.bottomAnchor, right: nil,
            paddingTop: 5, paddingLeft: 5,
            paddingBottom: 5, paddingRight: 0,
            width: 30, height: 25)
        let image = UIImage()
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Enter Locality Name"
        searchBar.sizeToFit()
        searchBar.backgroundColor = .clear
        searchBar.backgroundImage = image
        searchBar.isTranslucent = true
        searchBar.searchTextField.backgroundColor = .white
        
        innerview.addSubview(searchBar)
        searchBar.anchor(
            top: innerview.topAnchor, left: imgV.rightAnchor,
            bottom: innerview.bottomAnchor, right: innerview.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 25)
        
        v.backgroundColor =  UIColor.init(hexString: "##dcefff")
        v.layer.zPosition = 1
        return v
    }()
    
    @objc private func goBack(){
        let vController = MapSearchController()
        print(selectedCells)
        vController.neighbourhoodIds = selectedCells
        self.navigationController?.pushViewController(vController, animated: true )
    }
    func setUpView(){
        let height = navigationController?.navigationBar.frame.maxY
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(topNav)
        topNav.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            bottom: nil, right: view.rightAnchor,
            paddingTop: 60, paddingLeft: 15,
            paddingBottom: 15, paddingRight: 15,
            width: 0, height: /*height?.native ??*/ 44)
        

        view.addSubview(viewBody)
        viewBody.anchor(
            top: topNav.bottomAnchor, left: topNav.leftAnchor,
            bottom: view.bottomAnchor, right: topNav.rightAnchor,
            paddingTop: 0, paddingLeft: 0,
            paddingBottom: 10, paddingRight: 0,
            width: 0, height: 0)

    }
    

 
}

extension LocationSearchController : UISearchBarDelegate , UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NeighbourhoodTableViewCell.identifier) as! NeighbourhoodTableViewCell
        cell.neighbourhoodName.text = filteredData[indexPath.row].name
        cell.clipsToBounds = true
        cell.accessoryType = self.selectedCells.contains(filteredData[indexPath.row].id) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedCells.contains(filteredData[indexPath.row].id) {
            let index = self.selectedCells.firstIndex(of: filteredData[indexPath.row].id)
            selectedCells.remove(at: index!)
            if let idx = selectedNeighbourhoods.index(where: { $0.id == filteredData[indexPath.row].id}){
                selectedNeighbourhoods.remove(at: idx)
            }
        }
        else{
            selectedCells.append(filteredData[indexPath.row].id)
            selectedNeighbourhoods.append(NeighbourhoodItem(id: filteredData[indexPath.row].id,
                                                            name: filteredData[indexPath.row].name))
        }
        print(selectedNeighbourhoods)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if self.selectedCells.contains(filteredData[indexPath.row].id) {
                let index = self.selectedCells.firstIndex(of: filteredData[indexPath.row].id)
                selectedCells.remove(at: index!)
            }
            filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with:  .fade)
            tableView.endUpdates()
        }
    }
    
    func getList(){
        MapManager.instance.get(url: "https://blocestate-mobile-api.azurewebsites.net/api/lookup/neighbourhoods") { [self]
            (response, error) in
            if let result = response {
                do{
                    var nList = try JSONDecoder().decode(Neighbourhoods.self, from: result)
                    var items = nList.data
                    neighbourhoods = items
                }catch{
                    print("something went wrong!")
                 }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        var filter = searchText.isEmpty ? [] : neighbourhoods.filter { $0.name.contains(searchText)}
        if !selectedNeighbourhoods.isEmpty {
            filteredData.append(contentsOf: selectedNeighbourhoods)
        }
        filteredData.append(contentsOf: filter)
        tableView.reloadData()
    }
}
