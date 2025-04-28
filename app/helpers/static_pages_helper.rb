module StaticPagesHelper
  def aedg_history_timeline
    [
      {
        title: 'AEDG Version 3.0',
        date: '2024–2025',
        desc: 'University partners ISER and ACEP develop and launch the revitalized AEDG with updated datasets and enhanced tools and a modernized interface.'
      },
      {
        title: 'State Support',
        date: '2024',
        desc: 'The Alaska Senate approved funding to revitalize the AEDG.'
      },
      {
        title: 'AEDG Version 2.0',
        date: '2017',
        desc: 'AEDG was redesigned by ______ in collaboration with Lawrence Berkeley National Laboratory (Berkeley Lab).'
      },
      {
        title: 'AEDG Version 1.0',
        date: '2013',
        desc: "The Alaska Energy Data Gateway (AEDG) was created by UAA's Institute of Social and Economic Research (ISER) and UAF's Alaska Center for Energy and Power (ACEP) to showcase energy and socioeconomic data for Alaska"
      }
    ]
  end

  def data_creation_steps
    [
      {
        title: 'Collect Source Data',
        desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse varius enim in eros elementum tristique. Duis cursus, mi quis viverra ornare, eros dolor interdum nulla, ut commodo diam libero vitae erat.'
      },
      {
        title: 'Combine & Aggregate',
        desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse varius enim in eros elementum tristique. Duis cursus, mi quis viverra ornare, eros dolor interdum nulla, ut commodo diam libero vitae erat.'
      },
      {
        title: 'Clean & Validate',
        desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse varius enim in eros elementum tristique. Duis cursus, mi quis viverra ornare, eros dolor interdum nulla, ut commodo diam libero vitae erat.'
      },
      {
        title: 'Collaborate with Experts',
        desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse varius enim in eros elementum tristique. Duis cursus, mi quis viverra ornare, eros dolor interdum nulla, ut commodo diam libero vitae erat.'
      }
    ]
  end

  def grouped_partners
    YAML.load_file(Rails.root.join('config/data/partners.yml'))
  end

  def faq_categories
    YAML.load_file(Rails.root.join('config/data/faq.yml'))['categories']
  end

  def aedg_citation
    access_date = Time.zone.today.strftime('%B %-d, %Y')
    "Alaska Center for Energy and Power. \"Alaska Energy Data Gateway v3.0.\" Accessed #{access_date}. https://akenergygateway.alaska.edu/"
  end
end
