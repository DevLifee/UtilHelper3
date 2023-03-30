import SwiftUI

@available(iOS 14.0, *)
public struct UtilThree: View {
    public init(listData: [String: String], pushTo: @escaping () -> (), checkEmptyPw: String) {
        self.listData = listData
        self.pushTo = pushTo
        self.checkEmptyPw = checkEmptyPw
    }
    var listData: [String: String] = [:]
    var checkEmptyPw: String
    @State var next_screen_three = false
    @State var load_hide_three = false
    @State var get_pw_three: String = ""
    var pushTo: () -> ()
    
    public var body: some View {
        if checkEmptyPw.isEmpty {
            ZStack {
                if next_screen_three {
                    Color.clear.onAppear {
                        self.pushTo()
                    }
                    
                } else {
                    if load_hide_three {
                        ProgressView("")
                    }
                    ZStack {
                        ThreeCoor(url: URL(string: listData[RemoKey.rmlink11.rawValue] ?? ""), next_screen_three: $next_screen_three, load_hide_three: $load_hide_three, get_pw_three: $get_pw_three, listData: self.listData).opacity(load_hide_three ? 0 : 1)
                    }.zIndex(2.0)
                }
            }.foregroundColor(Color.black)
                .background(Color.white)
        } else {
            Color.clear.onAppear {
                self.pushTo()
            }
        }
    }
}

