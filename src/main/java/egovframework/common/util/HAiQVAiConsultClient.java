package egovframework.common.util;

import org.springframework.stereotype.Component;

/**
 * AI 자문 API 호출
 * 대상 서버가 GCM 방식 사이퍼만 허용하는 문제로
 * 이미 사용하는 API 호출 방식은 사용불가.
 */
@Component
public class HAiQVAiConsultClient {
	/*
	private static final Logger logger = LoggerFactory.getLogger(HAiQVAiConsultClient.class);

	private static String cachedAuthCookie;
	*/
	
	private String host;
	private String userId;
	private String password;
	private String serviceUri;
	private String method;

	public HAiQVAiConsultClient() {}

	public HAiQVAiConsultClient(String host, String serviceUri, String method, String userId, String password) {
		this.host = host;
		this.serviceUri = serviceUri;
		this.userId = userId;
		this.password = password;
		this.method = method;
	}

	public String getHost() {
		return host;
	}
	
	public void setHost(String host) {
		this.host = host;
	}

	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPassword() {
		return password;
	}
	
	public void setPassword(String password) {
		this.password = password;
	}
	
	public String getServiceUri() {
		return serviceUri;
	}
	
	public void setServiceUri(String serviceUri) {
		this.serviceUri = serviceUri;
	}
	
	public String getMethod() {
		return method;
	}
	
	public void setMethod(String method) {
		this.method = method;
	}
	
	/*
	private int checkSessionStatus() throws KeyManagementException, NoSuchAlgorithmException, ClientProtocolException, IOException {
		int statusCode = HttpStatus.SC_MOVED_TEMPORARILY;
		
		CloseableHttpClient httpclient = null;

		try {			
			httpclient = HttpClientBuilder.create()
				.disableRedirectHandling()
				.setConnectionManager(getConnectionManager())
				.build();

			HttpGet httpGet = new HttpGet(getHost());

			httpGet.setHeader(new BasicHeader("Pargma", "no-cache"));
			httpGet.setHeader(new BasicHeader("Cache-Control", "no-cache"));
			
			if (cachedAuthCookie != null) {
				httpGet.setHeader(new BasicHeader("Cookie", "authservice_session=" + cachedAuthCookie));
			}
			
			CloseableHttpResponse response = null;
			
			try {
				response = httpclient.execute(httpGet);
				statusCode = response.getStatusLine().getStatusCode();
				logger.debug("statusCode of checkSessionStatus : {}", statusCode);
				
				// 200: 세션 유효 (HttpStatus.SC_OK)
				// 302: 세션 맺지 않아서 authCookie null인 경우 (HttpStatus.SC_MOVED_TEMPORARILY)
				// 504: 세션 타임아웃 (HttpStatus.SC_GATEWAY_TIMEOUT)
			} finally {
				if (response != null) {
					response.close();
				}	
			}
		} finally {
			if (httpclient != null) {
				httpclient.close();
			}	
		}

		return statusCode;
	}
	*/

	/*
	private String getDexLdapLocation() throws KeyManagementException, NoSuchAlgorithmException, ClientProtocolException, IOException {
		String dexLdapLocation = null;

		CloseableHttpClient httpclient = null;

		try {
			// REDIRECT 허용
			httpclient = HttpClientBuilder.create().setRedirectStrategy(new LaxRedirectStrategy())
				.setConnectionManager(getConnectionManager()).build();

			HttpGet httpGet = new HttpGet(getHost());

			httpGet.setHeader(new BasicHeader("Pargma", "no-cache"));
			httpGet.setHeader(new BasicHeader("Cache-Control", "no-cache"));

			CloseableHttpResponse response = null;
			
			try {
				response = httpclient.execute(httpGet);
				int statusCode = response.getStatusLine().getStatusCode();
				
				logger.debug("statusCode of getDexLdapLocation : {}", statusCode);
				
				if (statusCode != HttpStatus.SC_OK) {
					throw new RuntimeException(this.getClass().getName() + "Error status in getDexLdapLocation, statusCode : " + statusCode);
				}
				
				String responseText = EntityUtils.toString(response.getEntity(), "UTF-8");
				
				if (responseText == null || responseText.trim().length() == 0 || responseText.indexOf("window.location.href") < 0) {
					throw new RuntimeException(this.getClass().getName() + "Unknown result in getDexLdapLocation, result : " + responseText);
				}

				int startPos = responseText.indexOf('"', responseText.indexOf("window.location.href") + 1);
				int endPos = responseText.indexOf('"', startPos + 1);
				dexLdapLocation = responseText.substring(startPos + 1, endPos);
			} finally {
				if (response != null) {
					response.close();
				}	
			}
		} finally {
			if (httpclient != null) {
				httpclient.close();
			}	
		}

		return dexLdapLocation;
	}
	*/
	
