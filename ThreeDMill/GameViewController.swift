//  Created by dasdom on 08.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
//import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    let board = Board()
    private var notification: NSObjectProtocol?
    private var activateAddButton = true
    private var timer: Timer?
    private var timerStartDate: Date?
    
    var contentView: GameView { return view as! GameView }
    
    override func loadView() {
        let contentView = GameView(frame: .zero, options: nil)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        contentView.addGestureRecognizer(tapRecognizer)
        view = contentView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notification = NotificationCenter.default.addObserver(forName: .numberOfRemainingSpheresChanged, object: nil, queue: OperationQueue.main) { notification in
            
            let userInfo = notification.userInfo
            guard let remainingWhiteSpheres = userInfo?[SphereColor.white] as? Int else {
                fatalError()
            }
            guard let remainingRedSpheres = userInfo?[SphereColor.red] as? Int else {
                fatalError()
            }
            
            self.activateAddButton = remainingWhiteSpheres + remainingRedSpheres > 0
            
            self.contentView.remainingWhiteSpheresLabel.text = "\(remainingWhiteSpheres)"
            self.contentView.remainingRedSpheresLabel.text = "\(remainingRedSpheres)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(notification as Any)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

extension GameViewController: ButtonActions {
    func add(sender: UIButton!) {
        done(sender: nil)

        let sphereColor: SphereColor = sender.tag == 0 ? .red : .white
        contentView.add(color: sphereColor)
    }
}

extension GameViewController {
    @objc func tap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: contentView)
        
        let hitResult = contentView.hitTest(location, options: nil)
        if hitResult.count > 0 {
            let result = hitResult[0]
            let node = result.node
            
            if let (column, row) = contentView.pole(for: node) {
                print("column: \(column), row: \(row)")
                
                switch board.mode {
                case .removeSphere:
                    removeSphereFrom(node: node, column: column, row: row)
                default:
                    addSphereTo(node: node, column: column, row: row)
                }
            }
        }
    }
    
    private func addSphereTo(node: SCNNode, column: Int, row: Int) {
        guard board.canAddSphereTo(column: column, row: row) else {
            let alertController = UIAlertController(title: "Pole full", message: "A pole cannot hold more than four spheres.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let sphereNodes = contentView.scene?.rootNode.childNodes(passingTest: { node, stop -> Bool in
            guard let gameSphereNode = node as? GameSphereNode else { return false }
            return gameSphereNode.isMoving
        })
        guard let sphereNode = sphereNodes?.first as? GameSphereNode else { return }
        
        var position = sphereNode.position
        position.x = node.position.x
        position.z = node.position.z
        let move: SCNAction
        if position.y < 20 {
            let (columnToRemove, rowToRemove) = contentView.columnAndRow(for: sphereNode)
            try? board.removeSphereFrom(column: columnToRemove, andRow: rowToRemove)
            _ = contentView.removeSphereFrom(column: columnToRemove, row: rowToRemove)
            
            var spherePosition = sphereNode.position
            spherePosition.y = 25
            let moveUp = SCNAction.move(to: spherePosition, duration: 0.3)
            position.y = 25
            let moveToPole = SCNAction.move(to: position, duration: 0.3)
            position.y = 2.0 + 3.5 * Float(board.spheresAt(column: column, row: row))
            let moveDown = SCNAction.move(to: position, duration: 0.3)
            move = SCNAction.sequence([moveUp, moveToPole, moveDown])
            
            try? board.addSphereWith(sphereNode.color, toColumn: column, andRow: row)
            contentView.add(sphereNode, toColumn: column, andRow: row)
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateButton), userInfo: nil, repeats: true)
            timerStartDate = Date()
            
            let moveToPole = SCNAction.move(to: position, duration: 0.3)
            position.y = 2.0 + 3.5 * Float(board.spheresAt(column: column, row: row))
            let moveDown = SCNAction.move(to: position, duration: 0.3)
            move = SCNAction.sequence([moveToPole, moveDown])
//            sphereNode.isMoving = false
            
            try? board.addSphereWith(sphereNode.color, toColumn: column, andRow: row)
            contentView.add(sphereNode, toColumn: column, andRow: row)
            
            if !mill(on: board, sphereNode: sphereNode) && activateAddButton {
                
                switch sphereNode.color {
                case .red:
                    contentView.whiteButtonStackView.isHidden = false
                case .white:
                    contentView.redButtonStackView.isHidden = false
                }
                
            }
        }
        move.timingMode = .easeOut
        sphereNode.runAction(move)
    }
    
    @objc func updateButton() {
        guard let interval = timerStartDate?.timeIntervalSinceNow else { return }
        let remaining = 5+Int(interval)
        if remaining < 0 {
            done(sender: nil)
        } else {
            contentView.doneButton.isHidden = false
        }
        contentView.doneButton.setTitle("\(remaining)", for: .normal)
    }
    
    func done(sender: UIButton!) {
        let sphereNodes = contentView.scene?.rootNode.childNodes(passingTest: { node, stop -> Bool in
            guard let gameSphereNode = node as? GameSphereNode else { return false }
            return gameSphereNode.isMoving
        })
        guard let sphereNode = sphereNodes?.first as? GameSphereNode else { return }
        
        contentView.doneButton.isHidden = true
        timerStartDate = nil
        timer?.invalidate()
        
        sphereNode.isMoving = false
    }
    
    private func removeSphereFrom(node: SCNNode, column: Int, row: Int) {
        
        var position = node.position
        position.y = 20
        let moveUp = SCNAction.move(to: position, duration: 0.3)
//        let fadeOut = SCNAction.fadeOut(duration: 0.1)
        let wait = SCNAction.wait(duration: 0.05)
        let fade = SCNAction.fadeOpacity(to: 0.1, duration: 0.1)
        let remove = SCNAction.removeFromParentNode()
        remove.timingMode = .easeOut
        let moveAndRemove = SCNAction.sequence([moveUp, wait, fade, remove])

        let sphereNode = contentView.removeSphereFrom(column: column, row: row)
        sphereNode.runAction(moveAndRemove)
        
        try? board.removeSphereFrom(column: column, andRow: row)
        
        switch sphereNode.color {
        case .red:
            contentView.redButtonStackView.isHidden = false
        case .white:
            contentView.whiteButtonStackView.isHidden = false
        }
        
        board.mode = .addSpheres
    }
    
    private func mill(on board: Board, sphereNode: GameSphereNode) -> Bool {
        if let result = board.checkForMatch() {
            
            let colorToRemove: String
            switch sphereNode.color {
            case .red:
                colorToRemove = "white"
            case .white:
                colorToRemove = "red"
            }
            
            let alertController = UIAlertController(title: "Mill", message: "Mill: \(result)\nYou can now remove a \(colorToRemove) sphere from the board.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
                
                self.board.mode = .removeSphere
            })
            
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            
            return true
        }
        return false
    }
}
