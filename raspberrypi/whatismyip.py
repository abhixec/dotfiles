#!/usr/bin/python

# Author: Abhinav

import urllib2
from BeautifulSoup import BeautifulSoup as bs
if __name__ == "__main__":
  req=urllib2.Request(url="http://whatsmyip.net")
  r=urllib2.urlopen(req)
  data=r.read()
  #print data
  soup=bs(data)
  #print soup.prettify()
  #print soup.findAll('input')
  #for i in soup.findAll('input'):
  print soup.findAll('input')[0]['value']
  r.close()
