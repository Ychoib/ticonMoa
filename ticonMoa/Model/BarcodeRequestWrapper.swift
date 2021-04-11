//
//  BarcodeWrapper.swift
//  ticonMoa
//
//  Created by 채훈기 on 2021/03/25.
//

import UIKit
import Vision

class BarcodeRequestWrapper {
    
    let image: UIImage
    lazy var detectBarcodeRequest: VNDetectBarcodesRequest = {
        return VNDetectBarcodesRequest(completionHandler: { [weak self] (request, error) in
            guard error == nil else {
                print("error")
                return
            }
            self?.processClassification(for: request)
        })
    }()
    let completion: ((UIImage) -> Void)
    
    init(image: UIImage, completion: @escaping ((UIImage) -> Void)) {
        self.image = image
        self.completion = completion
    }
    
    func processClassification(for request: VNRequest) {
        guard let bestResult = request.results?.first as? VNBarcodeObservation,
              let payload = bestResult.payloadStringValue
        else {
            return
        }
        print(payload)
        completion(image)
    }
    
    func requestDetection() {
        guard let ciImage = CIImage(image: image) else { return }
        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation.up, options: [:])

        do {
            try handler.perform([self.detectBarcodeRequest])
        } catch {
            print("Error Decoding Barcode")
        }
    }
}
