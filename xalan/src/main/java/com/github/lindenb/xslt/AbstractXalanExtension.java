package com.github.lindenb.xslt;

import java.util.logging.Logger;

import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.xml.utils.WrappedRuntimeException;
import org.w3c.dom.Document;


public abstract class AbstractXalanExtension
	{
	protected static final Logger LOG=Logger.getGlobal();

	private final static String BASE64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

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
	protected String encodeBase64(byte data[])
		{
		try	{
		final StringBuilder sb=new StringBuilder();
		char output[] = new char[4];
		int restbits = 0;
		int c;
		int nFill=0;
		
		for(int i=0;i< data.length;++i)
			{
			c=data[i];
			int ic = ( c >= 0 ? c : (c & 0x7F) + 128);
			//array3[nFill]=(byte)ic;
		   
		    switch (nFill)
		        {	
		        case 0:
		        	{
		        	output[nFill] = BASE64.charAt(ic >>> 2);
		            restbits = ic & 0x03;
		            nFill++;
		            break;
		        	}
		       case 1:
		    	    {
		    		output[nFill] = BASE64.charAt((restbits << 4) | (ic >>> 4));
		    	    restbits = ic & 0x0F;
		    	    nFill++;
		            break;
		    	    }
		       case 2:
		    	   	{
		    	   	output[nFill  ] = BASE64.charAt((restbits << 2) | (ic >>> 6));
		    	   	output[nFill+1] = BASE64.charAt(ic & 0x3F);
		            sb.append(new String(output));
		            nFill=0;
		            break;
		    	   	}
		        }
			} // for
		
			/* final */
			switch (nFill)
			{    case 1:
		         	 output[1] = BASE64.charAt((restbits << 4));
		             output[2] = output[3] = '=';
		             sb.append(new String(output));
		             break;
		         case 2:
		         	 output[2] = BASE64.charAt((restbits << 2));
		             output[3] = '=';
		             sb.append(new String(output));
		             break;
			}
			return sb.toString();
			}
		catch (Exception e) {
			throw new WrappedRuntimeException(e);
			}
		}
	}
