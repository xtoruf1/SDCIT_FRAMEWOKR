/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package egovframework.common.web;

import egovframework.common.service.CocCommomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 *
 * @author hwang
 */
@SuppressWarnings("serial")
@Controller
public class CocCommonController {
    
    @Autowired
	private CocCommomService cocCommomService;
}
