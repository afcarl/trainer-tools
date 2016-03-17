#!/usr/bin/env python
import os
import sys
import yaml

def prettify(l):
    l = [ip.strip() for ip in l]
    ret = [ "node{}: {}".format(i+1, s) for (i, s) in zip(range(len(l)), l) ]
    return ret


with open(sys.argv[1]) as f:
    data = f.read()
SETTINGS = yaml.load(data)

SETTINGS['footer'] = SETTINGS['footer'].format(url=SETTINGS['url'])
globals().update(SETTINGS)

###############################################################################

ips = list(open("ips.txt"))

print(len(ips))
print(len(ips)%clustersize)
assert len(ips)%clustersize == 0

clusters = []

while ips:
    cluster = ips[:clustersize]
    ips = ips[clustersize:]
    clusters.append(cluster)

html = open("ips.html", "w")
html.write("<html><head><style>")
body = """
div {{ 
    float:left;
    border: 1px solid black;
    width: 28%;
    padding: 4% 2.5% 2.5% 2.5%;
    font-size: x-small;
    background-image: url("{IMG}");
    background-size: 15%;
    background-position-x: 50%;
    background-repeat: no-repeat;
}}
p {{
    margin: 0.5em 0 0.5em 0;
}}
.pagebreak {{
    page-break-before: always;
    clear: both;
    display: block;
    height: 8px;
}}
"""
img = SETTINGS['image']
body = body.format(IMG=img)

html.write(body)

html.write("</style></head><body>")
for i, cluster in enumerate(clusters):
    if i>0 and i%pagesize==0:
        html.write('<span class="pagebreak"></span>\n')
    html.write("<div>")
    html.write(blurb)
    for s in prettify(cluster):
        html.write("<li>%s</li>\n"%s)
    html.write("</ul></p>")
    html.write("<p>login=docker password=training</p>\n")
    html.write(footer)
    html.write("</div>")
html.close()


"""
SETTINGS_BASIC = dict(
    clustersize=1,
    pagesize=15,
    blurb="<p>Here is the connection information to your very own "
    "VM for this intro to Docker workshop. You can connect "
    "to the VM using your SSH client.</p>\n"
    "<p>Your VM is reachable on the following address:</p>\n",
    prettify=lambda x: x,
    footer="<p>You can find the last version of the slides at "
    "http://view.dckr.info/.</p>",
    )

SETTINGS_ADVANCED = dict(
    clustersize=5,
    pagesize=12,
    blurb="<p>Here is the connection information to your very own "
    "cluster for this orchestration workshop. You can connect "
    "to each VM with any SSH client.</p>\n"
    "<p>Your machines are:<ul>\n",
    prettify=lambda l: [ "node%d: %s"%(i+1, s) 
                         for (i, s) in zip(range(len(l)), l) ],
    footer="<p>You can find the last version of the slides on -&gt; "
    "http://container.training/</p>"
    )

SETTINGS = SETTINGS_BASIC
"""



"""
SETTINGS = dict(
    clustersize=int(os.environ.get("CLUSTER_SIZE", "5")),
    pagesize=int(os.environ.get("PAGE_SIZE", 12)),
    backgroundimage=os.environ.get("BACKGROUND_IMAGE", "docker-nb.svg"),
    blurb="<p>Here is the connection information to your very own "
    "cluster for this Docker orchestration workshop. You can connect "
    "to the VM using your SSH client.</p>\n"
    "<p>Your VMs are reachable at the following addresses:</p>\n",
    prettify=lambda l: [ "node%d: %s"%(i+1, s) 
                         for (i, s) in zip(range(len(l)), l) ],
    footer="<p>You can find the last version of the slides at "
    "{}</p>".format(os.environ.get("SLIDES_URL", "http://container.training")),
    )
"""