	/*
	private String createAuthLDAP(String dexLdapLocation) throws KeyManagementException, NoSuchAlgorithmException, ClientProtocolException, IOException {
		String approvalLocation = null;

		CloseableHttpClient httpclient = null;

		try {
			httpclient = HttpClientBuilder.create()
				.disableRedirectHandling()
				.setConnectionManager(getConnectionManager()).build();
			
			String targetLocation = getHost() + dexLdapLocation;

			logger.debug("targetLocation in createAuthLDAP : {}", targetLocation);

			HttpPost httpPost = new HttpPost(targetLocation);

			httpPost.setHeader(new BasicHeader("Pargma", "no-cache"));
			httpPost.setHeader(new BasicHeader("Cache-Control", "no-cache"));

			CloseableHttpResponse response = null;
			
			try {
				// POST로 넘기는 key, value 파라메터
				List<NameValuePair> nvParams = new ArrayList<NameValuePair>();
				nvParams.add(new BasicNameValuePair("login", getUserId()));
				nvParams.add(new BasicNameValuePair("password", getPassword()));
				httpPost.setEntity(new UrlEncodedFormEntity(nvParams, "UTF-8"));
				
				logger.debug("Executing request in createAuthLDAP : {}", httpPost.getRequestLine());

				response = httpclient.execute(httpPost);
				int statusCode = response.getStatusLine().getStatusCode();

				// 303
				if (statusCode != HttpStatus.SC_SEE_OTHER) {
					throw new RuntimeException(this.getClass().getName() + "Error status in createAuthLDAP, statusCode : " + statusCode);
				}
				
				logger.debug("statusCode of createAuthLDAP : {}", statusCode);
				
				Header locHeader = response.getFirstHeader("location");
				
				if (locHeader == null) {
					throw new RuntimeException(this.getClass().getName() + "location is null in createAuthLDAP");
				}
				
				logger.debug("redirect location in createAuthLDAP : {}", locHeader.getValue());
				
				approvalLocation = locHeader.getValue();				
			} finally {
				if (response != null) {
					response.close();
				}	
			}
		} finally {
			if (httpclient != null) {
				httpclient.close();
			}	
		}

		return approvalLocation;
	}
	*/
	
	/*
	private String sendApproval(String approvalLocation) throws KeyManagementException, NoSuchAlgorithmException, ClientProtocolException, IOException {
		String oidcLocation = null;

		CloseableHttpClient httpclient = null;

		try {			
			httpclient = HttpClientBuilder.create()
				.disableRedirectHandling()
				.disableCookieManagement()
				.setConnectionManager(getConnectionManager()).build();
			
			String targetLocation = getHost() + approvalLocation;

			logger.debug("targetLocation in sendApproval : ", targetLocation);

			HttpGet httpGet = new HttpGet(targetLocation);

			httpGet.setHeader(new BasicHeader("Pargma", "no-cache"));
			httpGet.setHeader(new BasicHeader("Cache-Control", "no-cache"));

			CloseableHttpResponse response = null;
			
			try {
				response = httpclient.execute(httpGet);
				int statusCode = response.getStatusLine().getStatusCode();
				
				logger.debug("statusCode of sendApproval : {}", statusCode);
				
				// 303
				if (statusCode != HttpStatus.SC_SEE_OTHER) {
					throw new RuntimeException(this.getClass().getName() + "Error status in sendApproval, statusCode : " + statusCode);
				}

				Header locHeader = response.getFirstHeader("location");
				
				if (locHeader == null) {
					throw new RuntimeException(this.getClass().getName() + "location is null in sendApproval");
				}
				
				logger.debug("redirect location in sendApproval : {}", locHeader.getValue());
				
				oidcLocation = locHeader.getValue();
			} finally {
				if (response != null) {
					response.close();
				}	
			}
		} finally {
			if (httpclient != null) {
				httpclient.close();
			}				
		}

		return oidcLocation;
	}
	*/
	
