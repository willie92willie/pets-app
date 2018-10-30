require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/pet.db")
class Pet
  include DataMapper::Resource
  property :id, Serial
  property :name, Text
  property :emoji, Text
end
DataMapper.finalize.auto_upgrade!

get '/pets' do
  @pets = Pet.all
  erb :"pets/index"
end

get "/pets/new" do
  erb :"pets/new"
end  

post "/pets" do
  Pet.create({:name => params[:name], :emoji => params[:emoji]})
  redirect "/pets"
end

get"/pets/:id" do
  id = params["id"].to_i
  @pet = Pet.get(params["id"])
  erb :"pets/show"
end  

get "/pets/:id/edit" do
  @pet = Pet.get(params["id"])
  erb :"pets/edit"
end

patch "/pets/:id" do
  pet = Pet.get(params["id"])
  pet.update({:name => params[:name], :emoji => params[:emoji]})
  redirect "/pets"
  end

delete "/pets/:id" do
  pet = Pet.get(params["id"])
  pet.destroy
  redirect"/pets"
end