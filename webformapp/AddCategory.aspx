<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddCategory.aspx.cs" Inherits="Category.AddCategory" %>

<!DOCTYPE html>
<html>
<head>
    <title>Category Management</title>
    <!-- EasyUI CSS -->
    <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/icon.css">

    <!-- EasyUI JS -->
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="https://www.jeasyui.com/easyui/jquery.easyui.min.js"></script>
    <style>
        .datagrid-header-inner .datagrid-cell {
            white-space: nowrap;
        }
    </style>
    <style>
    .datagrid-header-inner .datagrid-cell {
        white-space: nowrap;
    }
    /* Navbar styles */
    .navbar {
        overflow: hidden;
        background-color: #333;
        font-family: Arial, sans-serif;
    }

    .navbar a {
        float: left;
        display: block;
        color: #f2f2f2;
        text-align: center;
        padding: 14px 20px;
        text-decoration: none;
    }

    .navbar a:hover {
        background-color: #ddd;
        color: black;
    }
</style>
</head>
<body>
     <!-- Navbar -->
    <div class="navbar">
         <a href="EventRegistration.aspx">Register for an event</a>
         <a href="AddEvent.aspx">Add a new event</a>
         <a href="AddCategory.aspx">Add a new event category</a>
    </div>
<h2>Category Management</h2>
<div style="margin-bottom:10px">
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="newCategory()">New Category</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="editCategory()">Edit Category</a>
    <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteCategory()">Delete Category</a>
</div>

    <table id="categoryTable" class="easyui-datagrid" title="Event Categories" style="width:600px;height:400px"
           url="AddCategory.aspx/GetAllCategories"
           pagination="true"
           rownumbers="true"
           singleSelect="true"
           fitColumns="true"
           method="get"
           loader="dataLoader">
        <thead>
            <tr>
                <th field="CategoryID" width="50">ID</th>
                <th field="CategoryName" width="150">Category Name</th>
                <th field="Description" width="250">Description</th>
            </tr>
        </thead>
    </table>

    <div id="dlg" class="easyui-dialog" title="Category Form" style="width:400px;height:250px;padding:10px" closed="true" buttons="#dlg-buttons">
        <form id="categoryForm" method="post">
            <div style="margin-bottom:10px">
                <input id="CategoryName" class="easyui-textbox" name="CategoryName" label="Category Name:" style="width:100%">
            </div>
            <div style="margin-bottom:10px">
                <textarea id="Description" class="easyui-textbox" name="Description" label="Description:" style="width:100%" rows="4"></textarea>
            </div>
        </form>
    </div>

    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveCategory()">Save</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Cancel</a>
    </div>

    <script type="text/javascript">
        var url;

  
        function newCategory() {
            $('#dlg').dialog('open').dialog('setTitle', 'New Category');
            $('#categoryForm').form('clear');
            url = 'AddCategory.aspx/AddNewCategory'; 

        }

        function editCategory() {
            var row = $('#categoryTable').datagrid('getSelected');
            if (row) {
                $('#dlg').dialog('open').dialog('setTitle', 'Edit Category');
                $('#categoryForm').form('load', row);
                url = 'AddCategory.aspx/UpdateCategory'; 
            } else {
                $.messager.alert('Error', 'Please select a category to edit.');
            }
        }

        function saveCategory() {
            var categoryName = document.getElementById('CategoryName').value;
            var description = document.getElementById('Description').value;

            // Collect form data
            var formData = {
                CategoryID: $('#categoryTable').datagrid('getSelected') ? $('#categoryTable').datagrid('getSelected').CategoryID : 0,
                CategoryName: categoryName,
                Description: description
            };

            console.log('Form Data:', formData); // Log form data for debugging

            $.ajax({
                type: "POST",
                url: url, 
                data: JSON.stringify(formData),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $('#dlg').dialog('close'); 
                    loadCategoryTable(); 
                },
                error: function (xhr, status, error) {
                    console.error('Error saving category:', xhr.responseText); 
                    $.messager.show({
                        title: 'Error',
                        msg: 'Error saving category: ' + xhr.responseText
                    });
                }
            });
        }


        function loadCategoryTable() {
            $.ajax({
                type: "POST",
                url: "AddCategory.aspx/GetAllCategories",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var resultJson = JSON.parse(response.d);
                    $('#categoryTable').datagrid('loadData', resultJson); // Reload DataGrid with updated category data
                },
                error: function (xhr, status, error) {
                    console.error('Error loading categories:', xhr.responseText); 
                }
            });
        }

        // Initial load of the category table
        $(document).ready(function () {
            loadCategoryTable();
        });

        // Function to delete a category
        function deleteCategory() {
            var row = $('#categoryTable').datagrid('getSelected');
            if (row) {
                $.messager.confirm('Confirm', 'Are you sure you want to delete this category?', function (r) {
                    if (r) {
                        $.ajax({
                            type: "POST",
                            url: "AddCategory.aspx/DeleteCategory",
                            data: JSON.stringify({ CategoryID: row.CategoryID }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {
                                var resultJson = JSON.parse(response.d);
                                if (resultJson.message == "Category deleted successfully.") {
                                    loadCategoryTable(); 
                                } else {
                                    $.messager.show({
                                        title: 'Error',
                                        msg: resultJson
                                    });
                                }
                            },
                            error: function (xhr, status, error) {
                                $.messager.show({
                                    title: 'Error',
                                    msg: 'Error deleting category: ' + xhr.responseText
                                });
                            }
                        });
                    }
                });
            } else {
                $.messager.alert('Error', 'Please select a category to delete.');
            }
        }
    </script>
</body>
</html>