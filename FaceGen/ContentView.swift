//
//  ContentView.swift
//  FaceGen


import SwiftUI
import Glorifier


struct ContentView: View {
    @StateObject var manager = FaceGenerator()
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            ZStack {
                Circle()
                    .foregroundColor(.accentColor)
                    .frame(width: 80)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .blur(radius: 70)
                
                Circle()
                    .foregroundColor(.cyan)
                    .frame(width: 50)
                    .blur(radius: 60)
                
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 80)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .blur(radius: 75)
                
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mobile StyleGAN")
                        .font(.title.weight(.heavy))
                        .foregroundStyle(LinearGradient(colors: [.blue, .accentColor], startPoint: .leading, endPoint: .trailing))
                    Text("A Lightweight Convolutional Neural Network for High-Fidelity Image Synthesis")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            .padding(.bottom, 60)
            
            
            Group {
                if let outputImage = manager.generatedImage {
                    Image(uiImage: outputImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .cornerRadius(15)
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.gray.opacity(0.6), style: .init(lineWidth: 2, lineCap: .round, dash: [8, 8]))
                        // Im doing this because this won't work ".fill(.gray.opacity(0.1), style: .init())"
                        .background(Color.accentColor.opacity(0.25), in: .rect(cornerRadius: 15))
                        .frame(width: 300, height: 300)
                        .glorified()
                }
            }
            .overlay {
                if manager.isGenerating {
                    ProgressView().padding(20).background(.regularMaterial, in: .rect(cornerRadius: 8))
                }
            }
            
            VStack(spacing: 10) {
                Button(action: manager.runMobileStyleGAN) {
                    Label("Generate", systemImage: "sparkles")
                        .padding(8)
                        .bold()
                        .foregroundStyle(.reversed)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .tint(.primary)
                .padding(.horizontal, 58)
                .buttonStyle(.borderedProminent)
                
                if manager.generatedImage != nil {
                    Button(action: manager.saveOutputImage) {
                        Text("Save Image")
                            .padding(8)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.horizontal, 58)
                    .buttonStyle(.bordered)
                }
            }
            .disabled(manager.isGenerating)
            .padding(.top, 65)
            
            Spacer()
        }
        .overlay {
            if manager.showSavedPopup {
                Text("Image saved")
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 30).padding(.vertical, 18)
                    .background(.regularMaterial, in: .rect(cornerRadius: 10))
            }
        }
    }
}
