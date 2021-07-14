FNAME = ../DiscreteTFDs_v0.8_`date +%d%b%y`.tar
FNAME2 = DTFDsv08.zip

dist:
	tar -C .. -cf $(FNAME) DiscreteTFDs --exclude=*~
	gzip -c $(FNAME) > $(FNAME).gz
	compress $(FNAME)
	cd ..; zip -q -r -l $(FNAME2) DiscreteTFDs -x \*~
	#
	# Have you updated this file, Contents.m, Changes, and DTFDPath.m?
	#

clean:
	rm -f DiscreteTFDs/*~ DiscreteTFDs/*/*~ core
