package egovframework.common.web.context;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import egovframework.common.util.StringUtil;

public class Log4jdbcLog4j2ConfigListener implements ServletContextListener {
	public Log4jdbcLog4j2ConfigListener() {
		
	}
	
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		ServletContext sc = sce.getServletContext();
		String location = sc.getInitParameter("log4jdbcLog4j2ConfigLocation");
		
		if (!StringUtil.isEmpty(location)) {
			sc.log("Set System Property(log4jdbc.log4j2.properties.file) : " + location);
			
			// System Property 설정 : log4jdbc-log4j2 프로퍼티 경로 변경 설정
			System.setProperty("log4jdbc.log4j2.properties.file", location);
		} else {
			sc.log("Not Found 'log4jdbcLog4j2ConfigLocation' Parameter");
		}
	}
	
	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		
	}
}