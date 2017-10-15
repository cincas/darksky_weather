//  Copyright © 2017 Tyler Yang. All rights reserved.

import UIKit
import SnapKit

private let weatherCellIdentifier = "weatherCellIdentifier"
private let lineSpacing: CGFloat = 10.0
private let interitemSpacing: CGFloat = 5.0

class ViewController: UIViewController {
  let viewModel = ForecastViewModel()
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = lineSpacing
    layout.minimumInteritemSpacing = interitemSpacing
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: weatherCellIdentifier)
    
    viewModel.load { [weak self] _ in
      DispatchQueue.main.async {
        guard let sself = self else { return }
        sself.collectionView.reloadData()
      }
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      let width = collectionView.bounds.width / 2 - interitemSpacing
      layout.estimatedItemSize = CGSize(width: width, height: 1)
    }
  }
}

extension ViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.numberOfForecastDays()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherCellIdentifier,
                                                  for: indexPath) as! WeatherCollectionViewCell
    if let weather = viewModel.weather(at: indexPath) {
      cell.apply(weather: weather)
    } else {
      cell.reset()
    }
    
    return cell
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
}

class WeatherCollectionViewCell: UICollectionViewCell {
  fileprivate let horizontalPadding: CGFloat = 5.0
  let summaryLabel = UILabel()
  let iconLabel = UILabel()
  let temperatureLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .blue
    [temperatureLabel, iconLabel, summaryLabel].forEach {
      $0.textColor = .white
      $0.textAlignment = .center
      $0.adjustsFontSizeToFitWidth = true
      $0.backgroundColor = .clear
      contentView.addSubview($0)
    }
    
    temperatureLabel.font = UIFont.boldSystemFont(ofSize: 20)
    summaryLabel.numberOfLines = 0
    temperatureLabel.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview()
    }
    
    iconLabel.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.top.equalTo(temperatureLabel.snp.bottom)
    }
    
    summaryLabel.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(horizontalPadding)
      make.top.equalTo(iconLabel.snp.bottom)
    }
    
    contentView.snp.makeConstraints { make in
      make.bottom.equalTo(summaryLabel.snp.bottom)
    }
    
    contentView.translatesAutoresizingMaskIntoConstraints = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
    var newFrame = layoutAttributes.frame
    newFrame.size.height = ceil(size.height)
    layoutAttributes.frame = newFrame
    return layoutAttributes
  }
  
  func apply(weather: Weather) {
    let summary = weather.summary
    let icon = weather.icon
    let temperatureHigh = Int(fahrenheitToCelsius(weather.temperatureHigh))
    let temperatureLow = Int(fahrenheitToCelsius(weather.temperatureLow))
    let temperature = "\(temperatureHigh) - \(temperatureLow)"
    summaryLabel.text = summary
    iconLabel.text = icon
    temperatureLabel.text  = temperature
    setNeedsLayout()
  }
  
  func reset() {
    summaryLabel.text = nil
    iconLabel.text = nil
    temperatureLabel.text = nil
  }
  
  private func fahrenheitToCelsius(_ temperature: Float) -> Float {
    return (temperature - 32.0) * 5.0 / 9.0
  }
}

