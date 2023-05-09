import KeyboardShortcuts
import AppKit

//extension KeyboardShortcuts.Key {
//    var name: String {
//        switch self {
//        // Letters
//        case .a: return "A"
//        case .b: return "B"
//        case .c: return "C"
//        case .d: return "D"
//        case .e: return "E"
//        case .f: return "F"
//        case .g: return "G"
//        case .h: return "H"
//        case .i: return "I"
//        case .j: return "J"
//        case .k: return "K"
//        case .l: return "L"
//        case .m: return "M"
//        case .n: return "N"
//        case .o: return "O"
//        case .p: return "P"
//        case .q: return "Q"
//        case .r: return "R"
//        case .s: return "S"
//        case .t: return "T"
//        case .u: return "U"
//        case .v: return "V"
//        case .w: return "W"
//        case .x: return "X"
//        case .y: return "Y"
//        case .z: return "Z"
//
//        // Numbers
//        case .zero: return "0"
//        case .one: return "1"
//        case .two: return "2"
//        case .three: return "3"
//        case .four: return "4"
//        case .five: return "5"
//        case .six: return "6"
//        case .seven: return "7"
//        case .eight: return "8"
//        case .nine: return "9"
//
//        // Symbols
//        case .period: return "Period"
//        case .quote: return "Quote"
//        case .rightBracket: return "RightBracket"
//        case .semicolon: return "Semicolon"
//        case .slash: return "Slash"
//        case .backslash: return "Backslash"
//        case .comma: return "Comma"
//        case .equal: return "Equal"
//        case .leftBracket: return "LeftBracket"
//        case .minus: return "Minus"
//
//        // Whitespace
//        case .space: return "Space"
//        case .tab: return "Tab"
//        case .return: return "Return"
//
//        // Modifiers
////        case .command: return "Command"
////        case .rightCommand: return "RightCommand"
////        case .option: return "Option"
////        case .rightOption: return "RightOption"
////        case .control: return "Control"
////        case .rightControl: return "RightControl"
////        case .shift: return "Shift"
////        case .rightShift: return "RightShift"
////        case .function: return "Function"
////        case .capsLock: return "CapsLock"
//
//        // Navigation
//        case .pageUp: return "PageUp"
//        case .pageDown: return "PageDown"
//        case .home: return "Home"
//        case .end: return "End"
//        case .upArrow: return "UpArrow"
//        case .rightArrow: return "RightArrow"
//        case .downArrow: return "DownArrow"
//        case .leftArrow: return "LeftArrow"
//
//        // Functions
//        case .f1: return "F1"
//        case .f2: return "F2"
//        case .f3: return "F3"
//        case .f4: return "F4"
//        case .f5: return "F5"
//        case .f6: return "F6"
//        case .f7: return "F7"
//        case .f8: return "F8"
//        case .f9: return "F9"
//        case .f10: return "F10"
//        case .f11: return "F11"
//        case .f12: return "F12"
//        case .f13: return "F13"
//        case .f14: return "F14"
//        case .f15: return "F15"
//        case .f16: return "F16"
//        case .f17: return "F17"
//        case .f18: return "F18"
//        case .f19: return "F19"
//        case .f20: return "F20"
//
//        // Keypad
//        case .keypad0: return "Keypad0"
//        case .keypad1: return "Keypad1"
//        case .keypad2: return "Keypad2"
//        case .keypad3: return "Keypad3"
//        case .keypad4: return "Keypad4"
//        case .keypad5: return "Keypad5"
//        case .keypad6: return "Keypad6"
//        case .keypad7: return "Keypad7"
//        case .keypad8: return "Keypad8"
//        case .keypad9: return "Keypad9"
//        case .keypadClear: return "KeypadClear"
//        case .keypadDecimal: return "KeypadDecimal"
//        case .keypadDivide: return "KeypadDivide"
//        case .keypadEnter: return "KeypadEnter"
//        case .keypadEquals: return "KeypadEquals"
//        case .keypadMinus: return "KeypadMinus"
//        case .keypadMultiply: return "KeypadMultiply"
//        case .keypadPlus: return "KeypadPlus"
//
//        // Misc
//        case .escape: return "Escape"
//        case .delete: return "Delete"
//        case .help: return "Help"
//        case .volumeUp: return "VolumeUp"
//        case .volumeDown: return "VolumeDown"
//        case .mute: return "Mute"
//        default: return ""
//        }
//    }
//}

class Keyboard {
    public static var keyNames: [String] { //["abc", "abcb"]
        [
            // Symbols
            "period", "quote", "rightBracket", "semicolon", "slash", "backslash", "comma", "equal", "leftBracket", "minus",
            
            // Whitespace
            "space", "tab", "return",
            
            // Navigation
            "pageUp", "pageDown", "home", "end", "upArrow", "rightArrow", "downArrow", "leftArrow",
            
            // Misc
            "escape", "delete", "help", "volumeUp", "volumeDown", "mute",
            
            // Functions
            "f1", "f2", "f3", "f4", "f5", "f6", "f7", "f8", "f9", "f10", "f11", "f12", "f13", "f14", "f15", "f16", "f17", "f18", "f19", "f20",
            
            // Keypad
            "keypad0", "keypad1", "keypad2", "keypad3", "keypad4", "keypad5", "keypad6", "keypad7", "keypad8", "keypad9", "keypadClear", "keypadDecimal", "keypadDivide", "keypadEnter", "keypadEquals", "keypadMinus", "keypadMultiply", "keypadPlus",
            
            // Letters
            "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
            
            // Numbers
            "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
        ]
    }
    
    public static var modKeyNames: [String] {
        [
            "None", "command", "option", "control", "shift", "function", "capsLock"
        ]
    }
    
    public static func stringToModifier(_ string: String) -> NSEvent.ModifierFlags? {
        switch string.lowercased() {
        case "control":
            return .control
        case "shift":
            return .shift
        case "command":
            return .command
        case "option":
            return .option
        case "capslock":
            return .capsLock
        case "function":
            return .function
        default:
            return nil
        }
    }
//        [
//            // Letters
//            .a, .b, .c, .d, .e, .f, .g, .h, .i, .j, .k, .l, .m, .n, .o, .p, .q, .r, .s, .t, .u, .v, .w, .x, .y, .z,
//
//            // Numbers
//            .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine,
//
//            // Symbols
//            .period, .quote, .rightBracket, .semicolon, .slash, .backslash, .comma, .equal, .leftBracket, .minus,
//
//            // Whitespace
//            .space, .tab, .return,
//
//            // Modifiers
////            .command, .rightCommand, .option, .rightOption, .control, .rightControl, .shift, .rightShift, .function, .capsLock,
//
//            // Navigation
//            .pageUp, .pageDown, .home, .end, .upArrow, .rightArrow, .downArrow, .leftArrow,
//
//            // Functions
//            .f1, .f2, .f3, .f4, .f5, .f6, .f7, .f8, .f9, .f10, .f11, .f12, .f13, .f14, .f15, .f16, .f17, .f18, .f19, .f20,
//
//            // Keypad
//            .keypad0, .keypad1, .keypad2, .keypad3, .keypad4, .keypad5, .keypad6, .keypad7, .keypad8, .keypad9, .keypadClear, .keypadDecimal, .keypadDivide, .keypadEnter, .keypadEquals, .keypadMinus, .keypadMultiply, .keypadPlus,
//
//            // Misc
//            .escape, .delete, .help, .volumeUp, .volumeDown, .mute
//        ]
//    }
}
