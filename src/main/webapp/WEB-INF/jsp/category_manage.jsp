<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Category Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script>var contextPath = "${pageContext.request.contextPath}";</script>
</head>
<body>
<div class="container mt-5">
    <h2>Category Management</h2>
    <p>
        <a href="${pageContext.request.contextPath}/product/manage" class="btn btn-secondary mb-3">→ Quản lý Product</a>
        <button class="btn btn-success mb-3" onclick="showCreateNewCategoryModal()">+ Thêm Category</button>
    </p>

    <table class="table table-striped table-responsive" id="categoryTable">
        <thead class="thead-inverse">
            <tr>
                <th>Id</th>
                <th>Icon</th>
                <th>Name</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody></tbody>
    </table>

    <!-- Add Modal -->
    <div class="modal fade" id="createCategoryModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form id="addCategory" method="post" onsubmit="return false;" enctype="multipart/form-data">
                    <div class="modal-header">
                        <h5 class="modal-title">Add Category</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group mb-3">
                            <label for="new_categoryname">Category Name</label>
                            <input type="text" class="form-control" id="new_categoryname" name="categoryName">
                        </div>
                        <div class="form-group mb-3">
                            <label for="new_icon">Icon</label>
                            <input type="file" class="form-control" id="new_icon" name="icon">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary w-100">Add</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Update Modal -->
    <div class="modal fade" id="updateCategoryInfoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Category</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="card mb-3">
                        <div class="card-header"><h5>Category Info</h5></div>
                        <div class="card-body">
                            <p id="updateCategoryInfoModalId"></p>
                            <p id="updateCategoryInfoModalName"></p>
                            <p id="updateCategoryInfoModalIcon"></p>
                        </div>
                    </div>
                    <form id="updateCategory" method="post" onsubmit="return false;" enctype="multipart/form-data">
                        <div class="form-group mb-3">
                            <label for="categoryName_up">Category Name</label>
                            <input type="text" class="form-control" id="categoryName_up" name="categoryName">
                        </div>
                        <div class="form-group mb-3">
                            <label for="icon_up">Icon</label>
                            <input type="file" class="form-control" id="icon_up" name="icon">
                        </div>
                        <input type="hidden" id="categoryId_up" name="categoryId">
                        <button type="submit" class="btn btn-primary w-100">Update</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        loadCategories();

        /* Add category */
        $("form#addCategory").submit(function(e) {
            e.preventDefault();
            var formData = new FormData(this);
            $.ajax({
                url: contextPath + '/api/category/addCategory',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function (data) {
                    $('#createCategoryModal').modal('hide');
                    loadCategories();
                }
            });
        });

        /* Update category */
        $("form#updateCategory").submit(function(e) {
            e.preventDefault();
            var formData = new FormData(this);
            $.ajax({
                url: contextPath + '/api/category/updateCategory',
                type: 'PUT',
                data: formData,
                processData: false,
                contentType: false,
                success: function (data) {
                    $('#updateCategoryInfoModal').modal('hide');
                    loadCategories();
                }
            });
        });
    });

    function loadCategories() {
        $.getJSON(contextPath + '/api/category', function(json) {
            var rows = '';
            var categories = json.body ? json.body : json;
            for (var i = 0; i < categories.length; i++) {
                rows += '<tr>' +
                        '<td>' + categories[i].categoryId + '</td>' +
                        '<td><img src="' + contextPath + '/uploads/' + categories[i].icon + '" style="width:50px" class="img-fluid"></td>' +
                        '<td>' + categories[i].categoryName + '</td>' +
                        '<td>' +
                        '<button class="btn btn-sm btn-outline-warning" onclick="showEditCategoryModal(' + categories[i].categoryId + ', \'' + categories[i].categoryName + '\', \'' + categories[i].icon + '\')">Edit</button> ' +
                        '<button class="btn btn-sm btn-outline-danger" onclick="deleteCategory(' + categories[i].categoryId + ')">Delete</button>' +
                        '</td>' +
                        '</tr>';
            }
            $('#categoryTable tbody').html(rows);
        });
    }

    function showCreateNewCategoryModal() {
        $('#new_categoryname').val('');
        $('#new_icon').val('');
        $('#createCategoryModal').modal('show');
    }

    function showEditCategoryModal(id, name, icon) {
        $('#updateCategoryInfoModalId').text("Category ID: " + id);
        $('#updateCategoryInfoModalName').text("Category Name: " + name);
        $('#updateCategoryInfoModalIcon').text("Icon: " + icon);
        $('#categoryName_up').val(name);
        $('#categoryId_up').val(id);
        $('#updateCategoryInfoModal').modal('show');
    }

    function deleteCategory(id) {
        if (confirm('Do you really want to delete this record?')) {
            $.ajax({
                type: "DELETE",
                url: contextPath + '/api/category/deleteCategory?categoryId=' + id,
                success: function() {
                    loadCategories();
                }
            });
        }
    }
</script>
</body>
</html>
