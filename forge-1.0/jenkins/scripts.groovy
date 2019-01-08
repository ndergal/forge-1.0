import jenkins.model.*
import hudson.security.*
import hudson.model.User
import hudson.tasks.Mailer
def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
User u = hudsonRealm.createAccount("$log_in","$password")
instance.setSecurityRealm(hudsonRealm)
instance.save()
def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "$log_in")
strategy.add(Jenkins.ADMINISTER, "anonymous")
instance.setAuthorizationStrategy(strategy)
instance.save()
u.addProperty(new Mailer.UserProperty("$address"))
