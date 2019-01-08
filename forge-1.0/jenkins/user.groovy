import jenkins.model.*
import hudson.security.*
import hudson.model.User
import hudson.tasks.Mailer
def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
User u = hudsonRealm.createAccount("valilab","rootroot")
instance.setSecurityRealm(hudsonRealm)
instance.save()
def strategy = new GlobalMatrixAuthorizationStrategy()
strategy.add(Jenkins.ADMINISTER, "valilab")
strategy.add(Jenkins.ADMINISTER, "anonymous")
instance.setAuthorizationStrategy(strategy)
instance.save()
u.addProperty(new Mailer.UserProperty("admin@ign-forge.fr"))
