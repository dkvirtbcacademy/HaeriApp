//
//  CityAirPollutionCell.swift
//  Haeri
//
//  Created by kv on 09.01.26.
//

import UIKit

class CityAirPollutionCell: UITableViewCell {
    
    static let identifier = "CityAirPollutionCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let trapezoidView: TrapezoidView = {
        let view = TrapezoidView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let aqiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .firagoMedium(.large)
        label.textColor = .text
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .firago(.xxsmall)
        label.textColor = .text.withAlphaComponent(0.7)
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .firagoMedium(.medium)
        label.textColor = .text
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let pollutantBadge: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .firago(.small)
        label.textColor = .text
        label.textAlignment = .center
        label.text = "AQI"
        label.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setCointainerView()
        setTrapezoid()
        setStackViews()
        setIconImageView()
        setPollutantBadge()
    }
    
    private func setCointainerView() {
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 150),
        ])
        
    }
    
    private func setTrapezoid() {
        containerView.addSubview(trapezoidView)
        trapezoidView.applyMediumGlass(cornerRadius: 20)
        
        NSLayoutConstraint.activate([
            trapezoidView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            trapezoidView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            trapezoidView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
            trapezoidView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            trapezoidView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setStackViews() {
        let leftStack = UIStackView(arrangedSubviews: [aqiLabel])
        leftStack.axis = .vertical
        leftStack.spacing = 8
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        
        let infoStack = UIStackView(arrangedSubviews: [statusLabel, cityLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 2
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        trapezoidView.addSubview(leftStack)
        trapezoidView.addSubview(infoStack)
        trapezoidView.addSubview(pollutantBadge)
        
        NSLayoutConstraint.activate([
            leftStack.leadingAnchor.constraint(equalTo: trapezoidView.leadingAnchor, constant: 20),
            leftStack.bottomAnchor.constraint(equalTo: infoStack.topAnchor, constant: -4),
            
            infoStack.leadingAnchor.constraint(equalTo: leftStack.leadingAnchor),
            infoStack.bottomAnchor.constraint(equalTo: trapezoidView.bottomAnchor, constant: -20),
            infoStack.trailingAnchor.constraint(lessThanOrEqualTo: trapezoidView.centerXAnchor),
        ])
    }
    
    private func setIconImageView() {
        containerView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -6),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -12),
            iconImageView.widthAnchor.constraint(equalToConstant: 120),
            iconImageView.heightAnchor.constraint(equalToConstant: 120),
        ])
        
    }
    
    private func setPollutantBadge() {
        NSLayoutConstraint.activate([
            pollutantBadge.trailingAnchor.constraint(equalTo: trapezoidView.trailingAnchor, constant: -20),
            pollutantBadge.bottomAnchor.constraint(equalTo: trapezoidView.bottomAnchor, constant: -20),
            pollutantBadge.heightAnchor.constraint(equalToConstant: 24),
            pollutantBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
    
    
    func configure(with cityData: CityAirPollution) {
        guard let item = cityData.response.item else { return }
        
        let aqi = item.main.aqi
        let category = item.aqiCategory
        
        let color = UIColor(named: category.color)?.withAlphaComponent(0.6) ?? .white.withAlphaComponent(0.6)
        trapezoidView.fillColor = color
        
        aqiLabel.text = "\(aqi)"
        statusLabel.text = category.description
        cityLabel.text = cityData.localeName ?? cityData.city
        iconImageView.image = UIImage(named: category.imageName)
        
        trapezoidView.setNeedsLayout()
        trapezoidView.layoutIfNeeded()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        aqiLabel.text = nil
        statusLabel.text = nil
        cityLabel.text = nil
        iconImageView.image = nil
        trapezoidView.fillColor = .clear
    }
}

class TrapezoidView: UIView {
    
    var fillColor: UIColor = .clear {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            shapeLayer.fillColor = fillColor.cgColor
            CATransaction.commit()
        }
    }
    
    private let shapeLayer = CAShapeLayer()
    private var lastBounds: CGRect = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = fillColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds != lastBounds {
            lastBounds = bounds
            updatePath()
        }
    }
    
    private func updatePath() {
        let width = bounds.width
        let height = bounds.height
        
        guard width > 0 && height > 0 else { return }
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0.37965 * height))
        
        path.addCurve(
            to: CGPoint(x: 0.03312 * width, y: 0.02995 * height),
            controlPoint1: CGPoint(x: 0, y: 0.18083 * height),
            controlPoint2: CGPoint(x: 0, y: 0.08142 * height)
        )
        
        path.addCurve(
            to: CGPoint(x: 0.21492 * width, y: 0.04559 * height),
            controlPoint1: CGPoint(x: 0.06623 * width, y: -0.02153 * height),
            controlPoint2: CGPoint(x: 0.1158 * width, y: 0.00085 * height)
        )
        
        path.addLine(to: CGPoint(x: 0.9003 * width, y: 0.35499 * height))
        
        path.addCurve(
            to: CGPoint(x: 0.98602 * width, y: 0.42173 * height),
            controlPoint1: CGPoint(x: 0.94813 * width, y: 0.37658 * height),
            controlPoint2: CGPoint(x: 0.97204 * width, y: 0.38738 * height)
        )
        
        path.addCurve(
            to: CGPoint(x: width, y: 0.59997 * height),
            controlPoint1: CGPoint(x: width, y: 0.45609 * height),
            controlPoint2: CGPoint(x: width, y: 0.50405 * height)
        )
        
        path.addLine(to: CGPoint(x: width, y: 0.74857 * height))
        
        path.addCurve(
            to: CGPoint(x: 0.98116 * width, y: 0.96318 * height),
            controlPoint1: CGPoint(x: width, y: 0.8671 * height),
            controlPoint2: CGPoint(x: width, y: 0.92636 * height)
        )
        
        path.addCurve(
            to: CGPoint(x: 0.87135 * width, y: height),
            controlPoint1: CGPoint(x: 0.96232 * width, y: height),
            controlPoint2: CGPoint(x: 0.93199 * width, y: height)
        )
        
        path.addLine(to: CGPoint(x: 0.12865 * width, y: height))
        
        path.addCurve(
            to: CGPoint(x: 0.01884 * width, y: 0.96318 * height),
            controlPoint1: CGPoint(x: 0.06801 * width, y: height),
            controlPoint2: CGPoint(x: 0.03768 * width, y: height)
        )
        
        path.addCurve(
            to: CGPoint(x: 0, y: 0.74857 * height),
            controlPoint1: CGPoint(x: 0, y: 0.92636 * height),
            controlPoint2: CGPoint(x: 0, y: 0.8671 * height)
        )
        
        path.addLine(to: CGPoint(x: 0, y: 0.37965 * height))
        path.close()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        shapeLayer.path = path.cgPath
        CATransaction.commit()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
