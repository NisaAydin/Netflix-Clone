
//
//  CollectionViewTableViewCell.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 20.03.2024.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject{
    func collectionViewTableViewCellTapCell(_ cell:CollectionViewTableViewCell,viewmodel:TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell"
    weak var delegate: CollectionViewTableViewCellDelegate?
    private var titles : [Title] = [Title]()
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    public func configure(with titles: [Title]){
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
    }
    
    public func downloadTitleAt(indexPath: IndexPath){
        let title = titles[indexPath.row]
        let name = title.original_title ?? title.original_name ?? ""
        DataPersistenceManager.shared.downloadTitleWith(model: title) { results in
            switch results {
 
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        print("Downloading \(name )")
    }
     

}
extension CollectionViewTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else{
            return UICollectionViewCell()
        }
        guard let model = titles[indexPath.row].poster_path else{
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title  else {
            return
        }
        APICaller.shared.getMovieTrailer(with: titleName + " trailer") { [weak self] result in
            
            switch result{
            case .success(let videoElemet):
                let title = self?.titles[indexPath.row]
                guard let overview = title?.overview else {
                    return
                }
                guard let strongSelf = self else{
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElemet, titleOverview: overview)
                self?.delegate?.collectionViewTableViewCellTapCell(strongSelf, viewmodel: viewModel)
               
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        //  koleksiyon görünümünde bir öğeye uzun basıldığında çağrılır.
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                self?.downloadTitleAt(indexPath: indexPath)
   
            }

            return UIMenu(title:  "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            //  children parametresine tek bir UIAction nesnesi olan downloadAction eklenmiştir.
            // Kullanıcı bu seçeneği tıkladığında, downloadAction'ın closure bloğu çalıştırılır ve bu blokta tanımlanan işlemler gerçekleşir
        }
        return config
    }
}
