import SwiftUI

struct QuotesView: View {
    @StateObject private var viewModel: QuotesViewModel
    @State private var showingAddQuote = false
    @State private var showingPremiumAlert = false
    
    init(viewModel: QuotesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("View", selection: $viewModel.selectedTab) {
                    Text("All Quotes").tag(QuotesViewModel.Tab.all)
                    Text("Favorites").tag(QuotesViewModel.Tab.favorites)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List {
                        ForEach(viewModel.selectedTab == .all ? viewModel.quotes : viewModel.favoriteQuotes) { quote in
                            QuoteRow(quote: quote) {
                                Task {
                                    await viewModel.toggleFavorite(quoteId: quote.id)
                                }
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                let quotes = viewModel.selectedTab == .all ? viewModel.quotes : viewModel.favoriteQuotes
                                for index in indexSet {
                                    await viewModel.deleteQuote(byId: quotes[index].id)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Quotes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddQuote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddQuote) {
                AddQuoteView { quote in
                    Task {
                        let canSave = await viewModel.canSaveMoreQuotes()
                        if canSave {
                            await viewModel.saveQuote(quote)
                        } else {
                            showingPremiumAlert = true
                        }
                    }
                }
            }
            .alert("Premium Required", isPresented: $showingPremiumAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Upgrade") {
                    // TODO: Show premium purchase view
                }
            } message: {
                Text("You've reached the limit of 10 quotes. Upgrade to premium to save unlimited quotes!")
            }
            .task {
                await viewModel.loadQuotes()
            }
        }
    }
}

struct QuoteRow: View {
    let quote: Quote
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quote.text)
                .font(.body)
            
            Text("- \(quote.author)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Spacer()
                Button {
                    onFavoriteToggle()
                } label: {
                    Image(systemName: quote.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(quote.isFavorite ? .red : .gray)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddQuoteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @State private var author = ""
    let onSave: (Quote) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Quote", text: $text, axis: .vertical)
                    .lineLimit(3...6)
                
                TextField("Author", text: $author)
            }
            .navigationTitle("Add Quote")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let quote = Quote(text: text, author: author)
                        onSave(quote)
                        dismiss()
                    }
                    .disabled(text.isEmpty || author.isEmpty)
                }
            }
        }
    }
} 