//
//  Keypad.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2021/10/22.
//

import SwiftUI

struct KeypadButton<Label>: View where Label: View {
    let label: Label
    let size: CGFloat
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            label
                .frame(width: size, height: size)
                .overlay(
                    RoundedRectangle(cornerRadius: size * 0.5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .font(.system(size: size * 0.3))
                .foregroundColor(.gray)


        }.buttonStyle(.plain)
    }
}

struct KeypadView: View {
    @Binding var text: String
    let buttonSize: CGFloat
    let onSubmit: () -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()
                KeypadButton(label: Text("1"), size: buttonSize) {
                    text += "1"
                }
                KeypadButton(label: Text("2"), size: buttonSize) {
                    text += "2"
                }
                KeypadButton(label: Text("3"), size: buttonSize) {
                    text += "3"
                }
                Spacer()
            }
            HStack {
                Spacer()
                KeypadButton(label: Text("4"), size: buttonSize) {
                    text += "4"
                }
                KeypadButton(label: Text("5"), size: buttonSize) {
                    text += "5"
                }
                KeypadButton(label: Text("6"), size: buttonSize) {
                    text += "6"
                }
                Spacer()
            }
            HStack {
                Spacer()
                KeypadButton(label: Text("7"), size: buttonSize) {
                    text += "7"
                }
                KeypadButton(label: Text("8"), size: buttonSize) {
                    text += "8"
                }
                KeypadButton(label: Text("9"), size: buttonSize) {
                    text += "9"
                }
                Spacer()
            }
            HStack {
                Spacer()
                KeypadButton(label: Image(systemName: "delete.left"), size: buttonSize) {
                    if (!text.isEmpty) {
                        text.removeLast()
                    }
                }
                KeypadButton(label: Text("0"), size: buttonSize) {
                    text += "0"
                }
                KeypadButton(label: Image(systemName: "checkmark"), size: buttonSize) {
                    onSubmit()
                }
                Spacer()
            }
        }
    }
}

struct KeypadView_Previews: PreviewProvider {
    static var previews: some View {
        KeypadView(text: .constant(""), buttonSize: 32, onSubmit: {})
    }
}
