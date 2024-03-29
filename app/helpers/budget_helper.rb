# rubocop:disable Metrics/ModuleLength
module BudgetHelper
  def unavailable_balance?
    current_user.balance <= 0
  end

  def bar_chart_data
    {
      labels: @categories_expenses.map { |item| item[:name] },
      datasets: [
        {
          label: 'Expenses',
          data: @categories_expenses.map { |item| item[:total] },
          background_color: [
            'rgba(255, 99, 132, 0.3)',
            'rgba(255, 159, 64, 0.3)',
            'rgba(255, 205, 86, 0.3)',
            'rgba(75, 192, 192, 0.3)',
            'rgba(54, 162, 235, 0.3)',
            'rgba(153, 102, 255, 0.3)',
            'rgba(201, 203, 207, 0.3)'
          ],
          border_color: [
            'rgb(255, 99, 132)',
            'rgb(255, 159, 64)',
            'rgb(255, 205, 86)',
            'rgb(75, 192, 192)',
            'rgb(54, 162, 235)',
            'rgb(153, 102, 255)',
            'rgb(201, 203, 207)'
          ],
          border_width: 1
        }
      ]
    }
  end

  def bar_chart_options
    {
      index_axis: 'y',
      aspect_ratio: 1.5,
      plugins: {
        title: {
          text: 'Amount Expended x Category',
          display: true
        },
        tooltip: {
          callbacks: {
            label: 'function(context) {
              return `${context.dataset.label}: $${context.parsed.x}`
            }'
          }
        },
        legend: {
          display: false
        }
      },
      scales: {
        x: {
          ticks: {
            callback: 'function(value) {
              return `$${value}`;
            }'
          }
        }
      },
      datasets: {
        bar: {
          bar_percentage: 0.6
        }
      }
    }
  end

  def line_chart_data
    {
      labels: @last_days_ops.map { |item| item[:date] },
      datasets: [
        {
          label: 'Daily expenses',
          data: @last_days_ops.map { |item| item[:total] },
          background_color: [
            'rgba(54, 162, 235, 0.5)'
          ],
          border_color: [
            'rgb(54, 162, 235)'
          ],
          border_width: 1
        }
      ]
    }
  end

  def line_chart_options
    {
      aspect_ratio: 1.5,
      scales: {
        y: {
          ticks: {
            callback: 'function(value) {
              return `$${value}`;
            }'
          },
          begin_at_zero: true
        }
      },
      plugins: {
        title: {
          text: 'Expenses x Day',
          display: true
        },
        tooltip: {
          callbacks: {
            label: 'function(context) {
              return `${context.dataset.label}: $${context.parsed.y}`
            }'
          }
        }
      },
      interaction: {
        intersect: false,
        mode: 'index'
      }
    }
  end
end
# rubocop:enable Metrics/ModuleLength
