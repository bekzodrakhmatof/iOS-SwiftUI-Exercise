//
//  ItemDetailsView.swift
//  iOS SwiftUI Exercise
//
//  Created by Bekzod Rakhmatov on 19/12/23.
//

import SwiftUI

class ItemDetailsViewModel: ObservableObject {

    @Published var saveButtonDisabled = true
    @Published var modelDisabled = true
    @Published var styleSKUDisabled = true
    @Published var brandTitle = ""
    @Published var modelTitle = ""
    @Published var styleTitle = ""
    @Published var skuTitle = ""
    @Published var brands = [Brand]()
    @Published var models = [Model]()
    @Published var selectedBrand: Brand?
    
  
    func selectBrand(brand: Brand) {
        selectedBrand = brand
        brandTitle = brand.name
        APIManager.shared.getModel(brandUuid: brand.id) { response, error in
            if let models = response?.models {
                DispatchQueue.main.async {
                    self.models = models
                    self.modelDisabled = models.isEmpty
                }
            } else {
                print("Handle errors: \(error ?? ""), \(response?.message ?? "")")
            }
        }
    }
    
    func getBrands() {
        APIManager.shared.getBrands { response, error in
            if let brands = response?.brands {
                DispatchQueue.main.async {
                    self.brands = brands
                }
            } else {
                print("Handle errors: \(error ?? ""), \(response?.message ?? "")")
            }
        }
    }
    
    func selectModel(model: Model) {
        modelTitle = model.name
        styleSKUDisabled = false
        saveButtonDisabled = false
    }
}

struct ItemDetailsView: View {
    
    @StateObject var vm = ItemDetailsViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var viewContext
    @Binding var item: Item?
    
    var body: some View {
        VStack(spacing: 16) {
            NavigationTitleView(title: "Item Details") {
                dismiss()
            }
            .padding(.top)
            Text("Details")
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
            if let item = item {
                SavedDetailsView(item: item)
            } else {
                if vm.models.isEmpty {
                    SaveDetailsView()
                } else {
                    SaveDetailsView()
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            print("ITEM: \(item)")
            if item == nil {
                vm.getBrands()
            }
        }
    }
    
    @ViewBuilder func SavedDetailsView(item: Item) -> some View {
        VStack {
            DisplayTextView(title: item.brand ?? "")
            DisplayTextView(title: item.model ?? "")
            DisplayTextView(title: item.style ?? "")
            DisplayTextView(title: item.sku ?? "")
            Button {
                viewContext.delete(item)
                do {
                    try viewContext.save()
                    dismiss()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            } label: {
                Text("Delete")
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .cornerRadius(18)
                    .font(.system(size: 20, weight: .medium))
            }
        }
    }
    
    @ViewBuilder func SaveDetailsView() -> some View {
        VStack {
            Menu {
                ForEach(vm.brands) { brand in
                    Button {
                        vm.selectBrand(brand: brand)
                    } label: {
                        Text(brand.name)
                    }
                }
            } label: {
                DropDownView(
                    title: $vm.brandTitle,
                    disabled: .constant(false),
                    placeholder: "Brand")
            }
            Menu {
                ForEach(vm.models) { model in
                    Button {
                        vm.selectModel(model: model)
                    } label: {
                        Text(model.name)
                    }
                }
            } label: {
                DropDownView(
                    title: $vm.modelTitle,
                    disabled: $vm.modelDisabled,
                    placeholder: "Model")
            }
            CustomTextField(
                text: $vm.styleTitle,
                disabled: $vm.styleSKUDisabled,
                placeholder: "Style (Optional)")
            CustomTextField(
                text: $vm.skuTitle,
                disabled: $vm.styleSKUDisabled,
                placeholder: "SKU (Optional)")
            MainButtonView(
                disabled: $vm.saveButtonDisabled,
                title: "Save") {
                    saveItem()
                }
        }
    }
    
    func saveItem() {
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        newItem.brand = vm.brandTitle
        newItem.model = vm.modelTitle
        newItem.style = vm.styleTitle
        newItem.sku = vm.skuTitle
        do {
            try viewContext.save()
            dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    ItemDetailsView(item: .constant(nil))
}
