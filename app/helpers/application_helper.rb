module ApplicationHelper
  def main_menu
    [
      { name: "About", path: "#" },
      { name: "Explore Data", 
        children: [
          { name: "Data Explorer", path: metadata_path },
          { name: "Community Summaries", path: communities_path }
        ]
      },
      { name: "User Guide", path: "#" }
    ]
  end
end
