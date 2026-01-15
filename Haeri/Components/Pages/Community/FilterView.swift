//
//  FilterView.swift
//  Haeri
//
//  Created by kv on 14.01.26.
//

import SwiftUI

struct FilterView: View {

    @Binding var selectedFilter: FilterPost?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(FilterPost.allCases) { filter in
                    FilterPill(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter
                    )
                    .onTapGesture {
                        if selectedFilter == filter {
                            selectedFilter = nil
                        } else {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}

#Preview {
    @Previewable @State var filter: FilterPost? = nil
    FilterView(selectedFilter: $filter)
        .background(Color.green)
}
