//
//  MagicCropViewController.swift
//  Photo Editor
//
//  Created by Hakan Karakaya on 20.07.2020.
//  Copyright © 2020 Mohamed Hamed. All rights reserved.
//

import UIKit

public protocol MagicCropViewControllerDelegate: class {
    func magicCropViewController(_ controller: MagicCropViewController, didFinishCroppingImage image: UIImage)
    func magicCropViewControllerDidCancel(_ controller: MagicCropViewController)
}

open class MagicCropViewController: UIViewController {
    open weak var delegate: MagicCropViewControllerDelegate?
    open var image: UIImage? {
        didSet {
            cropView?.image = image
        }
    }

    fileprivate var cropView: ImageCropperView?
    open var toolbarHidden = false

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    open override func loadView() {
        let contentView = UIView()
        contentView.autoresizingMask = .flexibleWidth
        contentView.backgroundColor = UIColor.black
        view = contentView
        
        // Add CropView
        cropView = ImageCropperView(frame: contentView.bounds)
        contentView.addSubview(cropView!)
        
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
        navigationController?.toolbar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CropViewController.cancel(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(CropViewController.done(_:)))
        
        if self.toolbarItems == nil {
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let constrainButton = UIBarButtonItem(title: "Constrain", style: .plain, target: self, action: #selector(CropViewController.constrain(_:)))
            toolbarItems = [flexibleSpace, constrainButton, flexibleSpace]
        }
        
        navigationController?.isToolbarHidden = toolbarHidden
        
        cropView?.image = image
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    open func resetCropRect() {
        cropView?.resetCrop()
    }
    
    
    @objc func cancel(_ sender: UIBarButtonItem) {
        delegate?.magicCropViewControllerDidCancel(self)
    }
    
    @objc func done(_ sender: UIBarButtonItem) {
        if let image = cropView?.croppedImage {
            delegate?.magicCropViewController(self, didFinishCroppingImage: image)
        }
    }
}

