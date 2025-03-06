module NavigationHelper
  def main_menu
    [
      { name: "About", path: "#" },
      { name: "Data Explorer", path: data_explorer_path },
      { name: "Community Data Summaries", path: communities_path },
      { name: "User Guide", path: "#" }
    ]
  end
end 