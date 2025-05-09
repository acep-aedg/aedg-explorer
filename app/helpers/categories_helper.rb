module CategoriesHelper
  def category_links
    [
      { name: 'Renewables', icon: 'bi-sun-fill', path: '#' },
      { name: 'Infrastructure', icon: 'bi-buildings', path: '#' },
      { name: 'Energy', icon: 'bi-lightning-fill', path: '#' },
      { name: 'Electricity', icon: 'bi-ev-front', path: '#' },
      { name: 'Transportation', icon: 'bi-truck', path: '#' },
      { name: 'Fuel', icon: 'bi-fuel-pump', path: '#' },
      { name: 'Population', icon: 'bi-people-fill', path: '#' }
    ]
  end

  def topic_icon(topic)
    case topic.downcase
    when 'infrastructure'
      'bi-buildings'
    when 'social'
      'bi-people'
    when 'renewables'
      'bi-sun-fill'
    when 'energy'
      'bi-lightning-fill'
    when 'electricity'
      'bi-ev-front'
    when 'transportation'
      'bi-truck'
    when 'fuel'
      'bi-fuel-pump'
    when 'population'
      'bi-people-fill'
    end
  end
end
