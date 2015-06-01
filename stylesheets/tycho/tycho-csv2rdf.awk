BEGIN	{
	FS="[,]";
	printf("<?xml version=\"1.0\"?>\n<rdf:RDF xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\" xmlns:t=\"https://www.tycho.pitt.edu/\">\n");
	printf("<rdf:Description rdf:about=\"\">");
	}
(NR==1)	{
	printf("<dc:title>%s</dc:title>\n",$0);
	next;
	}
(NR==2)	{
	printf("<dc:description>%s</dc:description>\n",$0);
	next;
	}

/^"YEAR"/	{
	printf("</rdf:Description>");
	n_states = split($0,states);
	for(i=3;i<= NF;++i)
		{
		gsub(/"/,"",states[i]);
		if(length(states[i])==0) continue;
		label = states[i];
		gsub(/ /,"_",states[i]);
		printf("<t:State rdf:about=\"https://www.tycho.pitt.edu/state/%s\"><dc:title>%s</dc:title></t:State>\n", states[i],label);
		}
	next;
	}
	
	{
	for(i=3;i<= NF;++i)
		{
		if($i=="-") continue;
		years[$1]++;
		printf("<t:Data><t:state rdf:resource=\"https://www.tycho.pitt.edu/state/%s\"/><t:year rdf:resource=\"https://www.tycho.pitt.edu/year/%s\"/><t:week>%s</t:week><t:count>%s</t:count></t:Data>\n",
			states[i],$1,$2,$i);
		}
	}

END	{
	for(year in years)
		{
		printf("<t:Year rdf:about=\"https://www.tycho.pitt.edu/year/%s\"><dc:title>%s</dc:title></t:Year>\n",year,year);
		}
	printf("</rdf:RDF>\n");
	}
