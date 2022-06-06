//
//  ViewController.swift
//  ExCollectionViewWithIndiactor
//
//  Created by 김종권 on 2022/06/06.
//

import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
  // MARK: Constant
  private enum Constant {
    static let collectionViewCellSize = CGSize(width: 80, height: 80)
    static let collectionViewCellSpacing = 18.0
    static let collectionViewContentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    static let collectionViewHeight = 195.0
  }
  
  // MARK: UI
  private let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
      $0.minimumLineSpacing = Constant.collectionViewCellSpacing
      $0.minimumInteritemSpacing = Constant.collectionViewCellSpacing
      $0.itemSize = Constant.collectionViewCellSize
    }
  ).then {
    $0.isScrollEnabled = true
    $0.showsHorizontalScrollIndicator = false
    $0.contentInset = Constant.collectionViewContentInset
    $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
    $0.register(MyCell.self, forCellWithReuseIdentifier: MyCell.id)
  }
  private let indicatorView = IndicatorView()
  
  // MARK: Properties
  private var items = (1...22)
    .map(String.init)
    .map { MyModel(image: UIImage(named: $0), name: "이름\($0)") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.indicatorView)
    
    self.collectionView.snp.makeConstraints {
      $0.centerY.left.right.equalToSuperview()
      $0.height.equalTo(Constant.collectionViewHeight)
    }
    self.indicatorView.snp.makeConstraints {
      $0.top.equalTo(self.collectionView.snp.bottom).offset(4)
      $0.left.right.equalTo(self.collectionView).inset(100)
      $0.height.equalTo(4)
    }
    
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let allWidth = self.collectionView.contentSize.width + self.collectionView.contentInset.left + self.collectionView.contentInset.right
    let showingWidth = self.collectionView.bounds.width
    self.indicatorView.widthRatio = showingWidth / allWidth
    self.indicatorView.layoutIfNeeded()
  }
}

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.items.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    (collectionView.dequeueReusableCell(withReuseIdentifier: MyCell.id, for: indexPath) as! MyCell).then {
      let item = self.items[indexPath.item]
      $0.prepare(image: item.image, name: item.name)
    }
  }
}

extension ViewController: UICollectionViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // contentOffset: 스크롤한 길이
    // contentInset: collectionView의 테두리 부분과의 여백 (4곳만 존재)
    // contentSize: 스크롤 가능한 콘텐츠 사이즈 (주의 - contentInset 값을 합해야, collectionView 전체 콘텐트 사이즈)
    
    let scroll = scrollView.contentOffset.x + scrollView.contentInset.left
    let width = scrollView.contentSize.width + scrollView.contentInset.left + scrollView.contentInset.right
    let scrollRatio = scroll / width
    
    self.indicatorView.leftOffsetRatio = scrollRatio
  }
}
