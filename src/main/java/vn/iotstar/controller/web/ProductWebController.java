package vn.iotstar.controller.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(path = "/product")
public class ProductWebController {

    @GetMapping("/manage")
    public String manage() {
        return "product_manage";
    }
}
