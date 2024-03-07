require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "returns http success" do
      get "/api/v1/users"

      expect(response.status).to eq(200)
    end
  end

  describe "POST /users" do
    it "create a new user" do
      params = {username: "john", password: "abcd"}
      post "/api/v1/users", params: params

      expect(response.status).to eq(201)
      json = JSON.parse(response.body)
      expect(json.keys).to contain_exactly("id", "username", "password", "created_at", "updated_at")
    end
  end

  describe "GET /users/9" do 
    it "fetches user with the same id" do
      get "/api/v1/users/9"

      puts response.body

      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json.keys).to contain_exactly("id", "username", "password", "created_at", "updated_at")
    end
  end

  describe "GET /users/100000000" do 
    it "shows 404 not found" do
      get "/api/v1/users/100000000"

      expect(response.status).to eq(404)
      # json = JSON.parse(response.body)
      # expect(json.keys).to contain_exactly("id", "username", "password", "created_at", "updated_at")
    end
  end

  describe "PATCH /users/9" do
    it "updates user with id 9 as user is authenticated" do
      params = {username: "june", password: "abcd"}
      headers = {username: "jane", password: "abcd"}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json.keys).to contain_exactly("id", "username", "password", "created_at", "updated_at")
    end
  end

  describe "PATCH /users/9" do
    it "fails because user is unauthorised" do
      params = {username: "jane", password: "abcd"}
      headers = {username: "june", password: "abcd"}
      patch "/api/v1/users/9", params: params, headers: headers
      puts response.body

      expect(response.status).to eq(401)
      # json = JSON.parse(response.body)
      # expect(json.keys).to contain_exactly("id", "username", "password", "created_at", "updated_at")
    end
  end

    describe "DELETE /users/9" do
    it "fails because user is unauthorised" do
      # params = {username: "jane", password: "abcd"}
      headers = {username: "jane", password: "abcd"}
      delete "/api/v1/users/9", headers: headers
      puts response.body

      expect(response.status).to eq(204)
      # json = JSON.parse(response.body)
      # expect(json.keys).to contain_exactly("id", "username", "password", "created_at", "updated_at")
    end
  end

end
