package com.github.lindenb.xslt.img;

import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.util.Iterator;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;
import javax.imageio.stream.ImageInputStream;
import javax.xml.namespace.QName;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.events.Attribute;
import javax.xml.stream.events.StartElement;
import javax.xml.stream.events.XMLEvent;

import org.apache.xalan.extensions.ExpressionContext;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.github.lindenb.xslt.AbstractXalanExtension;

public class Image extends AbstractXalanExtension
	{
	
	
	public Object info(final ExpressionContext context,String src)
		{
		return info(context,src,"");
		}
		
	
	public Object info(final ExpressionContext context,String src,String transform)
		{	
		final Document dom = getDomFactory();
		final Element img=dom.createElement("image");
		img.setAttribute("src", String.valueOf(src));
		img.setAttribute("title", String.valueOf(src));
		URL url;
		 InputStream istream = null;
		try {
			if( src.startsWith("https://commons.wikimedia.org/wiki/File:"))
				{
				
				}
			else if( src.startsWith("https://www.flickr.com/photos/") ||
			    src.startsWith("http://www.flickr.com/photos/")
			    )
				{
				int i=src.indexOf("photos");
				String tokens[]=src.substring(i).split("[/]");
				if(tokens.length<3)
					{
					img.setAttribute("bad", "Bad flickr URL");
		        	return img;
					}
				String photo_id=tokens[2];
				String api_key=System.getProperty("flickr.api.key");
				
				if(api_key==null || api_key.isEmpty())
					{
					img.setAttribute("bad", "flickr.api.key not defined");
					LOG.warning("jvm -Dflickr.api.key undefined");
		        	return img;
					}
				String api_url="https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key="
						+api_key+ "&format=rest&photo_id="+
						photo_id
						;
				src=null;
				XMLInputFactory xmlInputFactory = XMLInputFactory.newInstance();
				xmlInputFactory.setProperty(XMLInputFactory.IS_NAMESPACE_AWARE, Boolean.FALSE);
				xmlInputFactory.setProperty(XMLInputFactory.IS_COALESCING, Boolean.TRUE);
				xmlInputFactory.setProperty(XMLInputFactory.IS_REPLACING_ENTITY_REFERENCES, Boolean.TRUE);
				InputStream in=new URL(api_url).openStream();
				XMLEventReader r= xmlInputFactory.createXMLEventReader(in);
				while(r.hasNext())
					{
					XMLEvent evt=r.nextEvent();
					if(evt.isStartElement())
						{
						StartElement e=evt.asStartElement();
						String name=e.getName().getLocalPart();
						if(name.equals("title"))
							{
							img.setAttribute("title", r.getElementText());
							}
						else if(name.equals("photo") && src==null)
							{
							Attribute att=null;
							att=e.getAttributeByName(new QName("farm"));
							String farm= (att==null?"":att.getValue());
							att=e.getAttributeByName(new QName("server"));
							String server=(att==null?"":att.getValue());
							att=e.getAttributeByName(new QName("secret"));
							String secret=(att==null?"":att.getValue());
							
							if(farm.isEmpty() || server.isEmpty() || secret.isEmpty())
								{
								LOG.warning("cannot get info");
					        	return img;
								}
							
							src="http://farm"+farm+".staticflickr.com/"+server+"/"+photo_id+"_"+secret+".jpg";
						
							}
						}
					}
				r.close();
				in.close();
				if(src==null)
					{
					img.setAttribute("bad", "cannot get info");
					LOG.warning("cannot get info");
		        	return img;
					}
				}
		
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
	            img.setAttribute("format", reader.getFormatName().toLowerCase());
	            try {
	            	reader.setInput(iis);
	            	
	            	
	            		BufferedImage pict =reader.read(0);
	            		if(transform!=null)
	            			{
	            			pict = transform(pict,transform);
	            			}
		            	img.setAttribute("width",String.valueOf(pict.getWidth()) );
		            	img.setAttribute("height",String.valueOf(pict.getHeight()) );

	            		ByteArrayOutputStream os = new ByteArrayOutputStream();
	            		
	            		ImageIO.write(pict, reader.getFormatName(), os);
	            		os.flush();
	            		img.setAttribute("base64",this.encodeBase64(os.toByteArray()));
	            		
	            	break;
				} finally
					{
					reader.dispose();
					}
	        	}
	      
		} catch (Exception e) {
		e.printStackTrace();
			LOG.warning(String.valueOf(e.getMessage()));
			img.setAttribute("bad", String.valueOf(e.getMessage()));
			}
		finally
			{
			if(istream!=null) try {istream.close(); } catch(Exception err){}
			}
		return img;
		}
	private BufferedImage transform(BufferedImage img,String transforms)
		{
		if(transforms==null) return img;
		for(String transform:transforms.split("[;]"))
			{
			LOG.info("img "+img.getWidth()+" "+img.getHeight());
			if(transform.isEmpty()) continue;
			if(transform.startsWith("scale("))
				{
				int par=transform.indexOf(')');
				if(par==-1)
					{
					LOG.warning("bad transform :"+transform);
					return img;
					}
				String numbers[]=transform.substring(6,par).split("[,]");
				if(numbers.length==1)
					{
					
					double ratio=Double.parseDouble(numbers[0]);
					double w= img.getWidth()*ratio;
					double h= img.getHeight()*ratio;
					img=convert(img.getScaledInstance((int)w, (int)h, BufferedImage.SCALE_SMOOTH),img.getType());
					}
				else if(numbers.length==2)
					{
					double w= parse(numbers[0],img.getWidth());
					double h= parse(numbers[1],img.getHeight());
					
					img=convert(img.getScaledInstance((int)w, (int)h, BufferedImage.SCALE_SMOOTH),img.getType());
					}
				else
					{
					LOG.warning("bad transform :"+transform);
					return img;
					}
				}
			else if(transform.startsWith("clip("))
				{
				int par=transform.indexOf(')');
				if(par==-1)
					{
					LOG.warning("bad transform :"+transform);
					return img;
					}
				String numbers[]=transform.substring(5,par).split("[,]");
				if(numbers.length!=4)
					{
					LOG.warning("bad transform :"+transform);
					return img;
					}
				double x= (numbers[0].trim().isEmpty()?0:parse(numbers[0],img.getWidth()));
				double y= (numbers[1].trim().isEmpty()?0:parse(numbers[1],img.getHeight()));
				double w= parse(numbers[2],img.getWidth());
				double h= parse(numbers[3],img.getHeight());
				img=convert(img.getSubimage((int)x,(int)y,(int)w, (int)h),img.getType());
				}
			else if(transform.startsWith("flip-horizontal") || transform.startsWith("flip-vertical"))
				{
				boolean vertical=transform.contains("v");
				AffineTransform tx ;
				if(vertical)
					{
					tx = AffineTransform.getScaleInstance( 1,-1);
					tx.translate(0,-img.getHeight());
					
					}
				else
					{
					tx=AffineTransform.getScaleInstance(-1, 1);
					tx.translate(-img.getWidth(), 0);
					}
				AffineTransformOp op=new AffineTransformOp(tx, AffineTransformOp.TYPE_NEAREST_NEIGHBOR);
				img = op.filter(img, null);
				}
			else
				{
				LOG.warning("unknown transform :"+transform);
				return img;
				}
			}
		return img;
		}
	
	private BufferedImage convert(java.awt.Image img,int type)
		{
		BufferedImage bi = new BufferedImage(img.getWidth(null),img.getHeight(null), type);
		Graphics2D g=(Graphics2D)bi.getGraphics();
		g.drawImage(img,0,0,img.getWidth(null),img.getHeight(null),null);
		g.dispose();
		return bi;
		}
	private double parse(String numStr,double ref)
		{
		numStr=numStr.trim();
		if(numStr.isEmpty())
			{
			return ref;
			}
		else if(numStr.endsWith("%"))
			{
			double ratio=Double.parseDouble(numStr.substring(0,numStr.length()-1));
			return ref*(ratio/100.0);
			}
		else
			{
			return Double.parseDouble(numStr);
			}
		}
	
}
