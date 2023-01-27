package egovframework.api.ktnet.service;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.api.ktnet.vo.DocInfoVO;
import egovframework.api.ktnet.vo.DocListVO;
import egovframework.common.util.PropertyUtil;
import egovframework.common.util.StringUtil;

@Service
public class KtnetService {
	private static final Logger LOGGER = LoggerFactory.getLogger(KtnetService.class);

	public String searchElecDocList(Map<String, String> data) {
		String jsonResult = "";

		try {
			String API_URL = PropertyUtil.getProperty("ktnet.api.host");
			String API_KEY = PropertyUtil.getProperty("ktnet.api.client.secret");

			String busiRegNo = StringUtil.nullCheck(data.get("busiRegNo"));
			String startDt = StringUtil.nullCheck(data.get("startDt"));
			String endDt = StringUtil.nullCheck(data.get("endDt"));

			if (StringUtil.isEmpty(endDt)) {
				endDt = "20221030";
			}

			String apiURL = API_URL + "/searchElecDocList";

			DocListVO docVO = new DocListVO();
			docVO.setDocType("APPCRT");
			docVO.setOrgCd("B410033");
			docVO.setIssueStartDt(startDt);
			docVO.setIssueEndDt(endDt);
			docVO.setBusiRegNo(busiRegNo);

			ObjectMapper mapper = new ObjectMapper();
			String body = mapper.writeValueAsString(docVO);

            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("apikey", API_KEY);
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setDoOutput(true);

            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.write(body.getBytes("utf-8"));
            wr.flush();
            wr.close();

            int responseCode = con.getResponseCode();
            BufferedReader br;

            // 정상 호출
            if (responseCode == 200) {
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
            // 에러 발생
            } else {
                br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"));
            }

            String inputLine;
            StringBuffer responseData = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
            	responseData.append(inputLine);
            }

            br.close();

            jsonResult = responseData.toString();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return jsonResult;
	}

	public Map<String, Object> searchElecDocInfo(Map<String, String> data) {
		Map<String, Object> map = new HashMap<String, Object>();

		try {
			String API_URL = PropertyUtil.getProperty("ktnet.api.host");
			String API_KEY = PropertyUtil.getProperty("ktnet.api.client.secret");

			String busiRegNo = StringUtil.nullCheck(data.get("busiRegNo"));
			String issueNo = StringUtil.nullCheck(data.get("issueNo"));
			String endDt = StringUtil.nullCheck(data.get("endDt"));

			if (StringUtil.isEmpty(endDt)) {
				endDt = "20221030";
			}

			String apiURL = API_URL + "/searchElecDocInfo";

			DocInfoVO docVO = new DocInfoVO();
			docVO.setDocType("APPCRT");
			docVO.setOrgCd("B410033");
			docVO.setBusiRegNo(busiRegNo);
			docVO.setIssueNo(issueNo);

			ObjectMapper mapper = new ObjectMapper();
			String body = mapper.writeValueAsString(docVO);

            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("apikey", API_KEY);
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setDoOutput(true);

            DataOutputStream wr = new DataOutputStream(con.getOutputStream());
            wr.write(body.getBytes("utf-8"));
            wr.flush();
            wr.close();

            int responseCode = con.getResponseCode();
            BufferedReader br;

            // 정상 호출
            if (responseCode == 200) {
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
            // 에러 발생
            } else {
                br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"));
            }

            String inputLine;
            StringBuffer responseData = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
            	responseData.append(inputLine);
            }

            br.close();

            String result = responseData.toString();

            JSONParser parser = new JSONParser();
			JSONObject jsob = (JSONObject)parser.parse(result);
			JSONArray jsonArray = (JSONArray) jsob.get("exrtPerfInfo");

			HashMap<String, Object> returnMap = new HashMap<String, Object>();

			if (jsonArray != null) {
				if (jsonArray.size() > 0) {
					for(int i = 0; i < jsonArray.size(); i++) {
						JSONObject objectInArray = (JSONObject)jsonArray.get(i);

						if ("20220630".equals(objectInArray.get("exprtPerfEYMD"))) {
							returnMap.put("local_amt1", objectInArray.get("exprtPerfAmt"));
						}

						if ("20210630".equals(objectInArray.get("exprtPerfEYMD"))) {
							returnMap.put("local_amt2", objectInArray.get("exprtPerfAmt"));
						}

						if ("20200630".equals(objectInArray.get("exprtPerfEYMD"))) {
							returnMap.put("local_amt3", objectInArray.get("exprtPerfAmt"));
						}
					}
				}
			}

			map = returnMap;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return map;
	}
}