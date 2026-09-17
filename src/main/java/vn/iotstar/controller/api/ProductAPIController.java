package vn.iotstar.controller.api;

import java.sql.Timestamp;
import java.util.Date;
import java.util.Optional;
import java.util.UUID;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import vn.iotstar.entity.Category;
import vn.iotstar.entity.Product;
import vn.iotstar.model.ProductModel;
import vn.iotstar.model.Response;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IProductService;
import vn.iotstar.service.IStorageService;

@RestController
@RequestMapping(path = "/api/product")
public class ProductAPIController {

    @Autowired
    private IProductService productService;

    @Autowired
    private ICategoryService categoryService;

    @Autowired
    private IStorageService storageService;

    @GetMapping
    public ResponseEntity<?> getAllProduct() {
        return new ResponseEntity<Response>(new Response(true, "Thành công", productService.findAll()), HttpStatus.OK);
    }

    @PostMapping(path = "/addProduct")
    public ResponseEntity<?> saveOrUpdate(
            @Validated @RequestParam("productName") String productName,
            @RequestParam("imageFile") MultipartFile productImages,
            @Validated @RequestParam("unitPrice") Double productPrice,
            @Validated @RequestParam("discount") Double promotionalPrice,
            @Validated @RequestParam("description") String productDescription,
            @Validated @RequestParam("categoryId") Long categoryId,
            @Validated @RequestParam("quantity") Integer quantity,
            @Validated @RequestParam("status") Short status) {

        Optional<Product> optProduct = productService.findByProductName(productName);
        if (optProduct.isPresent()) {
            return new ResponseEntity<Response>(new Response(false, "Sản phẩm này đã tồn tại trong hệ thống", optProduct.get()), HttpStatus.BAD_REQUEST);
        } else {
            Product product = new Product();
            Timestamp timestamp = new Timestamp(new Date(System.currentTimeMillis()).getTime());

            try {
                ProductModel proModel = new ProductModel();
                proModel.setProductName(productName);
                proModel.setUnitPrice(productPrice);
                proModel.setDiscount(promotionalPrice);
                proModel.setDescription(productDescription);
                proModel.setCategoryId(categoryId);
                proModel.setQuantity(quantity);
                proModel.setStatus(status);
                proModel.setImageFile(productImages);

                BeanUtils.copyProperties(proModel, product);

                Category cateEntity = new Category();
                cateEntity.setCategoryId(proModel.getCategoryId());
                product.setCategory(cateEntity);

                if (!proModel.getImageFile().isEmpty()) {
                    UUID uuid = UUID.randomUUID();
                    String uuString = uuid.toString();
                    product.setImages(storageService.getSorageFilename(proModel.getImageFile(), uuString));
                    storageService.store(proModel.getImageFile(), product.getImages());
                }
                product.setCreateDate(timestamp);
                productService.save(product);

                optProduct = productService.findByCreateDate(timestamp);
            } catch (Exception e) {
                e.printStackTrace();
                return new ResponseEntity<Response>(new Response(false, "Lỗi khi lưu sản phẩm", null), HttpStatus.INTERNAL_SERVER_ERROR);
            }
            return new ResponseEntity<Response>(new Response(true, "Thêm Thành công", optProduct.get()), HttpStatus.OK);
        }
    }

    @DeleteMapping(path = "/deleteProduct")
    public ResponseEntity<?> deleteProduct(@Validated @RequestParam("productId") Long productId) {
        Optional<Product> optProduct = productService.findById(productId);
        if (optProduct.isEmpty()) {
            return new ResponseEntity<Response>(new Response(false, "Không tìm thấy Sản phẩm", null), HttpStatus.BAD_REQUEST);
        } else {
            productService.delete(optProduct.get());
            return new ResponseEntity<Response>(new Response(true, "Xóa Thành công", optProduct.get()), HttpStatus.OK);
        }
    }

    @PostMapping(path = "/getProduct")
    public ResponseEntity<?> getProduct(@Validated @RequestParam("productId") Long productId) {
        Optional<Product> product = productService.findById(productId);
        if (product.isPresent()) {
            return new ResponseEntity<Response>(new Response(true, "Thành công", product.get()), HttpStatus.OK);
        } else {
            return new ResponseEntity<Response>(new Response(false, "Thất bại", null), HttpStatus.NOT_FOUND);
        }
    }

    @PutMapping(path = "/updateProduct")
    public ResponseEntity<?> updateProduct(
            @Validated @RequestParam("productId") Long productId,
            @Validated @RequestParam("productName") String productName,
            @RequestParam("imageFile") MultipartFile productImages,
            @Validated @RequestParam("unitPrice") Double productPrice,
            @Validated @RequestParam("discount") Double promotionalPrice,
            @Validated @RequestParam("description") String productDescription,
            @Validated @RequestParam("categoryId") Long categoryId,
            @Validated @RequestParam("quantity") Integer quantity,
            @Validated @RequestParam("status") Short status) {

        Optional<Product> optProduct = productService.findById(productId);
        if (optProduct.isEmpty()) {
            return new ResponseEntity<Response>(new Response(false, "Không tìm thấy Sản phẩm", null), HttpStatus.BAD_REQUEST);
        } else {
            Product product = optProduct.get();
            Timestamp timestamp = new Timestamp(new Date(System.currentTimeMillis()).getTime());

            try {
                product.setProductName(productName);
                product.setUnitPrice(productPrice);
                product.setDiscount(promotionalPrice);
                product.setDescription(productDescription);
                product.setQuantity(quantity);
                product.setStatus(status);

                Category cateEntity = new Category();
                cateEntity.setCategoryId(categoryId);
                product.setCategory(cateEntity);

                if (productImages != null && !productImages.isEmpty()) {
                    UUID uuid = UUID.randomUUID();
                    String uuString = uuid.toString();
                    product.setImages(storageService.getSorageFilename(productImages, uuString));
                    storageService.store(productImages, product.getImages());
                }
                
                productService.save(product);
                optProduct = productService.findById(productId);
            } catch (Exception e) {
                e.printStackTrace();
                return new ResponseEntity<Response>(new Response(false, "Lỗi khi cập nhật sản phẩm", null), HttpStatus.INTERNAL_SERVER_ERROR);
            }
            return new ResponseEntity<Response>(new Response(true, "Cập nhật Thành công", optProduct.get()), HttpStatus.OK);
        }
    }
}
