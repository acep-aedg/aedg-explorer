module NavigationHelper
  def main_menu
    [
      { name: "About", path: "#" },
      { name: "Explore Data", 
        children: [
          { name: "Datasets", path: datasets_path },
          { name: "Community Summaries", path: communities_path }
        ]
      },
      { name: "User Guide", path: "#" }
    ]
  end
end 