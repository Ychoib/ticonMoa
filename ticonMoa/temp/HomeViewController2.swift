//
//  HomeViewController2.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/05/05.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewController2: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addView: ButtonAddView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "HomeCollectionViewCell2", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell2")
        collectionView.register(UINib(nibName: "HomeCategoryHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCategoryHeaderView")
        
        addView.addButton.rx.tap
            .bind { [weak self] in

            }.disposed(by: bag)
        addView.addButton.rx.controlEvent(.touchDown)
            .bind { [weak self] in
                self?.addView.addButton.shrink()
            }.disposed(by: bag)
        addView.addButton.rx.controlEvent(.touchUpInside)
            .bind { [weak self] in
                self?.addView.addButton.expand()
            }.disposed(by: bag)
        addView.addButton.rx.controlEvent(.touchUpOutside)
            .bind { [weak self] in
                self?.addView.addButton.expand()
            }.disposed(by: bag)
    }
    
    func pullUpView() {
        
    }

}

extension HomeViewController2: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 50) / 2, height: 220)
    }
}

extension HomeViewController2: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell2", for: indexPath) as? HomeCollectionViewCell2 else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 12
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 64)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeCategoryHeaderView", for: indexPath) as? HomeCategoryHeaderView else { return UICollectionReusableView() }
        return header
    }
}
