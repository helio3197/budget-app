class RegistrationsController < Devise::RegistrationsController
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params.except(:remove_avatar))
    yield resource if block_given?
    if resource_updated
      current_user.avatar.purge if account_update_params[:remove_avatar]
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      # respond_with resource, location: after_update_path_for(resource)
      redirect_to root_path(ref: 'update_account'), notice: 'Your account has been updated successfully.'
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def destroy
    super do
      redirect_to root_path
      return
    end
  end
end
