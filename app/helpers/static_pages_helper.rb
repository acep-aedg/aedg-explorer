module StaticPagesHelper
  def aedg_timeline
    YAML.load_file(Rails.root.join("config/data/aedg_timeline.yml"))["aedg_timeline"].map(&:symbolize_keys)
  end

  def data_creation_steps
    YAML.load_file(Rails.root.join("config/data/data_creation_steps.yml"))["data_creation_steps"].map(&:symbolize_keys)
  end

  def grouped_partners
    YAML.load_file(Rails.root.join("config/data/partners.yml"))
  end

  def faq_categories
    YAML.load_file(Rails.root.join("config/data/faq.yml"))["categories"]
  end

  def aedg_citation
    access_date = Time.zone.today.strftime("%B %-d, %Y")
    "Alaska Center for Energy and Power (ACEP) and Institute of Social and Economic Research (ISER). *Alaska Energy Data Gateway v3.0*. Accessed #{access_date}. https://akenergygateway.alaska.edu/"
  end
end
