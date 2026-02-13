import "chartkick"

// Fix for Chartkick bug with Turbo
if (window.Chartkick) {
  window.Chartkick.config.autoDestroy = false

  window.addEventListener('turbo:before-render', () => {
    window.Chartkick.eachChart(chart => {
      if (chart.element && !chart.element.isConnected) {
        chart.destroy()
        delete window.Chartkick.charts[chart.element.id]
      }
    })
  })
} else {
  console.warn("Chartkick not found during initialization")
}