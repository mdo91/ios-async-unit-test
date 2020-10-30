//
//  ViewController.swift
//  DogPatch
//
//  Created by Mdo on 26/10/2020.
//  Copyright © 2020 Mdo. All rights reserved.
//

import UIKit

class ListingViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!{
        
        didSet{
            tableView.register(ErrorTableViewCell.nib, forCellReuseIdentifier: ErrorTableViewCell.identifier)
        }
        
        
        
        
    }
    //MARK: - Instance Properties
    
    var networkClient: DogPatchService = DogpatchClient.shared
    var imageClient: ImageService = ImageClient.shared
    
    var viewModels : [DogViewModel] = []
    var dataTask:URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpRefreshControl()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = UIColor.clear
        tableView.tableFooterView = UIView()
    }
    
    private func setUpRefreshControl(){
        let refershControl = UIRefreshControl()
        tableView.refreshControl = refershControl
        
        refershControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refershControl.attributedTitle = NSAttributedString(string: "Loading...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    //MARK: - Refresh
    @objc func refreshData(){
        guard dataTask == nil else{
            return
        }
        self.tableView.refreshControl?.beginRefreshing()
        
        dataTask = networkClient.getDogs() { dogs, error in
            self.dataTask = nil
            self.viewModels = dogs?.map{ DogViewModel(dog: $0) } ?? []
            
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            
        }
        

    }


}

extension ListingViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !tableView.refreshControl!.isRefreshing else{
            return 0
        }
        return max(viewModels.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard viewModels.count > 0 else{
            
            return errorCell(tableView, indexPath)
        }
        print("viewModels.count \(viewModels.count)")
        return listingCell(tableView, indexPath)
    }
    
    private func errorCell(_ tableView:UITableView, _ indexPath:IndexPath) -> UITableViewCell{
        
        return tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.identifier) as! ErrorTableViewCell
    }
    
    private func listingCell(_ tableView:UITableView, _ indexPath:IndexPath) -> ListingTableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListingTableViewCell.identifier) as! ListingTableViewCell
        
        let viewModel = viewModels[indexPath.row]
        viewModel.configure(cell)
        
        imageClient.setImage(on: cell.dogImageView,
                             fromURL: viewModel.imageURL,
                             withPlaceHolder: UIImage(named: "image_placeholder"))
        return cell
    }

}

extension ListingViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
