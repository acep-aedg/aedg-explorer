module CategoriesHelper
  def category_links
    [
      { name: "Renewables", icon: "bi-sun-fill", path: "#" },
      { name: "Energy", icon: "bi-lightning-fill", path: "#" },
      { name: "Electricity", icon: "bi-ev-front", path: "#" },
      { name: "Transportation", icon: "bi-truck", path: "#" },
      { name: "Fuel", icon: "bi-fuel-pump", path: "#" },
      { name: "Population", icon: "bi-people-fill", path: "#" }
    ]
  end
end