//
//  FaceGenerator.swift
//  FaceGen
    

import SwiftUI
import CoreML



class FaceGenerator: ObservableObject {
    @Published var generatedImage: UIImage?
    @Published var isGenerating: Bool = false
    @Published var showSavedPopup: Bool = false
    
    
    func runMobileStyleGAN() {
        isGenerating = true
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                // Mapping
                let mappingNetwork = try mappingNetwork(configuration: MLModelConfiguration())
                let input = try MLMultiArray(shape: [1,512] as [NSNumber], dataType: MLMultiArrayDataType.float32)
                
                for i in 0...input.count - 1 {
                    input[i] = NSNumber(value: Float32.random(in: -1...1))
                }
                
                let mappingInput = mappingNetworkInput(var_: input)
                let mappingOutput = try mappingNetwork.prediction(input: mappingInput)
                let style = mappingOutput.var_134
                
                
                // Synthesis
                let synthesisNetwork = try synthesisNetwork(configuration: MLModelConfiguration())
                
                let mlinput = synthesisNetworkInput(style: style)
                let outputBuffer = try synthesisNetwork.prediction(input: mlinput).activation_out
                let ciImage = CIImage(cvPixelBuffer: outputBuffer)
                guard let safeCGImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else {
                    print("Could not create cgimage.")
                    return
                }
                
                
                DispatchQueue.main.async {
                    withAnimation {
                        self.generatedImage = UIImage(cgImage: safeCGImage)
                        self.isGenerating = false
                    }
                }
            } catch {
                print("Catch error: \(error)")
                self.isGenerating = false
            }
        }
    }
    
    func saveOutputImage() {
        UIImageWriteToSavedPhotosAlbum(generatedImage!, nil, nil, nil)
        withAnimation { showSavedPopup = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { self.showSavedPopup = false }
        }
    }
}
