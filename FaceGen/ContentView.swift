//
//  ContentView.swift
//  FaceGen


import SwiftUI
import Glorifier


struct ContentView: View {
    @StateObject var manager = FaceGenerator()
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Mobile StyleGAN")
                    .font(.title.weight(.heavy))
                    .foregroundStyle(
                        scheme == .light ? lightModeGradient : darkModeGradient
                    )
                    
                Text(
                    "A Lightweight Convolutional Neural Network for High-Fidelity Image Synthesis"
                )
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.leading)
            }
            .padding()
            .padding(.bottom, 60)
            
            
            Group {
                if let outputImage = manager.generatedImage {
                    Image(uiImage: outputImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                        .cornerRadius(25)
                        .transition(.move(edge: .top))
                } else {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(.gray.opacity(0.6), style: .init(lineWidth: 2, lineCap: .round, dash: [8, 8]))
                        // Im doing this because this won't work ".fill(.gray.opacity(0.1), style: .init())"
                        .background(Color.accentColor.opacity(0.25), in: .rect(cornerRadius: 25))
                        .frame(width: 300, height: 300)
                        .overlay {
                            Image(systemName: "person.fill.viewfinder")
                                .font(.largeTitle)
                                .bold()
                                .symbolRenderingMode(.hierarchical)
                                .glorified()
                        }
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
                    Text("Generate")
                        .padding(.vertical, 6)
                        .font(.headline)
                        .foregroundStyle(.background)
                        .frame(maxWidth: .infinity, alignment: .center)
            
                }
                .tint(.primary)
                .padding(.horizontal, 52)
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                
                if manager.generatedImage != nil {
                    Button(action: manager.saveOutputImage) {
                        Text("Save Image")
                            .padding(.vertical, 12)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color(.tertiarySystemFill), in: .capsule)
                    }
                    .padding(.horizontal, 52)
                }
            }
            .disabled(manager.isGenerating)
            .padding(.top, 65)
            
            Spacer()
        }
        .overlay {
            if manager.showSavedPopup {
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green.gradient)
                    Text("Image saved")
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(.regularMaterial, in: .rect(cornerRadius: 10))
            }
        }
    }
    
    var darkModeGradient: LinearGradient {
        LinearGradient(
            colors: [Color(#colorLiteral(red: 0.439263463, green: 0.4226318598, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.8774669766, green: 0.8117906451, blue: 0.9855117202, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7145617604, blue: 0.532741189, alpha: 1))],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    var lightModeGradient: LinearGradient {
        LinearGradient(
            colors: [Color(#colorLiteral(red: 1, green: 0.4133105576, blue: 0.8369686007, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7145617604, blue: 0.532741189, alpha: 1))],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
