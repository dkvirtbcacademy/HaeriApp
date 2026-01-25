//
//  CategoryGameView.swift
//  Haeri
//
//  Created by kv on 24.01.26.
//

import UIKit
import SpriteKit

class CategoryGameView: UIView {
    
    private var userCategories: [UserCategoryModel]
    private var preselectedSlugs: [String]
    
    private let skView: SKView = {
        let view = SKView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.allowsTransparency = true
        return view
    }()
    
    private var gameScene: CategoryGameScene?
    
    init(userCategories: [UserCategoryModel], preselectedSlugs: [String] = []) {
        self.userCategories = userCategories
        self.preselectedSlugs = preselectedSlugs
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(skView)
        
        NSLayoutConstraint.activate([
            skView.topAnchor.constraint(equalTo: topAnchor),
            skView.leadingAnchor.constraint(equalTo: leadingAnchor),
            skView.trailingAnchor.constraint(equalTo: trailingAnchor),
            skView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if gameScene == nil && skView.bounds.width > 0 && skView.bounds.height > 0 {
            let scene = CategoryGameScene(categories: userCategories, preselectedSlugs: preselectedSlugs)
            scene.size = skView.bounds.size
            scene.scaleMode = .aspectFill
            skView.presentScene(scene)
            gameScene = scene
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.gameScene?.startAnimation()
            }
        }
    }
    
    func getSelectedCategorySlugs() -> [String] {
        return gameScene?.getSelectedCategorySlugs() ?? []
    }
}

class CategoryGameScene: SKScene {
    private var categories: [UserCategoryModel]
    private var selectedSlugs: Set<String>
    private var currentCategoryIndex = 0
    private var isAnimating = false
    
    init(categories: [UserCategoryModel], preselectedSlugs: [String] = []) {
        self.categories = categories
        self.selectedSlugs = Set(preselectedSlugs)
        super.init(size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        physicsWorld.gravity = CGVector(dx: 0, dy: -3.0)
        isUserInteractionEnabled = true
        
        let backgroundNode = SKShapeNode(rect: frame, cornerRadius: 16)
        backgroundNode.fillColor = UIColor.text.withAlphaComponent(0.8)
        backgroundNode.strokeColor = .clear
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        let insetRect = frame.insetBy(dx: 2, dy: 2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: insetRect)
    }
    
    func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        dropNextCategory()
    }
    
    private func calculateDimensions(for text: String) -> (width: CGFloat, height: CGFloat) {
        let label = UILabel()
        label.text = text
        label.font = .firagoMedium(.medium)
        label.numberOfLines = 0
        
        let maxWidth: CGFloat = 200
        let size = label.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        let isMultiLine = size.height > 25
        let height: CGFloat = isMultiLine ? 60 : 40
        
        let width: CGFloat
        if isMultiLine {
            width = 200
        } else {
            let textWidth = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)).width
            width = min(textWidth + 60, 200)
        }
        
        return (width, height)
    }
    
    private func dropNextCategory() {
        guard currentCategoryIndex < categories.count else { return }
        
        let category = categories[currentCategoryIndex]
        let dimensions = calculateDimensions(for: category.label)
        
        let isPreselected = selectedSlugs.contains(category.slug)
        
        let categoryViewInactive = CategoryView(
            iconName: category.iconName,
            text: category.label,
            isActive: false
        )
        categoryViewInactive.frame = CGRect(x: 0, y: 0, width: dimensions.width, height: dimensions.height)
        categoryViewInactive.layoutIfNeeded()
        
        let categoryViewActive = CategoryView(
            iconName: category.iconName,
            text: category.label,
            isActive: true
        )
        categoryViewActive.frame = CGRect(x: 0, y: 0, width: dimensions.width, height: dimensions.height)
        categoryViewActive.layoutIfNeeded()
        
        guard let imageInactive = categoryViewInactive.toImage(),
              let imageActive = categoryViewActive.toImage() else {
            currentCategoryIndex += 1
            dropNextCategory()
            return
        }
        
        let textureInactive = SKTexture(image: imageInactive)
        let textureActive = SKTexture(image: imageActive)
        
        let sprite = SKSpriteNode(texture: isPreselected ? textureActive : textureInactive)
        sprite.name = "categorySprite"
        
        sprite.userData = [
            "textureInactive": textureInactive,
            "textureActive": textureActive,
            "isActive": isPreselected,
            "slug": category.slug
        ]
        
        let padding: CGFloat = dimensions.width / 2
        let minX = padding
        let maxX = frame.width - padding
        let randomX = CGFloat.random(in: minX...maxX)
        let position = CGPoint(x: randomX, y: frame.height - 10)
        sprite.position = position
        
        sprite.physicsBody = SKPhysicsBody(rectangleOf: imageInactive.size)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.restitution = 0.0
        sprite.physicsBody?.linearDamping = 0.0
        sprite.physicsBody?.mass = 2.0
        sprite.physicsBody?.allowsRotation = true
        sprite.physicsBody?.angularDamping = 0.1
        sprite.physicsBody?.angularVelocity = CGFloat.random(in: -3...3)
        
        addChild(sprite)
        
        currentCategoryIndex += 1
        
        if currentCategoryIndex < categories.count {
            run(SKAction.wait(forDuration: 0.35)) { [weak self] in
                self?.dropNextCategory()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        for node in touchedNodes {
            if let sprite = node as? SKSpriteNode,
               sprite.name == "categorySprite",
               let userData = sprite.userData,
               let slug = userData["slug"] as? String,
               let textureInactive = userData["textureInactive"] as? SKTexture,
               let textureActive = userData["textureActive"] as? SKTexture {
                
                let isActive = userData["isActive"] as! Bool
                let newState = !isActive
                
                sprite.texture = newState ? textureActive : textureInactive
                
                if newState {
                    selectedSlugs.insert(slug)
                } else {
                    selectedSlugs.remove(slug)
                }
                
                sprite.userData?["isActive"] = newState
                break
            }
        }
    }
    
    func getSelectedCategorySlugs() -> [String] {
        return Array(selectedSlugs)
    }
}
