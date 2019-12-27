import groovy.json.*

def bash_script='/Users/johndoe/jenkins/list_dbtypes.sh'

def sout = new StringBuffer(), serr = new StringBuffer()
def cmd='sh ' + bash_script + ' ' + ActIP + ' ' + ActUser + ' ' + ActPass
def proc = cmd.execute()
proc.consumeProcessOutput(sout, serr)
proc.waitForOrKill(5000)

def slurper3 = new JsonSlurper()
def result3 = slurper3.parseText(sout.toString())

def list=[]
for (item in result3.result) {
   list.add (item.AppName)
}
return list