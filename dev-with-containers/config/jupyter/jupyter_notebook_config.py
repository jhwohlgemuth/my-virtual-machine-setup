#
# Jupyter Notebook
#
c.NotebookApp.ip = '*'
c.NotebookApp.port = 13337
c.NotebookApp.open_browser = False
c.NotebookApp.password = u'argon2:$argon2id$v=19$m=10240,t=10,p=8$bY5rSBCPqjXzzLckWsGTLg$vYg9lyo18FG1kskOrT6ShA'
c.NotebookApp.keyfile = u"/root/certs/my.key"
c.NotebookApp.certfile = u"/root/certs/my.pem"
c.NotebookApp.notebook_dir = "/root/dev/notebooks"
#
# Jupyter Lab
#
c.ServerApp.ip = '*'
c.ServerApp.port = 13337
c.ServerApp.open_browser = False
c.ServerApp.password = u'argon2:$argon2id$v=19$m=10240,t=10,p=8$bY5rSBCPqjXzzLckWsGTLg$vYg9lyo18FG1kskOrT6ShA'
c.ServerApp.keyfile = u"/root/certs/my.key"
c.ServerApp.certfile = u"/root/certs/my.pem"
c.ServerApp.root_dir = "/root/dev/notebooks"