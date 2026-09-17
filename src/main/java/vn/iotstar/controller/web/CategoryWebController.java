package vn.iotstar.controller.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(path = "/category")
public class CategoryWebController {

    @GetMapping("/manage")
    public String manage() {
        return "category_manage";
    }
}
