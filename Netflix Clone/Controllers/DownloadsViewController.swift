//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 20.03.2024.
//

import UIKit

class DownloadsViewController: UIViewController{
 
    private var titles: [TitleItems] = [TitleItems]()
    private let downloadTable: UITableView = {
        
        let table = UITableView()
        table.register(TitleUpcomingTableViewCell.self, forCellReuseIdentifier: TitleUpcomingTableViewCell.identifier)
        return table
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        
        downloadTable.delegate=self
        downloadTable.dataSource=self
        view.addSubview(downloadTable)
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    private func fetchLocalStorageForDownload(){
      
        DataPersistenceManager.shared.fetchingTitlesFromDataBase { [weak self] results in
            switch results {
            case .success(let title):
                self?.titles = title
                DispatchQueue.main.async {
                    self?.downloadTable.reloadData()
                }
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame=view.bounds
    }
    


}
extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:TitleUpcomingTableViewCell.identifier, for: indexPath) as? TitleUpcomingTableViewCell else {
            return UITableViewCell()
        }
        let titleName = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "Unknown"
        let posterUrl = titles[indexPath.row].poster_path
        cell.configure(with: TitleViewModel(titleName: titleName, posterUrl: posterUrl ?? ""))
        return cell
         
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //  bir hücrenin düzenleme stilini işlemek için kullanılır. Örneğin, bir hücreyi silmek
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { results in
                switch results{
                case .success():
                    print("Delete from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }

         default:
            break;
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title  else {
            return
        }
        guard let overview = title.overview else {
            return
        }
        APICaller.shared.getMovieTrailer(with: titleName+" trailer") { [weak self] results in
            switch results {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: overview))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
              
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let initialTransform = CGAffineTransform(translationX: 0, y: -50) 
        cell.transform = initialTransform
        cell.alpha = 0

        UIView.animate(withDuration: 0.5, delay: 0.05 * Double(indexPath.row), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1
        })
    }

    
}
