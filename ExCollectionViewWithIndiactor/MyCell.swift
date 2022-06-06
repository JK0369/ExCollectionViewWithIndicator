//
//  MyCell.swift
//  ExCollectionViewWithIndiactor
//
//  Created by 김종권 on 2022/06/06.
//


import UIKit
import SnapKit
import Then

final class MyCell: UICollectionViewCell {
  // MARK: Constants
  static let id = "MyCell"
  
  // MARK: UI
  private let imageView = UIImageView().then {
    $0.isUserInteractionEnabled = false
  }
  private let label = UILabel().then {
    $0.font = .systemFont(ofSize: 14, weight: .bold)
    $0.numberOfLines = 1
    $0.textColor = .black
    $0.textAlignment = .center
  }
  
  // MARK: Initializer
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.contentView.addSubview(self.imageView)
    self.contentView.addSubview(self.label)
    
    self.imageView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.bottom.equalToSuperview().inset(15)
    }
    self.label.snp.makeConstraints {
      $0.top.equalTo(self.imageView.snp.bottom).offset(4)
      $0.left.right.bottom.equalToSuperview()
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.prepare(image: nil, name: nil)
  }
  
  func prepare(image: UIImage?, name: String?) {
    self.imageView.image = image
    self.label.text = name
  }
}
