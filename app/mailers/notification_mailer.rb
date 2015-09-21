class NotificationMailer < ActionMailer::Base

  default from: "statuspageserver@gmail.com"

  def notification(user,component,status,username)
    @user = user
    @component = component
    @status = status
    @c_user = User.find_by_username(username)

    mail to: user.email, subject: @c_user.try(:emailsubjectformat)
  end

  def incidentNotification(user,component,incident,state,username,status)
    @user = user
    @component = component
    @state = state
    @status = status
    @incident = incident
    @c_user = User.find_by_username(username)

    mail to: user.email, subject: @c_user.try(:emailsubjectformat)
  end

  def errorMailReceive(sendto)
    mail to: sendto, subject: "Couldn't Update the Component"
  end

  def successMailComponentUpdate(sendto,comp)
    @component = comp
    mail to: sendto, subject: "Component Updated Successfully"
  end
end
