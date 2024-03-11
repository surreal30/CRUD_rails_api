require 'rails_helper'

RSpec.describe "Users", type: :request do

  # GET requests (Read)
  describe "GET /users" do
    it "returns http success" do
      get "/api/v1/users"

      expect(response.status).to eq(200)
    end
  end

  describe "GET /users/9" do 
    it "fetches user with the same id" do
      get "/api/v1/users/9"

      expect(response.status).to eq(200)
      json = JSON.parse(response.body)
      expect(json.keys).to contain_exactly("id", "username", "password", "created_at", "updated_at")
    end
  end

  describe "GET /users/100000000" do 
    it "shows 404 not found" do
      get "/api/v1/users/100000000"

      expect(response.status).to eq(404)
    end
  end

  describe "GET /users/1000ajhs00000" do 
    it "shows 404 not found, invalid user id" do
      get "/api/v1/users/1000ajhs00000"

      expect(response.status).to eq(404)
    end
  end

  # POST requests (Create)
  describe "POST /users" do
    it "create a new user" do
      params = {username: "john", password: "abcdabcd"}
      post "/api/v1/users", params: params

      expect(response.status).to eq(201)
      json = JSON.parse(response.body)
      expect(json.keys).to contain_exactly("id", "username", "password", "created_at", "updated_at")
    end
  end

  describe "POST /users" do
    it "shows unproccessable entity error, no username and short password" do
      params = {username: "", password: "abcd"}
      post "/api/v1/users", params: params

      expect(response.status).to eq(422)
    end
  end


  describe "POST /users" do
    it "shows unproccessable entity error, short password" do
      params = {username: "john", password: "abcdabc"}
      post "/api/v1/users", params: params

      expect(response.status).to eq(422)
    end
  end

  describe "POST /users" do
    it "shows unproccessable entity error, no password" do
      params = {username: "john", password: ""}
      post "/api/v1/users", params: params

      expect(response.status).to eq(422)
    end
  end

  describe "POST /users" do
    it "shows unproccessable entity error, no username and password" do
      params = {username: "", password: ""}
      post "/api/v1/users", params: params

      expect(response.status).to eq(422)
    end
  end

  describe "POST /users" do
    it "shows unproccessable entity error, no parameters" do
      post "/api/v1/users"

      expect(response.status).to eq(400)
    end
  end

  describe "POST /users" do
    it "shows bad request, a user already connected" do
      headers = {username: "jane", password: "abcd"}
      post "/api/v1/users", headers: headers

      expect(response.status).to eq(400)
    end
  end

  # PATCH requests (Update)
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
    it "fails because user is unauthorised, username not matching" do
      params = {username: "jane", password: "abcd"}
      headers = {username: "june", password: "abcd"}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(401)
    end
  end

  describe "PATCH /users/9" do
    it "fails because user is unauthorised, incorrect password" do
      params = {username: "june", password: "abcd"}
      headers = {username: "jane", password: "abcsasadsafd"}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(401)
    end
  end

  describe "PATCH /users/9" do
    it "fails because invalid password, empty password" do
      params = {username: "june", password: "abcd"}
      headers = {username: "jane", password: ""}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(422)
    end
  end

  describe "PATCH /users/9" do
    it "fails because invalid username, no username" do
      params = {username: "june", password: "abcd"}
      headers = {username: "", password: "abcd"}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(422)
    end
  end

  describe "PATCH /users/9" do
    it "fails because invalid headers, invalid username" do
      params = {username: "june", password: "abcd"}
      headers = {username: "<h1></h1>", password: "abcd"}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(422)
    end
  end

  describe "PATCH /users/9" do
    it "fails because invalid headers , invalid password" do
      params = {username: "june", password: "abcd"}
      headers = {username: "jane", password: "<br><br>"}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(422)
    end
  end

  describe "PATCH /users/9" do
    it "fails because invalid headers, invalid username and password" do
      params = {username: "june", password: "abcd"}
      headers = {username: "<br><br>", password: "<br><br>"}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(422)
    end
  end

  describe "PATCH /users/9" do
    it "fails because invalid parameters, invalid password" do
      params = {username: "june", password: "<br><br>"}
      headers = {username: "jane", password: "abcd"}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(422)
    end
  end

  describe "PATCH /users/9" do
    it "fails because invalid parameters, invalid username" do
      params = {username: "<br><br>", password: "abcd"}
      headers = {username: "jane", password: "abcd"}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(422)
    end
  end

  describe "PATCH /users/9" do
    it "fails because invalid parameters, invalid username and password" do
      params = {username: "<br><br>", password: "<br><br>"}
      headers = {username: "jane", password: "abcd"}
      patch "/api/v1/users/9", params: params, headers: headers

      expect(response.status).to eq(422)
    end
  end

  # DELETE requests (Delete)
  describe "DELETE /users/9" do
    it "user is deleted" do
      headers = {username: "jane", password: "abcd"}
      delete "/api/v1/users/9", headers: headers

      expect(response.status).to eq(204)
    end
  end

   describe "DELETE /users/9" do
    it "fails because user is unauthorised, incorrect username" do
      headers = {username: "june", password: "abcd"}
      delete "/api/v1/users/9", headers: headers

      expect(response.status).to eq(401)
    end
  end

  describe "DELETE /users/9" do
    it "fails because user is unauthorised, incorrect password" do
      headers = {username: "jane", password: "safnkjasnkjf"}
      delete "/api/v1/users/9", headers: headers

      expect(response.status).to eq(401)
    end
  end

  describe "DELETE /users/9" do
    it "fails because invalid headers, empty password" do
      headers = {username: "jane", password: ""}
      delete "/api/v1/users/9", headers: headers

      expect(response.status).to eq(422)
    end
  end

  describe "DELETE /users/9" do
    it "fails because invalid headers, empty username" do
      headers = {username: "", password: "abcd"}
      delete "/api/v1/users/9", headers: headers

      expect(response.status).to eq(422)
    end
  end

  describe "DELETE /users/9" do
    it "fails because bad request, no headers" do
      delete "/api/v1/users/9"

      expect(response.status).to eq(400)
    end
  end

  describe "DELETE /users/976476425725" do
    it "fails because user does not exist" do
      headers = {username: "jane", password: "abcd"}
      delete "/api/v1/users/9", headers: headers

      expect(response.status).to eq(404)
    end
  end

end
