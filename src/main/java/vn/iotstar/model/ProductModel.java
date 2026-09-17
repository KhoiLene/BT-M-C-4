package vn.iotstar.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductModel {
    private Long categoryId;
    private String productName;
    private Double unitPrice;
    private Double discount;
    private String description;
    private Integer quantity;
    private Short status;
    private MultipartFile imageFile;
}