	/*
	private String sendOidc(String oidcLocation) throws KeyManagementException, NoSuchAlgorithmException, ClientProtocolException, IOException {
		String authCookie = null;

		CloseableHttpClient httpclient = null;

		try {			
			httpclient = HttpClientBuilder.create()
				.disableRedirectHandling()
				.disableCookieManagement()
				.setConnectionManager(getConnectionManager()).build();
			
			String targetLocation = getHost() + oidcLocation;

			logger.debug("targetLocation in sendOidc : ", targetLocation);

			HttpGet httpGet = new HttpGet(targetLocation);

			httpGet.setHeader(new BasicHeader("Pargma", "no-cache"));
			httpGet.setHeader(new BasicHeader("Cache-Control", "no-cache"));

			CloseableHttpResponse response = null;
			
			try {
				response = httpclient.execute(httpGet);
				int statusCode = response.getStatusLine().getStatusCode();
				
				logger.debug("statusCode of sendOidc : {}", statusCode);
				
				// 302
				if (statusCode != HttpStatus.SC_MOVED_TEMPORARILY) {
					throw new RuntimeException(this.getClass().getName() + "Error status in sendOidc, statusCode : " + statusCode);
				}
				
			    Header[] headers = response.getHeaders("set-cookie");
			    if (headers == null || headers.length == 0) {
					// throw new HAiQVAuthException("Not found set-cookie header in sendOidc");
			    }
			    
				if (headers != null && headers.length > 0) {
					for (Header header : headers) {
						HeaderElement[] heArray = header.getElements();
						if (heArray != null && heArray.length > 0) {
							for (HeaderElement he : heArray) {
								if (he.getName().equals("authservice_session")) {
									authCookie = he.getValue();
								}
							}
						}
					}
				}
				
				if (authCookie == null) {
					throw new RuntimeException(this.getClass().getName() + "Not found authservice_session value in sendOidc");
				}
			} finally {
				if (response != null) {
					response.close();
				}					
			}
		} finally {
			if (httpclient != null) {
				httpclient.close();
			}				
		}

		return authCookie;
	}
	*/
	
	/*
	private String getAuthCookie() throws KeyManagementException, NoSuchAlgorithmException, ClientProtocolException, IOException {
		int statusCode = checkSessionStatus();
		
		if (
			statusCode != HttpStatus.SC_OK 
			&& statusCode != HttpStatus.SC_MOVED_TEMPORARILY
			&& statusCode != HttpStatus.SC_GATEWAY_TIMEOUT
		) {
			throw new RuntimeException(this.getClass().getName() + "Error status in checkSessionStatus, statusCode : " + statusCode);
		}
		
		// 200: 세션 유효 (HttpStatus.SC_OK)
		// 302: 세션 맺지 않아서 authCookie null인 경우 (HttpStatus.SC_MOVED_TEMPORARILY)
		// 504: 세션 타임아웃 (HttpStatus.SC_GATEWAY_TIMEOUT)
		
		if (statusCode != HttpStatus.SC_OK) {
			// 세션 생성
			String dexLdapLocation = getDexLdapLocation();
			logger.debug("dexLdapLocation : {}", dexLdapLocation);
			
			String approvalLocation = createAuthLDAP(dexLdapLocation);
			logger.debug("approvalLocation : {}", approvalLocation);
			
			String oidcLocation = sendApproval(approvalLocation);
			logger.debug("oidcLocation : {}", oidcLocation);
			
			String authCookie = sendOidc(oidcLocation);
			logger.debug("authCookie : {}", authCookie);
			
			cachedAuthCookie = authCookie;
		}
		
		return cachedAuthCookie;
	}
	*/

