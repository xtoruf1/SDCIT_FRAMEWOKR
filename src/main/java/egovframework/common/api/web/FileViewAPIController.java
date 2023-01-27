package egovframework.common.api.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.common.auth.service.RestApiManager;
import egovframework.common.util.PropertyUtil;
import egovframework.common.util.StringUtil;

@Controller
public class FileViewAPIController {
	private static final Logger LOGGER = LoggerFactory.getLogger(FileViewAPIController.class);
	
	@RequestMapping(value = "/api/fileViewer.do")
	public ModelAndView getFileViewer(HttpServletRequest request, @RequestParam Map<String,String> param) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		RestApiManager restApi = new RestApiManager();
		String viewerUrl = PropertyUtil.getProperty("globals.fileViewerUrl");
		
		String fileUrl = StringUtil.nullCheck(param.get("file_url"));
		if (StringUtil.isNotEmpty(fileUrl)) {
			fileUrl = fileUrl.replaceAll("&amp;", "&");
		}
		
		param.put("file_url", fileUrl);
		
		String result = restApi.postResponseString(viewerUrl, param);
		
		LOGGER.debug("리턴 스트링값 = {}", result);
		
        JSONParser parser = new JSONParser();
		JSONObject obj = (JSONObject) parser.parse(result);
		
		mav.addObject("result", obj);
		
		mav.setViewName("jsonView");
		
		return mav;
	}
	
	@SuppressWarnings("rawtypes")
	public static String getHttpForm(String strUrl, Map<String,Object> param) {
		String httpResult = "";
		
		try {
            URL url = new URL(strUrl);
            
            HttpURLConnection http = (HttpURLConnection) url.openConnection(); 
            http.setDefaultUseCaches(false);
            http.setDoInput(true); 
            http.setDoOutput(true);  
            http.setRequestMethod("POST");
            http.setRequestProperty("content-type", "application/x-www-form-urlencoded");
            
            StringBuffer buffer = new StringBuffer();
            
            if (param != null) {
                Set key = param.keySet();
                
                for (Iterator iterator = key.iterator(); iterator.hasNext();) {
                    String keyName = (String) iterator.next();
                    String valueName = (String) param.get(keyName);
                    buffer.append(keyName).append("=").append(URLEncoder.encode(valueName, "UTF-8")).append("&");
                }
                
                buffer.append("1=1");
            }
            
            OutputStreamWriter outStream = new OutputStreamWriter(http.getOutputStream(), "UTF-8");
            PrintWriter writer = new PrintWriter(outStream);
            writer.write(buffer.toString());
            writer.flush();
            
            InputStreamReader tmp = new InputStreamReader(http.getInputStream(), "UTF-8");
            BufferedReader reader = new BufferedReader(tmp);
            StringBuilder builder = new StringBuilder();
            
            String str;
            while ((str = reader.readLine()) != null) {
            	builder.append(str + "\n");
            }
            
            httpResult = builder.toString();
        } catch (MalformedURLException e) {
        	httpResult = "{\"message\": \"[ERROR 001]\", \"errorCode\": 700}";
        } catch (IOException e) {
        	httpResult = "{\"message\": \"[ERROR 002]\", \"errorCode\": 700}";
        }
		
		return httpResult;
	}	
}