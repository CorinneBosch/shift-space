require "rails_helper"

RSpec.describe ShiftsController, type: :controller do
  login_user

  before :each do
    @sample_org = add_new_organisation
  end

  describe 'GET shifts#index ' do
    before :each do
      add_new_shift
    end

    it "routes to organisations shift table" do
      expect(get: "/organisations/1/shifts").to route_to(
        controller: "shifts",
        action: "index",
        organisation_id: "1"
      )
    end

    it "displays exising sifts" do
      get :index, params: { organisation_id: @sample_org.id, id: Shift.last.id }, xhr: true
      expect(assigns(:shifts)).to eq @shift
    end

    it "returns https success 200" do
      get :index, params: { organisation_id: @sample_org.id }, xhr: true
      expect(response).to have_http_status(200)
    end

    it "renders index successfully" do
      get :index, params: { organisation_id: @sample_org.id }, xhr: true
      expect(response).to render_template("index")
    end
  end

  describe 'POST shifts#create' do
    before :each do
      @sample_user = add_new_user
    end

    it "creates new shift and updates view" do
      current_org_id = Organisation.last.id
      post :create, params: post_create_shift_params
      assert_redirected_to redirect_to((organisations_url + "/#{current_org_id}"))
    end

    it "creates new shift and responds with status 302" do
      post :create, params: post_create_shift_params
      expect(response).to have_http_status(302)
    end

    it "doesn\'t create shift with invalid input" #do
      # post :create, params: {
      #   shift: {   
      #     employee: nil,
      #     shift_start_date: '2021-11-27',
      #     shift_start_time: '10:00',
      #     shift_end: nil,
      #     break_length: nil,
      #     user_id: nil, 
      #     organisation_id: nil, 
      #   }, organisation_id: Organisation.last.id
      # }, xhr: true
      # expect{ get :index }.to raise_error(ActionController::ParameterMissing)
      # expect(flash[:alert]).to match('Oops something went wront.. Please try again!')
    # end

    it "informs user shift is added" do
      post :create,
      params: {
        shift: {   
          employee: 'Gandalf',
          shift_start_date: '2021-11-27',
          shift_start_time: '10:00',
          shift_end: Time.new(2021, 11, 27, 18, 11, 00),
          break_length: 30,
          user_id: User.last.id, 
          organisation_id: Organisation.last.id, 
        }, organisation_id: Organisation.last.id
      }, xhr: true
      expect(flash[:notice]).to match('Shift added!')
    end
  end

  describe 'PATCH shift#update' do
    let(:updated_shift) { patch :update, :params => { organisation_id: @sample_org.id,
        id: Shift.last.id,
        :shift => { name: 'Treehouse', hourly_rate: 18.00 }
      }
    }

    before :each do
      add_new_shift
      updated_shift
    end

    it "updates shift and redirects to organisations index" do
      current_org_id = Organisation.last.id
      expect(response).to redirect_to(organisations_url + "/#{current_org_id}")
    end

    it "informs user shift updated successfully" do
      expect(flash[:notice]).to match('Shift updated successfully!')
    end

    it "updates shift and responds with status 302" do
      expect(response).to have_http_status(302)
    end
  end


  describe 'DELETE shift#destroy' do
    let(:delete_shift) { delete :destroy, :params => { 
          organisation_id: @sample_org.id, id: Shift.last.id 
        } 
      }
    
    before :each do
      add_new_shift
      delete_shift
    end

    it "deletes shift from table and updates view" do
      current_org_id = Organisation.last.id
      expect(response).to redirect_to(organisations_url + "/#{current_org_id}")
    end

    it "informs user shift deleted successfully" do
      expect(flash[:notice]).to match('Shift deleted!')
    end

    it "deletes shift and responds with status 302" do
      expect(response).to have_http_status(302)
    end
  end
end 
