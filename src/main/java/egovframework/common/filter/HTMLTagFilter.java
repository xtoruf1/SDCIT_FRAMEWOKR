package egovframework.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HTMLTagFilter implements Filter {
	private static final Logger LOGGER = LoggerFactory.getLogger(HTMLTagFilter.class);
	
	@SuppressWarnings("unused")
	private FilterConfig config;

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		/*
		if (request.getContentType() != null && request.getContentType().equalsIgnoreCase("application/json; charset=utf-8")) {
			chain.doFilter(new JSONBodyHTMLTagFilterRequestWrapper((HttpServletRequest)request), response);
		} else {
			chain.doFilter(new HTMLTagFilterRequestWrapper((HttpServletRequest)request), response);
		}
		*/
		
		if (this.checkDoFilter(request)) {
			chain.doFilter(new HTMLTagFilterRequestWrapper((HttpServletRequest)request), response);
		} else {
			chain.doFilter(request, response);
		}
	}

	private boolean checkDoFilter(ServletRequest request) {
		return false;
	}

	public void init(FilterConfig config) throws ServletException {
		this.config = config;
	}

	public void destroy() {
		LOGGER.debug("Call Destroy");
	}
}