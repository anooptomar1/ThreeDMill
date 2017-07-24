//  Created by dasdom on 08.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
//import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    let board = Board()
    
    var contentView: GameView { return view as! GameView }
    
    override func loadView() {
        let contentView = GameView(frame: .zero, options: nil)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        contentView.addGestureRecognizer(tapRecognizer)
        view = contentView
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
    
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

extension GameViewController {
    @objc func tap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: contentView)
        
        let hitResult = contentView.hitTest(location, options: nil)
        if hitResult.count > 0 {
            let result = hitResult[0]
            let node = result.node
            
            guard let (column, row) = contentView.pole(for: node) else { return }
            print("column: \(column), row: \(row)")
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
            if position.y > 10 {
                position.x = node.position.x
                position.z = node.position.z
                let moveToPole = SCNAction.move(to: position, duration: 0.3)
                position.y = 2.0 + 3.5 * Float(board.spheresAt(column: column, row: row))
                let moveDown = SCNAction.move(to: position, duration: 0.3)
                let move = SCNAction.sequence([moveToPole, moveDown])
                move.timingMode = .easeOut
                sphereNode.runAction(move)
                sphereNode.isMoving = false
                
                try? board.addSphereWith(sphereNode.color, toColumn: column, andRow: row)
                
                if let result = board.checkForMatch() {
                    let alertController = UIAlertController(title: "Mill", message: "Mill: \(result)", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
}
