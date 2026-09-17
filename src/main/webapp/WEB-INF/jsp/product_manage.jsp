<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>var contextPath = "${pageContext.request.contextPath}";</script>
</head>
<body class="container mt-5">
    <h2 class="mb-4">Product Management</h2>
    <p>
        <a href="${pageContext.request.contextPath}/category/manage" class="btn btn-secondary mb-3">← Quản lý Category</a>
        <button class="btn btn-success mb-3" onclick="showCreateNewProductModal()">+ Thêm Sản phẩm</button>
    </p>

    <table class="table table-striped table-responsive" id="productTable">
        <thead class="thead-inverse">
            <tr>
                <th>Id</th>
                <th>Image</th>
                <th>Name</th>
                <th>Price</th>
                <th>Discount</th>
                <th>Quantity</th>
                <th>Status</th>
                <th>Category</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody></tbody>
    </table>

    <!-- Add Modal -->
    <div class="modal fade" id="createProductModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="addProduct" method="post" onsubmit="return false;" enctype="multipart/form-data">
                    <div class="modal-header">
                        <h5 class="modal-title">Add Product</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label>Product Name</label>
                                <input type="text" class="form-control" name="productName" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Category</label>
                                <select class="form-control" name="categoryId" id="addCategorySelect" required></select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Unit Price</label>
                                <input type="number" step="0.01" class="form-control" name="unitPrice" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Discount (%)</label>
                                <input type="number" step="0.01" class="form-control" name="discount" value="0" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Quantity</label>
                                <input type="number" class="form-control" name="quantity" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Status (1=Active, 0=Inactive)</label>
                                <input type="number" class="form-control" name="status" value="1" required>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label>Description</label>
                                <textarea class="form-control" name="description" rows="3"></textarea>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label>Image File</label>
                                <input type="file" class="form-control" name="imageFile" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary w-100">Add Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Update Modal -->
    <div class="modal fade" id="updateProductModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form id="updateProduct" method="post" onsubmit="return false;" enctype="multipart/form-data">
                    <div class="modal-header">
                        <h5 class="modal-title">Update Product</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="productId" id="up_productId">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label>Product Name</label>
                                <input type="text" class="form-control" name="productName" id="up_productName" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Category</label>
                                <select class="form-control" name="categoryId" id="up_categoryId" required></select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Unit Price</label>
                                <input type="number" step="0.01" class="form-control" name="unitPrice" id="up_unitPrice" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Discount (%)</label>
                                <input type="number" step="0.01" class="form-control" name="discount" id="up_discount" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Quantity</label>
                                <input type="number" class="form-control" name="quantity" id="up_quantity" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Status (1=Active, 0=Inactive)</label>
                                <input type="number" class="form-control" name="status" id="up_status" required>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label>Description</label>
                                <textarea class="form-control" name="description" id="up_description" rows="3"></textarea>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label>Image File (để trống nếu không thay đổi)</label>
                                <input type="file" class="form-control" name="imageFile">
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-warning w-100">Update Product</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            loadCategoriesToSelects();
            loadProducts();

            /* Add product */
            $("form#addProduct").submit(function(e) {
                e.preventDefault();
                var formData = new FormData(this);
                $.ajax({
                    url: contextPath + '/api/product/addProduct',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(data) {
                        $('#createProductModal').modal('hide');
                        $("form#addProduct")[0].reset();
                        loadProducts();
                        alert('Thêm sản phẩm thành công!');
                    },
                    error: function(xhr) {
                        alert('Lỗi: ' + (xhr.responseJSON ? xhr.responseJSON.message : xhr.responseText));
                    }
                });
            });

            /* Update product */
            $("form#updateProduct").submit(function(e) {
                e.preventDefault();
                var formData = new FormData(this);
                $.ajax({
                    url: contextPath + '/api/product/updateProduct',
                    type: 'PUT',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(data) {
                        $('#updateProductModal').modal('hide');
                        loadProducts();
                        alert('Cập nhật sản phẩm thành công!');
                    },
                    error: function(xhr) {
                        alert('Lỗi: ' + (xhr.responseJSON ? xhr.responseJSON.message : xhr.responseText));
                    }
                });
            });
        });

        function loadCategoriesToSelects() {
            $.getJSON(contextPath + '/api/category', function(json) {
                var categories = json.body ? json.body : json;
                var options = '<option value="">-- Chọn Category --</option>';
                for (var i = 0; i < categories.length; i++) {
                    options += '<option value="' + categories[i].categoryId + '">' + categories[i].categoryName + '</option>';
                }
                $('#addCategorySelect').html(options);
                $('#up_categoryId').html(options);
            });
        }

        function loadProducts() {
            $.getJSON(contextPath + '/api/product', function(json) {
                var rows = '';
                var products = json.body ? json.body : json;
                for (var i = 0; i < products.length; i++) {
                    rows += '<tr>' +
                            '<td>' + products[i].productId + '</td>' +
                            '<td><img src="' + contextPath + '/uploads/' + products[i].images + '" style="width:50px" class="img-fluid"></td>' +
                            '<td>' + products[i].productName + '</td>' +
                            '<td>' + products[i].unitPrice.toLocaleString('vi-VN') + ' đ</td>' +
                            '<td>' + products[i].discount + '%</td>' +
                            '<td>' + products[i].quantity + '</td>' +
                            '<td>' + (products[i].status == 1 ? '<span class="badge bg-success">Active</span>' : '<span class="badge bg-secondary">Inactive</span>') + '</td>' +
                            '<td>' + (products[i].category ? products[i].category.categoryName : 'N/A') + '</td>' +
                            '<td>' +
                            '<button class="btn btn-sm btn-outline-warning me-1" onclick="showEditProductModal(' + products[i].productId + ')">Edit</button>' +
                            '<button class="btn btn-sm btn-outline-danger" onclick="deleteProduct(' + products[i].productId + ')">Delete</button>' +
                            '</td>' +
                            '</tr>';
                }
                $('#productTable tbody').html(rows);
            });
        }

        function showCreateNewProductModal() {
            $("form#addProduct")[0].reset();
            $('#createProductModal').modal('show');
        }

        function showEditProductModal(productId) {
            $.ajax({
                url: contextPath + '/api/product/getProduct',
                type: 'POST',
                data: { productId: productId },
                success: function(data) {
                    var product = data.body ? data.body : data;
                    $('#up_productId').val(product.productId);
                    $('#up_productName').val(product.productName);
                    $('#up_unitPrice').val(product.unitPrice);
                    $('#up_discount').val(product.discount);
                    $('#up_quantity').val(product.quantity);
                    $('#up_status').val(product.status);
                    $('#up_description').val(product.description);
                    if (product.category) {
                        $('#up_categoryId').val(product.category.categoryId);
                    }
                    $('#updateProductModal').modal('show');
                },
                error: function() {
                    alert('Không tìm thấy sản phẩm!');
                }
            });
        }

        function deleteProduct(id) {
            if (confirm('Bạn có thực sự muốn xóa sản phẩm này?')) {
                $.ajax({
                    type: "DELETE",
                    url: contextPath + '/api/product/deleteProduct?productId=' + id,
                    success: function() {
                        loadProducts();
                        alert('Xóa sản phẩm thành công!');
                    },
                    error: function() {
                        alert('Lỗi khi xóa sản phẩm!');
                    }
                });
            }
        }
    </script>
</body>
</html>
