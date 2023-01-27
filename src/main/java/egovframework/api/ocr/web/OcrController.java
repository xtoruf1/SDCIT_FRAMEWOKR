package egovframework.api.ocr.web;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.api.ocr.vo.ImageVO;
import egovframework.api.ocr.vo.OcrRequestVO;
import egovframework.common.util.PropertyUtil;

@Controller
public class OcrController {
	private static final Logger LOGGER = LoggerFactory.getLogger(OcrController.class);

	@RequestMapping(value = "/api/ocr/nameCardApi.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> ocrNameCardApi(@RequestBody Map<String, String> cardData) {
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
			factory.setConnectTimeout(10000);
			factory.setReadTimeout(3000);

			HttpClient httpClient = HttpClientBuilder.create()
				.setMaxConnTotal(100)
				.setMaxConnPerRoute(5)
				.build();
			factory.setHttpClient(httpClient);

			RestTemplate restTemplate = new RestTemplate(factory);

			HttpHeaders headers = new HttpHeaders();
			Charset utf8 = Charset.forName("UTF-8");
			MediaType mediaType = new MediaType("application", "json", utf8);

			headers.setContentType(mediaType);
			headers.set("X-OCR-SECRET", PropertyUtil.getProperty("ncloud.api.ocr.client.secret"));
			headers.set("HOST", PropertyUtil.getProperty("ncloud.api.ocr.host"));

			OcrRequestVO ocrVO = new OcrRequestVO();

			ocrVO.setVersion("V2");
			ocrVO.setRequestId(UUID.randomUUID().toString().replaceAll("-", ""));
			ocrVO.setTimestamp(System.currentTimeMillis());

			List<ImageVO> images = new ArrayList<ImageVO>();

			String filename = (String)cardData.get("filename");
			String name = filename.substring(0, filename.indexOf(".") - 1);
			String extension = filename.substring(filename.indexOf(".") + 1);

			ImageVO image = new ImageVO();
			image.setFormat(extension);
			image.setName(name);
			image.setData(cardData.get("data"));

			images.add(image);

			ocrVO.setImages(images);

			ObjectMapper mapper = new ObjectMapper();
			String json = mapper.writeValueAsString(ocrVO);

			HttpEntity requestEntity = new HttpEntity(json, headers);

			ResponseEntity<HashMap> resultEntity = restTemplate.exchange(PropertyUtil.getProperty("ncloud.api.ocr.url"), HttpMethod.POST, requestEntity, HashMap.class);

			if (resultEntity.getStatusCode() == HttpStatus.OK) {
				result.put("resultCode", "Success");

				HashMap<String, Object> responseBody = (HashMap<String, Object>)resultEntity.getBody();
				result.put("resultMessage", responseBody);
			}  else {
				result.put("resultCode", "Error");
				result.put("resultMessage", "");
			}
		} catch(HttpClientErrorException e) {
			e.printStackTrace();

			result.put("resultCode", "Error");
			result.put("resultMessage", e.getResponseHeaders());
		} catch(HttpServerErrorException e) {
			e.printStackTrace();

			result.put("resultCode", "Error");
			result.put("resultMessage", e.getResponseHeaders());
		}  catch (Exception e) {
			e.printStackTrace();

			result.put("resultCode", "Error");
			result.put("resultMessage", "");
		}

		return result;
	}
}