//
//  MovieViewController.swift
//
//  Created by Clarissa Nurawan on 3/4/21.
//

import UIKit

class MovieViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel = MovieViewModel()
    private var apiService = ApiService()

    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLatestMovies(page: 1)
        
        //Refresh when screen is pulled
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(refreshData),
                                            for: .valueChanged)
        
        searchField.delegate = self
        
    }
    
    @objc func refreshData(_ sender: Any) {
        loadLatestMovies(page: 1)
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func loadLatestMovies(page thisPage : Int) {
        viewModel.fetchLatestMovies(page: thisPage){ [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
            self?.tableView.delegate = self
        }
    }
    
}

extension MovieViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Output textfield")
        viewModel.searchMovie(title: textField.text ?? "nil")
    }
    
    
}

// MARK: - TableView
extension MovieViewController : UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.latestMovies.count
            
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if viewModel.currentPage < viewModel.totalPages && indexPath.row == viewModel.latestMovies.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loading") as! MovieTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
            let movie = viewModel.cellForRowAt(indexPath: indexPath)
            cell.setCellValues(movie)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //To load more data
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.currentPage < viewModel.totalPages && indexPath.row == viewModel.latestMovies.count - 1 {
            viewModel.currentPage = viewModel.currentPage + 1
            loadLatestMovies(page: viewModel.currentPage)
        }
    }

    //To load detailPage by movie id
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        let movieIdInt: Int = movie.id ?? 0
        self.navigationController?.pushViewController(DetailViewController.instantiate(movieId: movieIdInt), animated: true)
    }
}
