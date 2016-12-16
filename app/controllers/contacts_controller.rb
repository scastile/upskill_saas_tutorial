class ContactsController < ApplicationController
  
  # GET request to /contast-us
  # Show new contact form
  def new
    @contact = Contact.new
  end
  
  
  #POST request /contacts
  def create
    #Mass assignment of form fields into Contact object
    @contact = Contact.new(contact_params)
    if @contact.save
      # Store form fields via parameters, into variables
      name = params[:contact][:name]
      email = params[:contact][:email]
      body = params[:contact][:comments]
      # Plug variables into Contact Mailer
      # email method and send email
      ContactMailer.contact_email(name, email, body).deliver
      # Store success message in flash hash
      # and direct to new action
      flash[:success] = "Message sent."
      redirect_to new_contact_path
    else
      # If Contact object doesn't save,
      # store errors in flash has,
      # and direct to the new action
      flash[:danger] = @contact.errors.full_messages.join(", ")
      redirect_to new_contact_path
    end
  end
  
  private
  # To collect data from form, we need to use
  # strong patameters and whitelist the form fields
    def contact_params
      params.require(:contact).permit(:name, :email, :comments)
    end
end