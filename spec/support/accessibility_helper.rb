module AccessibilityHelpers
  def expect_page_to_be_accessible
    standards = %i[wcag2a wcag2aa wcag21a wcag21aa]

    expect(page).to be_axe_clean.according_to(*standards)
  end
end
