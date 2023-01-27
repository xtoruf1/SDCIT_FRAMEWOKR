package egovframework.common.logger;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
 
@Aspect
public class LoggerAspect {
	private static final Logger LOGGER = LoggerFactory.getLogger(LoggerAspect.class);
	
	static String name = "";
	static String type = "";
     
    @Around("execution(* egovframework..web.*Controller.*(..)) or execution(* egovframework..service.*Service.*(..)) or execution(* egovframework..dao.*DAO.*(..))")
    public Object logPrint(ProceedingJoinPoint joinPoint) throws Throwable {
        type = joinPoint.getSignature().getDeclaringTypeName();
        
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();   
        String uri = (String)request.getAttribute("javax.servlet.error.request_uri");
        String sign = (String)joinPoint.getSignature().getName();
        
        if (type.indexOf("Controller") > -1) {
        	name = "[Controller] ";
        } else if (type.indexOf("Service") > -1) {
        	name = "[Service] ";
        } else if (type.indexOf("DAO") > -1) {
        	name = "[DAO] ";
        }
        
        if (!(sign.contains("error") && uri.endsWith("/null"))) {
        	LOGGER.debug(name + "[" + type + "." + sign + "()]");
        }

        return joinPoint.proceed();
    }
}