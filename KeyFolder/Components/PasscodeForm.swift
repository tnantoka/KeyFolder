//
//  PasscodeForm.swift
//  KeyFolder
//
//  Created by Tatsuya Tobioka on 2023/08/16.
//

import SwiftUI

struct PasscodeForm: View {
  let maxButtonSize = 100.0
  let spacing = 24.0
  let buttonPadding = 8.0

  @Binding var passcode: String

  @State var isMasked = true

  let onConfirm: () -> Void

  var body: some View {
    VStack {
      ZStack(alignment: .trailing) {
        passcodeField
          .disabled(true)
          .multilineTextAlignment(.center)
          .font(.largeTitle)
        Button(
          action: {
            isMasked.toggle()
          },
          label: {
            Image(systemName: isMasked ? "eye" : "eye.slash")
          }
        )
        .foregroundColor(.primary)
      }
      .padding(.bottom, spacing)
      .frame(maxWidth: maxButtonSize * 3 + spacing * 2 + buttonPadding * 6)
      HStack(spacing: spacing) {
        numberButtons(range: 1..<4)
      }
      HStack(spacing: spacing) {
        numberButtons(range: 4..<7)
      }
      HStack(spacing: spacing) {
        numberButtons(range: 7..<10)
      }
      HStack(spacing: spacing) {
        iconButton(
          imageName: "delete.left",
          action: {
            passcode.removeLast()
          },
          color: .primary
        )
        numberButtons(range: 0..<1)
        iconButton(
          imageName: "checkmark",
          action: onConfirm,
          color: .accentColor
        )
      }
    }
    .padding(.horizontal, spacing)
  }

  private func numberButtons(range: Range<Int>) -> some View {
    return ForEach(range, id: \.self) { i in
      let text = String(i)
      CodeButton(
        action: {
          passcode += text
        },
        label: Text(text),
        maxSize: maxButtonSize,
        disabled: false,
        buttonStyle: .bordered,
        color: .primary
      )
    }
  }

  private func iconButton(imageName: String, action: @escaping () -> Void, color: Color)
    -> some View
  {
    return CodeButton(
      action: action,
      label: Image(systemName: imageName),
      maxSize: maxButtonSize,
      disabled: passcode.isEmpty,
      buttonStyle: .plain,
      color: color
    )
  }

  @ViewBuilder
  private var passcodeField: some View {
    if isMasked {
      SecureField("Passcode", text: $passcode)
    } else {
      TextField("Passcode", text: $passcode)
    }
  }

  struct CodeButton<Label, ButtonStyle>: View where Label: View, ButtonStyle: PrimitiveButtonStyle {
    let action: () -> Void
    let label: Label
    let maxSize: CGFloat
    let disabled: Bool
    let buttonStyle: ButtonStyle
    let color: Color

    var body: some View {
      Button(
        action: action,
        label: {
          label
            .frame(maxWidth: maxSize, maxHeight: maxSize)
            .font(.title)
        }
      )
      .buttonStyle(buttonStyle)
      .foregroundColor(color)
      .clipShape(Circle())
      .disabled(disabled)
    }
  }
}

struct PasscodeForm_Previews: PreviewProvider {
  private struct Preview: View {
    @State private var passcode: String = ""

    var body: some View {
      PasscodeForm(passcode: $passcode, onConfirm: {})
    }
  }

  static var previews: some View {
    Preview()
  }
}
