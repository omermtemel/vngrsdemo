class ContactsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @q = current_user.contacts.search(params[:q])                                                                         
    @contacts = @q.result(:distinct => true).order(:name).order(:lastname).paginate(:page => params[:page], 
                      :per_page => 10)
  end
  
  def create
    @contact = Contact.new( params[:contact] )
    @contact.user = current_user
    begin
      if @contact.save 
        redirect_to @contact, :notice => "Contact successfully added."
      else
        render :new, :notice => "Create faliure try again."
      end 
    rescue
      redirect_to contacts_path, :notice => "Something went wrong."
    end
  end
  
  def new
    @contact = Contact.new
  end
  
  def edit
    begin
      @contact = Contact.find(params[:id])
      unless @contact.user == current_user
        redirect_to contacts_url, :notice  => "You are not owner of this contact!!"
      end
    rescue
      redirect_to contacts_url, :notice =>  "Contact not found."
    end
  end
  
  def update
    @contact = Contact.find(params[:id])
    begin
      if @contact.update_attributes(params[:contact])
        redirect_to @contact, :notice => "Contact successfully updated."
      else
        render :edit, :notice =>  "Update failure try again."
      end
    rescue
      redirect_to contacts_url, :notice =>  "Something went wrong."
    end
  end
  
  def destroy
    begin
      @contact = Contact.find(params[:id])
      if @contact.user != current_user
        redirect_to contacts_url, :notice =>  "You are not owner of this contact!!" and return
      end
      if @contact.delete
        redirect_to :back, :notice =>  "Contact deleted successfully."
      else
        redirect_to :back, :notice =>  "Deletion is unsuccessful"
      end
    rescue
      redirect_to :back, :notice =>  "Something went wrong!!"
    end
  end
  
  def show
    begin
      @contact = Contact.find(params[:id])
      unless @contact.user == current_user
        redirect_to contacts_url, :notice  => "You are not owner of this contact!!"
      end
    rescue
            redirect_to contacts_url, :notice =>  "Contact not found."
    end
  end
  
  def upload
    require 'fileutils'
    begin
      Utilities.parse_and_insert_contacts(params['form']['file'].tempfile,current_user)
      redirect_to contacts_url, :notice => "Contacts were added successfully."
    rescue
      redirect_to contacts_url, :notice => "Something went wrong."
    end
  end
  
  def file_upload
  end 
end
