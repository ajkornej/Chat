//
//  Created by Alex.M on 22.06.2022.
//

import Foundation
import SwiftUI

struct AttachmentsPages: View {
    @StateObject var viewModel: AttachmentsPagesViewModel
    var onClose: () -> Void

    var body: some View {
        let closeGesture = DragGesture()
            .onChanged { viewModel.offset = closeSize(from: $0.translation) }
            .onEnded {
                withAnimation {
                    viewModel.offset = .zero
                }
                if $0.translation.height >= 100 {
                    onClose()
                }
            }

        ZStack {
            Color.black
                .opacity(max((200.0 - viewModel.offset.height) / 200.0, 0.5))
                .ignoresSafeArea()
            VStack {
                TabView(selection: $viewModel.index) {
                    ForEach(viewModel.attachments.enumerated().map({ $0 }), id: \.offset) { (index, attachment) in
                        AttachmentsPage(attachment: attachment)
                            .tag(index)
                            .frame(maxHeight: .infinity)
                            .onTapGesture {
                                withAnimation {
                                    viewModel.showMinis.toggle()
                                }
                            }
                    }
                }
                .environmentObject(viewModel)
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .offset(viewModel.offset)
            .gesture(closeGesture)

            VStack {
                Spacer()
                ScrollViewReader { proxy in
                    if viewModel.showMinis {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(viewModel.attachments.enumerated().map({ $0 }), id: \.offset) { (index, attachment) in
                                    AttachmentCell(attachment: attachment)
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .id(index)
                                        .onTapGesture {
                                            withAnimation {
                                                viewModel.index = index
                                            }
                                        }
                                }
                            }
                        }
                        .onAppear {
                            proxy.scrollTo(viewModel.index)
                        }
                        .onChange(of: viewModel.index) { newValue in
                            withAnimation {
                                proxy.scrollTo(newValue, anchor: .center)
                            }
                        }
                    }
                }
            }
            .offset(viewModel.offset)
        }
    }
}

private extension AttachmentsPages {
    func closeSize(from size: CGSize) -> CGSize {
        CGSize(width: 0, height: max(size.height, 0))
    }
}
