require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) {User.create(username: "jane", password: BCrypt::Password.create("password"))}

  describe "GET /posts" do
    it "returns 404 because no post is currently available" do
      headers = {username: user.username, password: "password"}
      get "/api/v1/posts", headers: headers

      expect(response.status).to eq(404)
    end
  end

  describe "GET /posts/1" do
    it "returns http 404 page not found" do
      get "/api/v1/posts/1"

      expect(response.status).to eq(404)
    end
  end

  describe "POST /posts" do
    it "create a post" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers

      expect(response.status).to eq(201)
    end
  end

  # title empty
  describe "POST /posts" do
    it "returns error title empty" do 
      params = {title: "", description: "askfbhkjsabfjksabfbjkasbfkj"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # description empty
  describe "POST /posts" do
    it "returns error description empty" do 
      params = {title: "angjfknskajfuashuias", description: ""}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # title description empty
  describe "POST /posts " do
    it "returns error title description empty" do 
      params = {title: "", description: ""}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # title with html
  describe "POST /posts" do
    it "returns error  title with html" do 
      params = {title: "<test><script></script></test>", description: "askfbhkjsabfjksabfbjkasbfkj"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

   # description with html
  describe "POST /posts" do
    it "returns error description with html" do 
      params = {title: "sakjnfsjkafjka", description: "<test><script></script></test>"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

   # title description with html
  describe "POST /posts" do
    it "returns error title description with html" do 
      params = {title: "<test><script></script></test>", description: "<test><script></script></test>"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

   # title with min length
  describe "POST /posts" do
    it "returns success title with min length" do 
      params = {title: "abcde", description: "sakjbfkjasbfkjaasjfbjakls"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(201)
    end
  end

  # description with min length
  describe "POST /posts" do
    it "returns success description with min length" do 
      params = {title: "abcsfa de", description: "abcdefghik"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(201)
    end
  end

  # title description with min length
  describe "POST /posts" do
    it "returns success title description with min length" do 
      params = {title: "abcde", description: "abcdefghik"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(201)
    end
  end

  # title with min - 1 length
  describe "POST /posts" do
    it "returns error title with min - 1 length" do 
      params = {title: "abcd", description: "sakjbfkjasbfkjaasjfbjakls"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # description with min - 1 length
  describe "POST /posts" do
    it "returns error description with min - 1 length" do 
      params = {title: "abcs,fa de", description: "abcdefghi"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end
  # title description with min - 1  length
  describe "POST /posts" do
    it "returns error title description with min - 1  length" do 
      params = {title: "abcde", description: "abcdefghi"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  describe "PATCH /posts/id" do
    it "returns ok successfully updated" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "something asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(200)
    end
  end

  # unauthorized
  describe "PATCH /posts/id" do
    it "returns 401" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "something asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "passwordassa"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(401)
    end
  end

  # user not found
  describe "PATCH /posts/id" do
    it "returns 404 user not found" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "something asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: "abcdsasf", password: "password"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(404)
    end
  end

  # title empty
  describe "PATCH /posts/id" do
    it "returns title empty" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # description empty
  describe "PATCH /posts/id" do
    it "returns description empty" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "uasfkbsakjfbkjas", description: ""}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # title description empty
  describe "PATCH /posts/id" do
    it "returns 422 title description empty" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "", description: ""}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # title html
  describe "PATCH /posts/id" do
    it "returns 422 title html" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "<html><html>", description: "sfbasfknjbsfbdsakjngnjkn"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # description html
  describe "PATCH /posts/id" do
    it "returns 422 description html" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "hdgandjklnadjlkv", description: "<html><html>"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # title description html
  describe "PATCH /posts/id" do
    it "returns 422 title description html" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "<html><html>", description: "<html><html>"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # title min length
  describe "PATCH /posts/id" do
    it "returns ok successfully updated title min length" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "abcde", description: "adhjvbvhkadkhdavbkjvads"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(200)
    end
  end

  # description min length
  describe "PATCH /posts/id" do
    it "returns ok successfully updated description min length" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "adhbhvkajbkdvkb", description: "abcdefghik"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(200)
    end
  end

  # title description min length
  describe "PATCH /posts/id" do
    it "returns ok successfully updated title description min length" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "abcde", description: "abcdefghik"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(200)
    end
  end

  # title  min -1 length
  describe "PATCH /posts/id" do
    it "returns 422 title  min -1 length" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "abcd", description: "abcdefghik"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # description min -1 length
  describe "PATCH /posts/id" do
    it "returns 422 description min -1 length" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "abcde", description: "abcdefghi"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  # title description min - 1 length
  describe "PATCH /posts/id" do
    it "returns 422 title description min - 1 length" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      params = {title: "abcd", description: "abcdefghi"}
      patch "/api/v1/posts/#{post_json["id"]}", params: params, headers: headers
      expect(response.status).to eq(422)
    end
  end

  describe "DELETE /posts/id" do
    it "returns 204 deleted" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      delete "/api/v1/posts/#{post_json["id"]}", headers: headers
      expect(response.status).to eq(204)
    end
  end

  # user not found
  describe "DELETE /posts/id" do
    it "returns 404 user not found" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      headers = {username: "jake", password: "password"}
      delete "/api/v1/posts/#{post_json["id"]}", headers: headers
      expect(response.status).to eq(404)
    end
  end

  # unauthorized
  describe "DELETE /posts/id" do
    it "returns 401 user not authorized" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      headers = {username: user.username, password: "passwordkbjhafsbjka"}
      delete "/api/v1/posts/#{post_json["id"]}", headers: headers
      expect(response.status).to eq(401)
    end
  end

  # post not found
  describe "DELETE /posts/id" do
    it "returns 404 post not found" do
      params = {title: "fourth asbfkjsakjfasbkjfpost", description: "bodybfkaskjfbkjasfkjabsjkfk of fourthpost"}
      headers = {username: user.username, password: "password"}
      post "/api/v1/posts", params: params, headers: headers
      post = response.body
      post_json = JSON.parse(response.body)

      delete "/api/v1/posts/99999999999999999999999", headers: headers
      expect(response.status).to eq(404)
    end
  end

end