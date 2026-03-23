//
//  ContentView.swift
//  MySampleTEsts
//
//  Created by Vic on 13/10/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isExpanded = false
//    @Namespace private var namespace
    
    var body: some View {
        
        VStack (spacing: 20){
                // GlassEffectContainer requires iOS 26+
                GlassEffectContainer(spacing: 80) {
                    HStack(spacing: 20) {
                        if isExpanded {
                            Image(systemName: "circle")
                                .frame(width: 50, height: 50)
                            // FIX: Added missing 'id:' label to align with the second modifier
                            //                        .glassEffect(id: "main_shape", in: namespace)
                            
                                .glassEffect(.identity)
                                .transition(.scale)
                        }
                        
                        Image(systemName: "square")
                            .frame(width: 50, height: 50)
                        //                    .glassEffect(id: "main_shape", in: namespace)
                            .transition(.scale)
                            .cornerRadius(90)
                            .glassEffect(.identity)
                        //                    .glassEffectTransition(id: square, in: namespace)
                    }
                    .foregroundStyle(.white)
                    
                    // Added foreground style for visibility
                }
                .onAppear() {
                    withAnimation(.easeInOut) {
                        isExpanded.toggle()
                    }
                }
                .background(
                    // Added a background for the glass effect to be visible
                    LinearGradient(colors: [.purple, .cyan], startPoint: .leading
                                   , endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                )
                .cornerRadius(100)
                .onTapGesture {
                    withAnimation(.smooth) {
                        isExpanded.toggle()
                    }
                }
                
                            // GlassEffectContainer requires iOS 26+
                VStack(spacing: 80) {
                    HStack(spacing: 20) {
                        if isExpanded {
                            Image(systemName: "circle")
                                .frame(width: 50, height: 50)
                            // FIX: Added missing 'id:' label to align with the second modifier
                            //                        .glassEffect(id: "main_shape", in: namespace)
                            
                                .glassEffect(.identity)
                                .transition(.scale)
                        }
                        
                        Image(systemName: "square")
                            .frame(width: 50, height: 50)
                        //                    .glassEffect(id: "main_shape", in: namespace)
                            .transition(.scale)
                            .cornerRadius(90)
                            .glassEffect(.identity)
                        //                    .glassEffectTransition(id: square, in: namespace)
                    }
                    .foregroundStyle(.white)
                    
                    // Added foreground style for visibility
                }
                .onAppear() {
                    withAnimation(.easeInOut) {
                        isExpanded.toggle()
                    }
                }
                .background(
                    // Added a background for the glass effect to be visible
                    LinearGradient(colors: [.purple, .cyan], startPoint: .leading
                                   , endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                )
                .cornerRadius(100)
//                .onTapGesture {
//                    withAnimation(.smooth) {
//                        isExpanded.toggle()
//                    }
//                }
                
                
    
            }
        
    }
}

#Preview {
    ContentView()
}
