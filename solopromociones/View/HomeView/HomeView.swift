import SwiftUI
import Combine
import Lottie

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var searchText = ""
    @State private var showCityPicker = false
    @State private var showCategoryPicker = false
    @State private var currentFeaturedPage = 0
    @State private var isSearchActive = false
    @State private var isRefreshing = false
    @State private var selectedPromotion: Promotion?

    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @Binding var selectedTab: Int

    var body: some View {
        ZStack {
            NavigationView {
                VStack(spacing: 0) {
                    NavigationLink(
                        destination: PromotionDetailView(promotionId: selectedPromotion?.id ?? ""),
                        isActive: Binding<Bool>(
                            get: { selectedPromotion != nil },
                            set: { newValue in if !newValue { selectedPromotion = nil } }
                        )
                    ) {
                        EmptyView()
                    }.hidden()

                    ScrollView {
                        PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                            await refreshData()
                        }

                        VStack(alignment: .leading, spacing: 16) {
                            headerSection
                            searchSection
                            ForEach(viewModel.sections) { section in
                                SectionView(section: section, navigateToDetail: navigateToDetail)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .coordinateSpace(name: "pullToRefresh")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(true)
                    .background(Color(.systemBackground))
                }
            }

            if viewModel.showError {
                ErrorView(message: viewModel.errorMessage)
                    .onTapGesture {
                        viewModel.showError = false
                    }
                    .zIndex(1)
            }

            if viewModel.isLoading {
                LoadingView()
                    .zIndex(2)
            }
        }
        .sheet(isPresented: $showCityPicker) {
            CityPickerView(selectedCity: $viewModel.selectedCity, cities: viewModel.cities)
        }
        .sheet(isPresented: $showCategoryPicker) {
            CategoryPickerView(selectedCategory: $viewModel.selectedCategory, categories: viewModel.categories)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Buscar promociones en")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            HStack {
                Button(action: { showCityPicker = true }) {
                    HStack {
                        Text(viewModel.selectedCity)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button(action: { showCategoryPicker = true }) {
                    HStack {
                        if let category = viewModel.selectedCategory {
                            Image(systemName: category.iconName)
                                .foregroundColor(category.color)
                            Text(category.name)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .lineLimit(1)
                        } else {
                            Text("Todas")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.vertical, 8)
    }

    private var searchSection: some View {
        HStack {
            ZStack {
                SearchBar(text: $searchText, isKeyboardEnabled: false, shouldFocus: false)
                    .opacity(0.8)

                Button(action: {
                    isSearchActive = true
                }) {
                    Color.clear
                }
            }

            Button(action: {
                showCategoryPicker = true
            }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
        }
    }

    private func refreshData() async {
        isRefreshing = true
        await viewModel.refreshData()
        isRefreshing = false
    }

    private func navigateToDetail(promotion: Promotion) {
        selectedPromotion = promotion
    }
}

struct SectionView: View {
    let section: PromotionSection
    let navigateToDetail: (Promotion) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(section.title)
                .font(.headline)
                .fontWeight(.medium)

            switch section.cellType {
            case .carousel:
                CarouselPromotionCell(promotions: section.promotions, navigateToDetail: navigateToDetail)
            case .standard:
                StandardPromotionList(promotions: section.promotions, navigateToDetail: navigateToDetail)
            case .compactHorizontal:
                CompactHorizontalPromotionList(promotions: section.promotions, navigateToDetail: navigateToDetail)
            case .featured:
                FeaturedPromotionList(promotions: section.promotions, navigateToDetail: navigateToDetail)
            // Add cases for other cell types as needed
            default:
                StandardPromotionList(promotions: section.promotions, navigateToDetail: navigateToDetail)
            }
        }
    }
}

struct StandardPromotionList: View {
    let promotions: [Promotion]
    let navigateToDetail: (Promotion) -> Void

    var body: some View {
        ForEach(promotions) { promotion in
            Button(action: {
                navigateToDetail(promotion)
            }) {
                StandardPromotionCell(promotion: promotion)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct CompactHorizontalPromotionList: View {
    let promotions: [Promotion]
    let navigateToDetail: (Promotion) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(promotions) { promotion in
                    Button(action: {
                        navigateToDetail(promotion)
                    }) {
                        CompactHorizontalPromotionCell(promotion: promotion)
                            .frame(width: 260)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct FeaturedPromotionList: View {
    let promotions: [Promotion]
    let navigateToDetail: (Promotion) -> Void

    var body: some View {
        ForEach(promotions) { promotion in
            Button(action: {
                navigateToDetail(promotion)
            }) {
                FeaturedPromotionCell(promotion: promotion)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct PullToRefresh: View {
    var coordinateSpaceName: String
    var onRefresh: () async -> Void

    @State private var needRefresh: Bool = false

    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 1) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            Task {
                                await onRefresh()
                            }
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

struct LoadingView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<LoadingView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView(name: "loading")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 100),
            animationView.heightAnchor.constraint(equalToConstant: 100),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LoadingView>) {}
}
