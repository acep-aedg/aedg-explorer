class ContributorPresenter
  def initialize(contributor)
    @c = contributor
  end

  def object
    return nil if @c["object"].blank?

    raw = @c["object"]

    if raw.include?("http")
      url = raw.split(/\s+/).find { |s| s.start_with?("http") }
      display = url.split("/").last(2).join("/")
      {
        type: :link,
        icon: "bi-github",
        label: "Source Code",
        value: display,
        url: url
      }
    else
      clean_text = raw.gsub(/data (via|from) /i, "").strip.titleize
      {
        type: :text,
        icon: "bi-database",
        label: "Source",
        value: clean_text
      }
    end
  end
end
