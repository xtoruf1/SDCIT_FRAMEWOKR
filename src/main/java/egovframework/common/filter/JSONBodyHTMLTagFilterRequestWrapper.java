package egovframework.common.filter;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import javax.servlet.ReadListener;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class JSONBodyHTMLTagFilterRequestWrapper extends HttpServletRequestWrapper {
	private byte[] b;

	public JSONBodyHTMLTagFilterRequestWrapper(HttpServletRequest request) throws IOException {
		super(request);
		
		b = getBody(request).getBytes("UTF-8");
	}

	public ServletInputStream getInputStream() throws IOException {
		final ByteArrayInputStream bis = new ByteArrayInputStream(b);
		
		return new ServletInputStreamImpl(bis);
	}

	class ServletInputStreamImpl extends ServletInputStream {
		private InputStream is;
		public ServletInputStreamImpl(InputStream bis){
			is = bis;
		}
		
		public int read() throws IOException {
			return is.read();
		}
		
		public int read(byte[] b) throws IOException {
			return is.read(b);
		}
		
		@Override
		public boolean isFinished() {
			return false;
		}
		
		@Override
		public boolean isReady() {
			return false;
		}
		
		@Override
		public void setReadListener(ReadListener readListener) {
		}
	}

	private static String getBody(HttpServletRequest request) {
		String body = null;
		StringBuilder stringBuilder = new StringBuilder();
		BufferedReader bufferedReader = null;
		try {
			InputStream inputStream = request.getInputStream();
			if (inputStream != null) {
				bufferedReader = new BufferedReader(new InputStreamReader(inputStream, "UTF-8"));
				char[] charBuffer = new char[128];
				int bytesRead = -1;
				while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
					stringBuilder.append(charBuffer, 0, bytesRead);
				}
			} else {
				stringBuilder.append("");
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		} finally {
			if (bufferedReader != null) {
				try {
					bufferedReader.close();
				} catch (IOException ex) {
					ex.printStackTrace();
				}
			}
		}
		
		body = escapeHtml(stringBuilder.toString());
		
		return body;
	}

	private static String escapeHtml(String body) {
		if (body == null) {
			return null;
		}
		
		StringBuffer strBuff = new StringBuffer();
		for (int i = 0; i < body.length(); i++) {
			char c = body.charAt(i);
			switch (c) {
				case '<' :
					strBuff.append("&lt;");
					
					break;
				case '>' :
					strBuff.append("&gt;");
					
					break;
				default :
					strBuff.append(c);
					
					break;
			}
		}
		
		body = strBuff.toString();
		
		return body;
	}
}