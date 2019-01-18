require "rails_helper"

describe BigBlueButtonController, type: :controller do
  describe "POST #join" do
    it "should render the correct template" do
      params = {
        big_blue_button: {
          name: "",
          password: "",
        },
      }

      silently do
        post :join, params: params
      end

      expect(response).to render_template("join")
    end

    it "should redirect to the correct endpoint" do
      params = {
        big_blue_button: {
          name: "Bob",
          password: Rails.configuration.demo_moderator_pw,
        },
      }

      silently do
        post :login
        post :join, params: params
      end

      expect(response.location).to start_with(Rails.configuration.bigbluebutton_endpoint)
    end

    it "should enter the correct error state for empty name" do
      params = {
        big_blue_button: {
          name: "",
          password: "",
        },
      }

      silently do
        post :login
        post :join, params: params
      end

      expect(assigns(:error_state)).to be true
      expect(assigns(:error_msg)).to eq assigns(:error_msgs)["empty_name"]
    end

    it "should enter the correct error state for incorrect password" do
      params = {
        big_blue_button: {
          name: "Bob",
          password: "",
        },
      }

      silently do
        post :login
        post :join, params: params
      end

      expect(assigns(:error_state)).to be true
      expect(assigns(:error_msg)).to eq assigns(:error_msgs)["incorrect_pw"]
    end
  end
end
