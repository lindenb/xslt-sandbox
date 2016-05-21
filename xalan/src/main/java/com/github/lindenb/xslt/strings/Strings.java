package com.github.lindenb.xslt.strings;

import org.apache.xalan.extensions.ExpressionContext;


import com.github.lindenb.xslt.AbstractXalanExtension;

public class Strings extends AbstractXalanExtension
	{
	public Object strcmp(final ExpressionContext context,final String s1,final String s2)
		{	
		if(s1==null && s2==null) return 0;
		if(s1==null && s2!=null) return -1;
		if(s1!=null && s2==null) return 1;
		return s1.compareTo(s2);
		}
	}
