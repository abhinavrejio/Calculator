import SwiftUI

enum CalcButton: String {
    case one = "1", two = "2", three = "3"
    case four = "4", five = "5", six = "6"
    case seven = "7", eight = "8", nine = "9"
    case zero = "0", add = "+", subtract = "-"
    case divide = "/", multiply = "*", equal = "="
    case clear = "AC", decimal = ".", percent = "%"
    case negative = "-/+"
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

struct ContentView: View {
    
    @State private var value = "0"
    @State private var runningNumber: Double = 0
    @State private var currentOperation: CalcButton? = nil
    @State private var isTypingNumber = false
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                // Display
                HStack {
                    Spacer()
                    Text(value)
                        .bold()
                        .font(.system(size: 64))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .padding()
                }
                
                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }) {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(item: item),
                                           height: self.buttonHeight())
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item) / 2)
                            }
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
            .padding()
        }
    }
    
    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            if button == .equal {
                self.performOperation()
            } else {
                self.runningNumber = Double(self.value) ?? 0
                self.currentOperation = button
                self.isTypingNumber = false
            }
        case .clear:
            self.value = "0"
            self.runningNumber = 0
            self.currentOperation = nil
            self.isTypingNumber = false
        case .decimal:
            if !self.value.contains(".") {
                self.value += "."
                self.isTypingNumber = true
            }
        case .negative:
            if self.value != "0" {
                if self.value.hasPrefix("-") {
                    self.value.removeFirst()
                } else {
                    self.value = "-" + self.value
                }
            }
        case .percent:
            if let num = Double(self.value) {
                self.value = String(num / 100)
            }
        default:
            let number = button.rawValue
            if self.isTypingNumber {
                self.value += number
            } else {
                self.value = number
                self.isTypingNumber = true
            }
        }
    }
    
    func performOperation() {
        guard let op = self.currentOperation else { return }
        let currentValue = Double(self.value) ?? 0
        var result: Double = 0
        
        switch op {
        case .add:
            result = self.runningNumber + currentValue
        case .subtract:
            result = self.runningNumber - currentValue
        case .multiply:
            result = self.runningNumber * currentValue
        case .divide:
            if currentValue != 0 {
                result = self.runningNumber / currentValue
            } else {
                self.value = "Error"
                return
            }
        default:
            break
        }
        
        self.value = formatResult(result)
        self.isTypingNumber = false
        self.currentOperation = nil
    }
    
    func formatResult(_ num: Double) -> String {
        if num.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(num))
        } else {
            return String(num)
        }
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return (UIScreen.main.bounds.width - (5*12)) / 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
