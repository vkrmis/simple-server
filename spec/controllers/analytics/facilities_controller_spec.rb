require 'rails_helper'

RSpec.describe Analytics::FacilitiesController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  let(:district_name) { 'Bathinda' }
  let(:organization) { create(:organization) }
  let(:facility_group) { create(:facility_group, organization: organization) }
  let(:facility) { create(:facility, facility_group: facility_group, district: district_name) }

  before do
    #
    # register patients
    #
    registered_patients = Timecop.travel(Date.new(2019, 1, 1)) do
      create_list(:patient, 3, registration_facility: facility, registration_user: user)
    end

    #
    # add blood_pressures next month
    #
    Timecop.travel(Date.new(2019, 2, 1)) do
      registered_patients.each { |patient| create(:blood_pressure,
                                                  patient: patient,
                                                  facility: facility,
                                                  user: user) }
    end

    Patient.where(id: registered_patients.map(&:id))
  end

  before do
    sign_in(admin)
  end

  describe '#show' do
    render_views

    context 'dashboard analytics' do
      it 'returns relevant analytics keys per facility' do
        get :show, params: { id: facility.id }

        expect(response.status).to eq(200)
        expect(assigns(:analytics).dig(:dashboard, user.id).keys).to match_array([:follow_up_patients_by_month,
                                                                                  :registered_patients_by_month,
                                                                                  :total_registered_patients])
      end
    end

    it 'renders the cohort chart view' do
      get :show, params: { id: facility.id }
      expect(response).to render_template(partial: 'shared/_cohort_charts')
    end

    it 'renders the analytics table view' do
      get :show, params: { id: facility.id }
      expect(response).to render_template(partial: 'shared/_analytics_table')
    end

    it 'renders the recent BP view' do
      get :show, params: { id: facility.id }
      expect(response).to render_template(partial: 'shared/_recent_bp_log')
    end

    context 'analytics caching for facilities' do
      before do
        Rails.cache.clear
      end

      let(:today) { Date.today }
      let(:cohort_date1) { (today - (0 * 3).months).beginning_of_quarter }
      let(:cohort_date2) { (today - (1 * 3).months).beginning_of_quarter }
      let(:cohort_date3) { (today - (2 * 3).months).beginning_of_quarter }

      it 'caches the facility correctly' do
        today = Date.today.strftime("%Y-%m-%d")
        analytics_cache_key = "analytics/#{today}/facilities/#{facility.id}"

        expected_cache_value =
          { cohort: {
            cohort_date1 => { :registered => 0, :followed_up => 0, :defaulted => 0, :controlled => 0, :uncontrolled => 0 },
            cohort_date2 => { :registered => 3, :followed_up => 0, :defaulted => 3, :controlled => 0, :uncontrolled => 0 },
            cohort_date3 => { :registered => 0, :followed_up => 0, :defaulted => 0, :controlled => 0, :uncontrolled => 0 }
          },
            dashboard: {
              user.id => {
                registered_patients_by_month: { Date.new(2019, 1, 1) => 3 },
                total_registered_patients: 3,
                follow_up_patients_by_month: { Date.new(2019, 2, 1) => 3 }
              }
            }
          }

        get :show, params: { id: facility.id }

        expect(Rails.cache.exist?(analytics_cache_key)).to be true
        expect(Rails.cache.fetch(analytics_cache_key)).to eq expected_cache_value
      end
    end
  end

  describe '#whatsapp_graphics' do
    render_views

    context 'html requested' do
      it 'renders graphics_header partial' do
        get :whatsapp_graphics, format: :html, params: { facility_id: facility.id}

        expect(response).to be_ok
        expect(response).to render_template('shared/graphics/_graphics_partial')
      end
    end

    context 'png requested' do
      it 'renders the image template for downloading' do
        get :whatsapp_graphics, format: :png, params: { facility_id: facility.id}

        expect(response).to be_ok
        expect(response).to render_template('shared/graphics/image_template')
      end
    end
  end
end
