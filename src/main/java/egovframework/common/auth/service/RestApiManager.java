package egovframework.common.auth.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.http.Consts;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class RestApiManager {
	private static final Logger LOGGER = LoggerFactory.getLogger(RestApiManager.class);
	
	/**
	 * Rest API 실행(POST)
	 * @param apiUrl 호출 URL
	 * @param param 파라메터값
	 * @param header 해더설정값
	 * @return 
	 * @throws Exception
	 */
	public String postResponseString(String apiUrl, Map<String,String> param, Map<String,String> header) throws Exception {
		String responseString = "";
		
		try {
			HttpPost httpPost = new HttpPost(apiUrl);
			
			if (header != null && header.size() > 0) {
				for (Map.Entry<String, String> map :header.entrySet()) {
					httpPost.setHeader(map.getKey(),map.getValue());
				}
			}
			
			if (param != null && param.size() > 0) {
				List<NameValuePair> parameters = new ArrayList<NameValuePair>();
				for (Map.Entry<String, String> map :param.entrySet()) {
					parameters.add(new BasicNameValuePair(map.getKey(),map.getValue()));
		        }
				
				httpPost.setEntity(new UrlEncodedFormEntity(parameters, Consts.UTF_8));
			}
			
			// HttpClient 생성
			HttpClient httpClient = HttpClientBuilder.create().build();			
			HttpResponse response = httpClient.execute(httpPost);
			
			if (response.getStatusLine().getStatusCode() == 200) {
				responseString = EntityUtils.toString(response.getEntity());	
			} else {
				String errMsg = "response is error : " + response.getStatusLine().getStatusCode();
				
				LOGGER.debug(errMsg);
				
				throw new Exception(errMsg);
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			throw new Exception(e);
		}
		
		return responseString;
	}
	
	/**
	 * Rest API 실행(POST)
	 * @param apiUrl 호출 URL
	 * @param param 파라메터값
	 * @return 
	 * @throws Exception
	 */
	public String postResponseString(String apiUrl, Map<String,String> param) throws Exception {
		return	postResponseString(apiUrl, param, null);
	}
	
	/**
	 * Rest API 실행(POST)
	 * @param apiUrl 호출 URL
	 * @param param 파라메터값
	 * @param header 해더설정값
	 * @return
	 * @throws Exception
	 */
	public JSONObject postResponseJson(String apiUrl, Map<String,String> param, Map<String,String> header) throws Exception {
		JSONObject jsonObject = null;
		try {
			String s = postResponseString(apiUrl, param, header);
			JSONParser jsonParser = new JSONParser();
			jsonObject = (JSONObject)jsonParser.parse(s);
		} catch (Exception e) {
			e.printStackTrace();
			
			throw new Exception(e);
		}
		
		return jsonObject;
	}
	
	/**
	 * Rest API 실행(POST)
	 * @param apiUrl 호출 URL
	 * @param param 파라메터값
	 * @return
	 * @throws Exception
	 */
	public JSONObject postResponseJson(String apiUrl, Map<String,String> param) throws Exception {
		return postResponseJson(apiUrl, param, null);
	}
	
	/**
	 * Rest API 실행(GET)
	 * @param apiUrl 호출 URL
	 * @param param 파라메터값
	 * @return
	 * @throws Exception
	 */
	public String getResponseString(String apiUrl, Map<String,String> param) throws Exception {
		String responseString = "";
		
		try {
			String uri = apiUrl;
			
			if (param != null && param.size() > 0) {
				uri	= uri + getQueryString(param);
			}
			
			HttpGet httpGet = new HttpGet(uri);
			// HttpClient 생성
			HttpClient httpClient = HttpClientBuilder.create().build();
			HttpResponse response = httpClient.execute(httpGet);
			
			if (response.getStatusLine().getStatusCode() == 200) {
				responseString =	EntityUtils.toString(response.getEntity());
			} else {
				String errMsg = "response is error : " + response.getStatusLine().getStatusCode();
				
				LOGGER.error(errMsg);
				
				throw new Exception(errMsg);
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			throw new Exception(e);
		}
		
		return responseString;
	}
	
	/**
	 * Rest API 실행(GET)
	 * @param apiUrl 호출 URL
	 * @param param 파라메터값
	 * @return
	 * @throws Exception
	 */
	public JSONObject getResponseJson(String apiUrl, Map<String,String> param) throws Exception {
		JSONObject jsonObject = null;
		
		try {
			String responseString = getResponseString(apiUrl, param);
			JSONParser jsonParser = new JSONParser();
			jsonObject = (JSONObject)jsonParser.parse(responseString);
		} catch (Exception e) {
			e.printStackTrace();
			
			throw new Exception(e);
		}
		
		return jsonObject;
	}
	
	/**
	 * Map to parameter String change
	 * @param map
	 * @return
	 */
	public String getQueryString(Map<String,String> map) {
		StringBuffer sb = new StringBuffer();
		
		int	i = 0;
		
		String value = "";
		
		for (Map.Entry<String, String> entry :map.entrySet()) {
			value = "";
			value = entry.getKey() + "=" + entry.getValue();
			
			if (i == 0) {
				sb.append("?" + value);
			} else {
				sb.append("&" + value);
			}
			
			i++;
		}
		
		LOGGER.error("sb.toString()[" + sb.toString() + "]");
		
		return sb.toString();
	}

	public JSONObject postJsonBodyResponseJson(String apiUrl, String jsonParam) throws Exception {
		JSONObject jsonObject;
		
		try {
			HttpPost httpPost = new HttpPost(apiUrl);
			httpPost.setHeader("Content-Type", "application/json");

			StringEntity param = new StringEntity(jsonParam, "UTF-8");
			httpPost.setEntity(param);
			
			LOGGER.info("API request: {}", jsonParam);
			
			// HttpClient 생성
			HttpClient httpClient = HttpClientBuilder.create().build();
			HttpResponse response = httpClient.execute(httpPost);
			
			if (response.getStatusLine().getStatusCode() == 200) {
				String responseString =	EntityUtils.toString(response.getEntity());
				
				LOGGER.info("API response: {}", responseString);
				
				JSONParser jsonParser = new JSONParser();
				jsonObject = (JSONObject)jsonParser.parse(responseString);
			} else {
				String errMsg = "response is error : " + response.getStatusLine().getStatusCode();
				
				LOGGER.debug(errMsg);
				
				throw new Exception(errMsg);
			}
		} catch (Exception e) {
			e.printStackTrace();
			
			throw new Exception(e);
		}
		return jsonObject;
	}
}