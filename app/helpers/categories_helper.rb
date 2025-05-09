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
    { 'infrastructure' => 'bi-buildings',
      'social' => 'bi-people',
      'renewables' => 'bi-sun-fill',
      'energy' => 'bi-lightning-fill',
      'electricity' => 'bi-ev-front',
      'transportation' => 'bi-truck',
      'fuel' => 'bi-fuel-pump',
      'population' => 'bi-people-fill' }[topic.downcase]
  end
end
