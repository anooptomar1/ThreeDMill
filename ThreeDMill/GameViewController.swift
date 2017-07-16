//  Created by dasdom on 08.07.17.
//  Copyright © 2017 dasdom. All rights reserved.
//

import UIKit
//import QuartzCore
//import SceneKit

class GameViewController: UIViewController {
    
    let board = Board()
    
    var contentView: GameView { return view as! GameView }
    
    override func loadView() {
        view = GameView(frame: .zero, options: nil)
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
