module SummaryParent
  def display_title
    self.class.model_name.human.titleize
  end
end
