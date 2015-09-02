package com.github.lindenb.xslt;

import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.xml.utils.WrappedRuntimeException;
import org.w3c.dom.Document;


public abstract class AbstractXalanExtension
	{
	private Document nodeFactory=null;
	protected AbstractXalanExtension()
		{
		}
	
	protected Document getDomFactory()
		{
		try {
			if(this.nodeFactory==null)
				{
		         DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		         dbf.setNamespaceAware(true);
		         this.nodeFactory = dbf.newDocumentBuilder().newDocument();
				}
			return this.nodeFactory;
		} catch (Exception e) {
			throw new WrappedRuntimeException(e);
			}
		}
	
	}
