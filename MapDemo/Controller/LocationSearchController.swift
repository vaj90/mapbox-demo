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
class NeighbourhoodTableViewCell : UITableViewCell {
    static let identifier = "NeighbourhoodCell"
    let cancelImage : UIImageView = {
        let _cancelImg = UIImageView()
        let img = UIImage(named:"cross")?.withRenderingMode(.alwaysTemplate)
        _cancelImg.image = img
        _cancelImg.tintColor = UIColor.init(hexString: "#1d82d6")
        _cancelImg.isUserInteractionEnabled = true
       return _cancelImg
    }()
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
        neighbourhoodName.frame = CGRect(x: 10, y: 0, width: cvSize.width, height: cvSize.height)
    }
    
}

class LocationSearchController: UIViewController {
    lazy var searchBar:UISearchBar = UISearchBar()
    lazy var tableView: UITableView = UITableView()
    var filteredData: [Neighbourhood]!
    let cellSpacingHeight: CGFloat = 5
    var selectedCells:[Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(hexString: "#f3f9ff")
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
        
        v.addSubview(lblSelectedNeigh)
        lblSelectedNeigh.anchor(
            top: v.topAnchor, left: v.leftAnchor,
            bottom: nil, right: v.rightAnchor,
            paddingTop: 20, paddingLeft: 0,
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 20)
        
        v.addSubview(tableView)
        tableView.anchor(
            top: lblSelectedNeigh.bottomAnchor, left: v.leftAnchor,
            bottom: v.bottomAnchor, right: v.rightAnchor,
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
            paddingBottom: 0, paddingRight: 0,
            width: 0, height: 0)

    }
    
    @objc private func goBack(){
        //let infoController = IntroInfoController()
       // self.navigationController?.popViewController(animated: true )
        print("tapped")
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
        cell.neighbourhoodName.text = filteredData[indexPath.row].neighbourhoodName
        cell.clipsToBounds = true
        cell.accessoryType = self.selectedCells.contains(filteredData[indexPath.row].neighbourhoodId) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedCells.contains(filteredData[indexPath.row].neighbourhoodId) {
            let index = self.selectedCells.firstIndex(of: filteredData[indexPath.row].neighbourhoodId)
            selectedCells.remove(at: index!)
        }
        else{
            selectedCells.append(filteredData[indexPath.row].neighbourhoodId)
        }
        print(selectedCells)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if self.selectedCells.contains(filteredData[indexPath.row].neighbourhoodId) {
                let index = self.selectedCells.firstIndex(of: filteredData[indexPath.row].neighbourhoodId)
                selectedCells.remove(at: index!)
            }
            filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with:  .fade)
            tableView.endUpdates()
        }
    }
    
    func getList() -> Array<Neighbourhood>{
        let data = [
            Neighbourhood(neighbourhoodId: 1, neighbourhoodName:  "Alexandra Park"),
            Neighbourhood(neighbourhoodId: 2, neighbourhoodName:  "The Annex"),
            Neighbourhood(neighbourhoodId: 3, neighbourhoodName:  "Baldwin Village"),
            Neighbourhood(neighbourhoodId: 4, neighbourhoodName:  "Cabbagetown"),
            Neighbourhood(neighbourhoodId: 5, neighbourhoodName:  "CityPlace"),
            Neighbourhood(neighbourhoodId: 6, neighbourhoodName:  "Chinatown"),
            Neighbourhood(neighbourhoodId: 7, neighbourhoodName:  "Church and Wellesley"),
            Neighbourhood(neighbourhoodId: 8, neighbourhoodName:  "Corktown"),
            Neighbourhood(neighbourhoodId: 9, neighbourhoodName:  "Discovery District"),
            Neighbourhood(neighbourhoodId: 10, neighbourhoodName:  "Distillery District"),
            Neighbourhood(neighbourhoodId: 11, neighbourhoodName:  "Entertainment District"),
            Neighbourhood(neighbourhoodId: 12, neighbourhoodName:  "East Bayfront"),
            Neighbourhood(neighbourhoodId: 13, neighbourhoodName:  "Fashion District"),
            Neighbourhood(neighbourhoodId: 14, neighbourhoodName:  "Financial District"),
            Neighbourhood(neighbourhoodId: 15, neighbourhoodName:  "Garden District"),
            Neighbourhood(neighbourhoodId: 16, neighbourhoodName:  "Grange Park"),
            Neighbourhood(neighbourhoodId: 17, neighbourhoodName:  "Harbord Village"),
            Neighbourhood(neighbourhoodId: 18, neighbourhoodName:  "Harbourfront"),
            Neighbourhood(neighbourhoodId: 19, neighbourhoodName:  "Kensington Market"),
            Neighbourhood(neighbourhoodId: 20, neighbourhoodName:  "Little Japan"),
            Neighbourhood(neighbourhoodId: 21, neighbourhoodName:  "Moss Park"),
            Neighbourhood(neighbourhoodId: 22, neighbourhoodName:  "Old Town"),
            Neighbourhood(neighbourhoodId: 23, neighbourhoodName:  "Quayside"),
            Neighbourhood(neighbourhoodId: 24, neighbourhoodName:  "Queen Street West"),
            Neighbourhood(neighbourhoodId: 25, neighbourhoodName:  "Regent Park"),
            Neighbourhood(neighbourhoodId: 26, neighbourhoodName:  "South Core"),
            Neighbourhood(neighbourhoodId: 27, neighbourhoodName:  "St. James Town"),
            Neighbourhood(neighbourhoodId: 28, neighbourhoodName:  "St. Lawrence"),
            Neighbourhood(neighbourhoodId: 29, neighbourhoodName:  "Toronto Islands"),
            Neighbourhood(neighbourhoodId: 30, neighbourhoodName:  "Trefann Court"),
            Neighbourhood(neighbourhoodId: 31, neighbourhoodName:  "University"),
            Neighbourhood(neighbourhoodId: 32, neighbourhoodName:  "Yorkville")
        ]
        
        return data
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? [] : getList().filter { $0.neighbourhoodName.contains(searchText)}
        //print(filteredData)
        tableView.reloadData()
        selectedCells = []
    }
}
