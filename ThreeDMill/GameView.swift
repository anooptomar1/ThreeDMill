//  Created by dasdom on 10.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
import SceneKit

final class GameView: SCNView {

    let cameraNode = SCNNode()
    let cameraOrbit = SCNNode()
    let spotLightNode = SCNNode()
    var poleNodes: [[SCNNode]] = []
    var startAngleY: Float = 0.0
    let remainingWhiteSpheresLabel: UILabel
    let whiteButtonStackView: UIStackView
    let remainingBlackSpheresLabel: UILabel
    let blackButtonStackView: UIStackView
    var gameSphereNodes: [GameSphereNode] = []

    override init(frame: CGRect, options: [String : Any]? = nil) {
        
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.brown
        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0
        groundGeometry.materials = [groundMaterial]
        let groundNode = SCNNode(geometry: groundGeometry)
        
        let constraint = SCNLookAtConstraint(target: groundNode)
        constraint.isGimbalLockEnabled = true

        let camera = SCNCamera()
        camera.zFar = 10_000
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 35, 40)
        cameraNode.constraints = [constraint]
        
        cameraOrbit.addChildNode(cameraNode)

        let ambientLight = SCNLight()
        ambientLight.color = UIColor.darkGray
        ambientLight.type = SCNLight.LightType.ambient
        cameraNode.light = ambientLight
        
        let spotLight = SCNLight()
        spotLight.type = SCNLight.LightType.spot
        spotLight.castsShadow = true
        spotLight.spotInnerAngle = 70.0
        spotLight.spotOuterAngle = 90.0
        spotLight.zFar = 500
        spotLightNode.light = spotLight
        spotLightNode.position = SCNVector3(20, 50, 50)
        spotLightNode.constraints = [constraint]
        
        let boardWidth: Float = 20
        let poleSpacing = boardWidth/3.0
        let poleGeometry = SCNCylinder(radius: 1, height: 20)
        let poleMaterial = SCNMaterial()
        poleMaterial.diffuse.contents = UIColor.lightGray
        poleGeometry.materials = [poleMaterial]
        for j in 0..<Board.numberOfColumns {
            var columnNodes: [SCNNode] = []
            for i in 0..<Board.numberOfColumns {
                let poleNode = SCNNode(geometry: poleGeometry)
                poleNode.position = SCNVector3(x: poleSpacing*Float(i) - boardWidth/2.0, y: 5, z: poleSpacing*Float(j) - boardWidth/2.0)
                
                columnNodes.append(poleNode)
            }
            poleNodes.append(columnNodes)
        }
        
        func addButton() -> UIButton {
            let button = UIButton(type: .system)
            button.setTitle("＋", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            let buttonFont = UIFont.systemFont(ofSize: 40)
            button.titleLabel?.font = buttonFont
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.cornerRadius = 10
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            return button
        }
        
        let addWhiteButton = addButton()
        addWhiteButton.tag = 1
        
        remainingWhiteSpheresLabel = UILabel()
        remainingWhiteSpheresLabel.text = "32"
        remainingWhiteSpheresLabel.textColor = UIColor.white
        remainingWhiteSpheresLabel.textAlignment = .center
        
        whiteButtonStackView = UIStackView(arrangedSubviews: [addWhiteButton, remainingWhiteSpheresLabel])
        whiteButtonStackView.axis = .vertical
        whiteButtonStackView.alignment = .fill
        whiteButtonStackView.spacing = 5
        
        let addBlackButton = addButton()
        addBlackButton.tag = 0

        remainingBlackSpheresLabel = UILabel()
        remainingBlackSpheresLabel.text = "32"
        remainingBlackSpheresLabel.textColor = UIColor.white
        remainingBlackSpheresLabel.textAlignment = .center
        
        blackButtonStackView = UIStackView(arrangedSubviews: [addBlackButton, remainingBlackSpheresLabel])
        blackButtonStackView.axis = .vertical
        blackButtonStackView.alignment = .fill
        blackButtonStackView.spacing = 5
        
        super.init(frame: frame, options: options)
        
        addBlackButton.addTarget(self, action: #selector(add(sender:)), for: .touchUpInside)
        addWhiteButton.addTarget(self, action: #selector(add(sender:)), for: .touchUpInside)

        showsStatistics = true

        scene = SCNScene()
        
        scene?.rootNode.addChildNode(groundNode)
        scene?.rootNode.addChildNode(cameraOrbit)
        scene?.rootNode.addChildNode(spotLightNode)

        for j in 0..<4 {
            for i in 0..<4 {
                scene?.rootNode.addChildNode(poleNodes[j][i])
            }
        }
        
        addSubview(blackButtonStackView)
        addSubview(whiteButtonStackView)
        
        blackButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        whiteButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blackButtonStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            blackButtonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            whiteButtonStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            whiteButtonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
            ])
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        addGestureRecognizer(panRecognizer)
        
//        let tapRecognizer = UITapGestureRecognizer(target: nil, action: .tap)
//        addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func pan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        
        switch sender.state {
        case .began:
            startAngleY = cameraOrbit.eulerAngles.y
        default:
            break
        }
        
        cameraOrbit.eulerAngles.y = startAngleY - GLKMathDegreesToRadians(Float(translation.x))
    }
}

extension GameView {
    @objc func add(sender: UIButton) {
        
        var sphereColor = SphereColor.white
        if sender.tag == 0 {
            sphereColor = .red
            blackButtonStackView.isHidden = true
            whiteButtonStackView.isHidden = false
        } else {
            blackButtonStackView.isHidden = false
            whiteButtonStackView.isHidden = true
        }
        
        let material = SCNMaterial()
        material.diffuse.contents = sphereColor.uiColor()
        let geometry = SCNSphere(radius: 2)
        geometry.materials = [material]
        
        let sphere = GameSphereNode(geometry: geometry, color: sphereColor)
        sphere.position = SCNVector3(x: 0, y: 25, z: 0)
        
        gameSphereNodes.append(sphere)
        scene?.rootNode.addChildNode(sphere)
    }
}

extension GameView {
    func pole(for node: SCNNode) -> (Int, Int)? {
        for column in 0..<4 {
            for row in 0..<4 {
                if node == poleNodes[column][row] {
                    return (column, row)
                }
            }
        }
        return nil
    }
}

//@objc protocol GestureActions {
//    @objc func tap(sender: UITapGestureRecognizer)
//}
//
//extension Selector {
//    static let tap = #selector(GestureActions.tap(sender:))
//}

