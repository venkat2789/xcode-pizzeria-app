//
//  DetailView.swift
//  Pizzeria
//
//  Created by Venkatachalapathy Sivaprakasam on 5/22/22.
//

import SwiftUI

struct DetailView: View {
    let pizzaTypes = ["Pizza Margherita", "Greek Pizza", "Pizza Supreme", "Pizza California", "New York Pizza"]
    let crustTypes = ["Normal", "Thin Crust"]
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var selectedPizzaIndex = 1
    @State private var numberOfSlices = 1
    @State private var crustType = 1
    @State private var isIngredientExpanded : Bool = true
    @State private var presentAlert = false
    @Binding var isDetailViewShown: Bool
    
    var body: some View {
        VStack{
            Image("pizza-placeholder")
                .resizable()
                .ignoresSafeArea(edges: .top)
                .frame(height: 200)
            
            HStack {
                Button(action: {
                    isDetailViewShown = false
                }) {
                    Image(systemName: "arrow.backward.circle.fill")
                        .foregroundColor(.red)
                    Text("Back to menu")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.leading, -5)
                }
                .padding(.leading)
                Spacer()
            }
            
            
            ScrollView{
                DisclosureGroup("Ingredients", isExpanded: $isIngredientExpanded) {
                    Text("These are the ingredients.These are the ingre dients. These are the ingredients. These are the ingredients.")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                        .font(.caption)
                }
                .padding()
                .foregroundColor(.black)
                .accentColor(.red)
                
                NavigationView {
                    Form {
                        Section(header: Text("Pizza")) {
                            Picker(selection: $selectedPizzaIndex, label: Text("Pizza Type")) {
                                ForEach(0 ..< pizzaTypes.count, id:\.self) {
                                    Text(self.pizzaTypes[$0]).tag($0)
                                }
                            }
                            
                            Stepper("\(numberOfSlices) Slices", value: $numberOfSlices, in: 1...12)
                        }
                        .navigationBarBackButtonHidden(true)
                        Section(header: Text("Crust")) {
                            Picker("Crust", selection: $crustType) {
                                ForEach(0 ..< crustTypes.count, id:\.self) {
                                    Text(self.crustTypes[$0]).tag($0)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    .navigationTitle("Customize")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                }
                .frame(height: 400, alignment: .center)
                
                Button(action: {
                    let newOrder = PizzaOrder(context: viewContext)
                    newOrder.pizzaType = self.pizzaTypes[self.selectedPizzaIndex]
                    newOrder.orderStatus = .pending
                    newOrder.numberOfSlices = Int16(self.numberOfSlices)
                    newOrder.id = UUID()
                    
                    do {
                        try viewContext.save()
                        print("Order saved.")
                        withAnimation(.default){
                            presentAlert = true
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }) {
                    Text("Add to Order")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 150, height: 45)
                        .background(Color.red)
                        .cornerRadius(15.0)
                }
                .padding()
                .alert("Awesome!", isPresented: $presentAlert, actions: {
                    Button("OK", role: .cancel, action: {})
                }, message: {
                    Text("Item added to your order.")
                })
            }
        }
        .background(Color("LightGrayBackground"))
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(isDetailViewShown: Binding.constant(true)).environmentObject(ViewRouter())
    }
}