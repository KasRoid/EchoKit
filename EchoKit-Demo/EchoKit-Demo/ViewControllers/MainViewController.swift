//
//  MainViewController.swift
//  EchoKit-Demo
//
//  Created by Lukas on 4/19/24.
//

import EchoKit
import UIKit

final class MainViewController: UIViewController, Echoable {
    
    @IBAction func didTapPresentButton(_ sender: UIButton) {
        print("Present")
    }
    
    @IBAction func didTapPushButton(_ sender: UIButton) {
        print("Push")
    }
}
