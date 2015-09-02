package com.github.lindenb.xslt.img;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.Base64;
import java.util.Iterator;
import java.util.logging.Logger;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;

import org.apache.xalan.extensions.ExpressionContext;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.github.lindenb.xslt.AbstractXalanExtension;

public class Image extends AbstractXalanExtension
	{
	private static final Logger LOG=Logger.getGlobal();
	
	
	public Object info(final ExpressionContext context,String src)
		{
		return info(context,src,1.0);
		}
	
	public Object info(final ExpressionContext context,String src,double scale)
		{
		return info(context,src,true,scale);
		}
	
	
	
	public Object info(final ExpressionContext context,String src,boolean download,double scale)
		{
		final Document dom = getDomFactory();
		final Element img=dom.createElement("image");
		img.setAttribute("src", String.valueOf(src));
		URL url;
		 InputStream istream = null;
		try {
			url=new URL(src);
			
			LOG.info("Downloading "+src);
	        istream = url.openStream();
	        final ImageInputStream iis= ImageIO.createImageInputStream(istream);
	        Iterator<ImageReader> imageReaders = ImageIO.getImageReaders(iis);
	        if(!imageReaders.hasNext())
	        	{
	        	img.setAttribute("bad", "No reader found");
	        	return img;
	        	}
	        while (imageReaders.hasNext()) {
	            ImageReader reader = (ImageReader) imageReaders.next();
	            img.setAttribute("format", reader.getFormatName());
	            try {
	            	reader.setInput(iis);
	            	img.setAttribute("width",String.valueOf(reader.getWidth(0)) );
	            	img.setAttribute("height",String.valueOf(reader.getHeight(0)) );
	            	img.setAttribute("aspect-ratio",String.valueOf(reader.getAspectRatio(0)) );
	            	
	            	if(download)
	            		{
	            		BufferedImage pict =reader.read(0);
	            		ByteArrayOutputStream os = new ByteArrayOutputStream();
	            		
	            		ImageIO.write(pict, reader.getFormatName(), os);
	            		os.flush();
	            		final Element base64=dom.createElement("base64");
	            		img.appendChild(base64);
	            		base64.appendChild(dom.createTextNode(Base64.getEncoder().encodeToString(os.toByteArray())));
	            		}
	            	break;
				} finally
					{
					reader.dispose();
					}
	        	}
	      
		} catch (Exception e) {
			LOG.warning(String.valueOf(e.getMessage()));
			img.setAttribute("bad", String.valueOf(e.getMessage()));
			}
		finally
			{
			if(istream!=null) try {istream.close(); } catch(Exception err){}
			}
		return img;
		}
}
