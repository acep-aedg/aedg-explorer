module NavigationHelper
  def main_menu
    [
      { name: "Home", path: root_path },
      { name: "About", path: welcome_index_path },
      { 
        name: "Explore Data",
        children: [
          { name: "Community Data Summaries", path: communities_path }
        ]
      },
      { name: "Partners", path: welcome_index_path },
      { name: "FAQ", path: welcome_index_path }
    ]
  end
end 