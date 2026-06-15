//
//  CharacterDetailSectionView.swift
//  KapitalTest
//
//  Created by Sergio Acosta on 15/06/26.
//

import SwiftUI
import DesignSystem

struct CharacterDetailSectionModel {
    let iconName: String
    let title: String
    let items: [String]
    let emptyMessage: String
    let color: DSColorStyle
    let background: DSColorStyle
    
    var count: Int {
        items.count
    }
}

struct CharacterDetailSectionView: View {
    let section: CharacterDetailSectionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: DSDimens.spacing_4) {
            buildDetailHeaderSectionView()
            
            if section.items.isEmpty {
                Text(section.emptyMessage)
                    .font(.caption1Medium)
                    .foregroundStyle(.ink(.secondary))
            } else {
                VStack(alignment: .leading, spacing: DSDimens.spacing_4) {
                    ForEach(Array(section.items.enumerated()), id: \.offset) { index, item in
                        CharacterDetailItemRow(
                            index: index + 1,
                            title: item,
                            color: section.color,
                            background: section.background
                        )
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func buildDetailHeaderSectionView() -> some View {
        HStack {
            buildDetailHeaderLabelSectionView()
            
            Spacer()
            
            if section.count > 0 {
                buildDetailHeaderCounterView()
            }
        }
    }
    
    @ViewBuilder
    func buildDetailHeaderLabelSectionView() -> some View {
        Label {
            Text(section.title)
                .font(.bodyBold)
                .foregroundStyle(.ink(.primary))
        } icon: {
            Image(systemName: section.iconName)
                .font(.caption1Bold)
                .foregroundStyle(section.color)
        }
    }
    
    @ViewBuilder
    func buildDetailHeaderCounterView() -> some View {
        Text("\(section.count)")
            .font(.caption2Bold)
            .foregroundStyle(section.color)
            .frame(
                width: DSSizeDimens.width_20,
                height: DSSizeDimens.height_20
            )
            .background(section.background)
            .clipShape(Circle())
    }
}

#if DEBUG
#Preview {
    CharacterDetailSectionView(
        section: .init(
            iconName: "film",
            title: AppStrings.filmsTitle,
            items: [],
            emptyMessage: AppStrings.noFilmsMessage,
            color: .ink(.film),
            background: .placeholder(.blue)
        )
    )
}
#endif
