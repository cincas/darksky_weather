//  Copyright © 2017 Tyler Yang. All rights reserved.

import UIKit
import SnapKit

private let weatherCellIdentifier = "weatherCellIdentifier"
private let lineSpacing: CGFloat = 10.0
private let interitemSpacing: CGFloat = 5.0

class ForecastViewController: UIViewController {
  let viewModel: ForecastViewModel
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = lineSpacing
    layout.minimumInteritemSpacing = interitemSpacing
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return view
  }()
  
  init(viewModel: ForecastViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Forecast"
    view.backgroundColor = .white
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    collectionView.backgroundColor = .white
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
      let columns = CGFloat(viewModel.numberOfItemsInRow)
      
      let width = collectionView.bounds.width / columns - interitemSpacing * (columns - 1)
      layout.estimatedItemSize = CGSize(width: width, height: 1)
    }
  }
}

extension ForecastViewController: UICollectionViewDataSource {
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

extension ForecastViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let weather = viewModel.weather(at: indexPath) else { return }
    
    let detailViewController = viewModel.detailViewController(for: weather)
    present(detailViewController, animated: true, completion: nil)
    
  }
}

class WeatherCollectionViewCell: UICollectionViewCell {
  fileprivate let horizontalPadding: CGFloat = 5.0
  fileprivate let verticalPadding: CGFloat = 10.0
  let summaryLabel = UILabel()
  let iconLabel = UILabel()
  let temperatureLabel = UILabel()
  let dateLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .blue
    [dateLabel, temperatureLabel, iconLabel, summaryLabel].forEach {
      $0.textColor = .white
      $0.textAlignment = .center
      $0.backgroundColor = .clear
      contentView.addSubview($0)
    }
    
    summaryLabel.numberOfLines = 0
    summaryLabel.snp.setLabel("Summary")
    dateLabel.snp.setLabel("Date")
    temperatureLabel.snp.setLabel("Temperature")
    iconLabel.snp.setLabel("Icon")
    
    dateLabel.snp.makeConstraints { make in
      make.left.top.equalToSuperview()
      make.width.equalToSuperview().dividedBy(4.0)
      make.bottom.equalToSuperview()
    }
    
    temperatureLabel.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.width.equalToSuperview().dividedBy(4.0)
      make.left.equalTo(dateLabel.snp.right)
    }
    
    iconLabel.snp.makeConstraints { make in
      make.top.equalTo(temperatureLabel.snp.top)
      make.right.equalToSuperview()
      make.left.equalTo(temperatureLabel.snp.right)
      make.bottom.equalTo(temperatureLabel.snp.bottom)
    }
    
    summaryLabel.snp.makeConstraints { make in
      make.left.equalTo(dateLabel.snp.right)
      make.right.equalToSuperview().inset(horizontalPadding)
      make.top.equalTo(temperatureLabel.snp.bottom).offset(verticalPadding).priority(.medium)
    }
    
    contentView.snp.makeConstraints { make in
      make.bottom.equalTo(summaryLabel.snp.bottom).offset(verticalPadding).priority(.medium)
    }
    
    contentView.translatesAutoresizingMaskIntoConstraints = true
    contentView.autoresizingMask = [.flexibleWidth]
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
    let temperatureHigh = Int(weather.temperatureHigh)
    let temperatureLow = Int(weather.temperatureLow)
    let temperature = "\(temperatureHigh) - \(temperatureLow)"
    let dateString = weather.time.weekdayName.uppercased()
    summaryLabel.text = summary
    iconLabel.text = icon
    temperatureLabel.text = temperature
    dateLabel.text = dateString
    contentView.backgroundColor = UIColor.color(forWeatherIcon: weather.icon)
    setNeedsLayout()
    layoutIfNeeded()
  }
  
  func reset() {
    summaryLabel.text = nil
    iconLabel.text = nil
    temperatureLabel.text = nil
    dateLabel.text = nil
  }
}

