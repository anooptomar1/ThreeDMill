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
    let addRedButton: UIButton
    let remainingSpheresLabel: UILabel
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
        cameraNode.position = SCNVector3(0, 20, 30)
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
        spotLightNode.position = SCNVector3(0, 25, 25)
        spotLightNode.constraints = [constraint]
        
        let boardWidth: Float = 20
        let poleSpacing = boardWidth/3.0
        let poleGeometry = SCNCylinder(radius: 1, height: 10)
        let poleMaterial = SCNMaterial()
        poleMaterial.diffuse.contents = UIColor.yellow
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
        
        addRedButton = UIButton(type: .system)
        addRedButton.tag = 1
        addRedButton.setTitle("＋", for: .normal)
        addRedButton.setTitleColor(UIColor.white, for: .normal)
        let buttonFont = UIFont.systemFont(ofSize: 40)
        addRedButton.titleLabel?.font = buttonFont
        addRedButton.layer.borderWidth = 1
        addRedButton.layer.borderColor = UIColor.white.cgColor
        addRedButton.layer.cornerRadius = 10
        addRedButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        addRedButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        remainingSpheresLabel = UILabel()
        remainingSpheresLabel.text = "32"
        remainingSpheresLabel.textColor = UIColor.white
        remainingSpheresLabel.textAlignment = .center
        
        let buttonStackView = UIStackView(arrangedSubviews: [addRedButton, remainingSpheresLabel])
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .fill
        buttonStackView.spacing = 5
        
        super.init(frame: frame, options: options)
        
        scene = SCNScene()
        
        scene?.rootNode.addChildNode(groundNode)
        scene?.rootNode.addChildNode(cameraOrbit)
        scene?.rootNode.addChildNode(spotLightNode)

        for j in 0..<4 {
            for i in 0..<4 {
                scene?.rootNode.addChildNode(poleNodes[j][i])
            }
        }
        
        addSubview(buttonStackView)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            buttonStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
            ])
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        addGestureRecognizer(panRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: nil, action: .tap)
        addGestureRecognizer(tapRecognizer)
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
    func add(sender: UIButton) {
        let sphereColor = (sender.tag == 0 ? SphereColor.black : SphereColor.white)
        
        let material = SCNMaterial()
        material.diffuse.contents = sphereColor.uiColor
        let geometry = SCNSphere(radius: 2)
        geometry.materials = [material]
        
        let sphere = GameSphereNode(geometry: geometry, color: sphereColor)
        sphere.position = SCNVector3(x: 0, y: 18, z: 0)
        
        gameSphereNodes.append(sphere)
        scene?.rootNode.addChildNode(sphere)
    }
}

@objc protocol GestureActions {
    @objc func tap(sender: UITapGestureRecognizer)
}

extension Selector {
    static let tap = #selector(GestureActions.tap(sender:))
}