	/*
	public String sendAiConsult(String jsonString) throws KeyManagementException, NoSuchAlgorithmException, IOException {		
		String responseText = null;

		String authCookie = getAuthCookie();
		
		logger.debug("authCookie : {}", authCookie);
		
		CloseableHttpClient httpclient = null;

		try {			
			httpclient = HttpClientBuilder.create()
				.disableRedirectHandling()
				.setConnectionManager(getConnectionManager()).build();
			
			String targetLocation = getHost() + getServiceUri();

			logger.debug("targetLocation in sendInference : " + targetLocation);

			HttpRequestBase httpReq = null;
			
			if ("POST".equalsIgnoreCase(getMethod())) {
				httpReq = new HttpPost(targetLocation);
			} else {
				throw new RuntimeException("JSON String 전달 시 GET 메소드 허용되지 않음");
			}

			httpReq.setHeader(new BasicHeader("Pargma", "no-cache"));
			httpReq.setHeader(new BasicHeader("Cache-Control", "no-cache"));
			httpReq.setHeader(new BasicHeader("Cookie", "authservice_session=" + authCookie));

			CloseableHttpResponse response = null;
			
			try {
				// JSON으로 넘길경우
				StringEntity entity = new StringEntity(jsonString, ContentType.APPLICATION_JSON);
				
				logger.info("entity : {}", entity);
				
				((HttpPost)httpReq).setEntity(entity);
				
				httpReq.setHeader("Content-Type", "application/json");
				
				logger.debug("Executing request in sendInference : {}", httpReq.getRequestLine());

				response = httpclient.execute(httpReq);
				int statusCode = response.getStatusLine().getStatusCode();
				
				responseText = EntityUtils.toString(response.getEntity(), "UTF-8");

				logger.debug("statusCode of sendInference : {}", statusCode);
				logger.debug("responseText of sendInference : {}", responseText);
				
				// 200
				if (statusCode != HttpStatus.SC_OK) {
					throw new RuntimeException(this.getClass().getName() + "Error status in sendInferenceString jsonString), statusCode : " + statusCode + ", responseText : " + responseText);
				}				
			} finally {
				if (response != null) {
					response.close();
				}	
			}
		} finally {
			if (httpclient != null) {
				httpclient.close();
			}				
		}

		return responseText;
	}
	*/

	/*
	private PoolingHttpClientConnectionManager getConnectionManager() throws NoSuchAlgorithmException, KeyManagementException {
		javax.net.ssl.SSLSocketFactory socketFactory = null;
		
		try {
			socketFactory = (javax.net.ssl.SSLSocketFactory)new org.bouncycastle.jsse.provider.SSLSocketFactoryImpl();
		} catch (Exception e) {
			e.printStackTrace();
		}

		SSLConnectionSocketFactory sslConnectionSocketFactory = new SSLConnectionSocketFactory(
			socketFactory, new String[] { "TLSv1.2" }
			, null
			, SSLConnectionSocketFactory.getDefaultHostnameVerifier()
		);

		PoolingHttpClientConnectionManager poolingHttpClientConnectionManager = new PoolingHttpClientConnectionManager(
			RegistryBuilder.<ConnectionSocketFactory>create()
				.register("http", PlainConnectionSocketFactory.getSocketFactory())
				.register("https", sslConnectionSocketFactory).build()
		);
		
		return poolingHttpClientConnectionManager;
	}
	*/
}