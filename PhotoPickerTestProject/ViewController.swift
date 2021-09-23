//  ViewController.swift
//  PhotoPickerTestProject
//
//  Created by: Azure May Burmeister on 9/23/21
//  
//
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import PhotosUI

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIScrollView.appearance().backgroundColor = .systemGray5
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        browsePhotoLibrary()
    }
}

//MARK: - ImagePicker Delegate Methods

extension ViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func browsePhotoLibrary() {
        if #available(iOS 14, *) {
            var config = PHPickerConfiguration()
            config.filter = PHPickerFilter.images
            config.selectionLimit = 1
            config.preferredAssetRepresentationMode = .compatible
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            let nav = UINavigationController(rootViewController: picker)
            nav.setNavigationBarHidden(true, animated: false)
            nav.setToolbarHidden(true, animated: true)
            present(nav, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let edited = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            select(image: edited)
        } else if let selected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            select(image: selected)
        }
        presentedViewController?.dismiss(animated: true)
    }
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let provider = results.last?.itemProvider,
           provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [weak self] result, error in
                if let image = result as? UIImage {
                    DispatchQueue.main.async { self?.select(image: image) }
                } else if let error = error {
                    NSLog("Error picking image: %@", error.localizedDescription)
                    DispatchQueue.main.async { picker.dismiss(animated: true) }
                }
            }
        } else { DispatchQueue.main.async { picker.dismiss(animated: true) } }
    }
    
    func select(image: UIImage) {
        imageView.image = image
    }
}




