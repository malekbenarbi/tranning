<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEvent.aspx.cs" Inherits="webformapp.AddEvent" %>

<!DOCTYPE html>
<html>
<head>
    <title>Event Management</title>
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
    <div class="navbar">
        <a href="EventRegistration.aspx">Register for an event</a>
        <a href="AddEvent.aspx">Add a new event</a>
        <a href="AddCategory.aspx">Add a new event category</a>
    </div>

    <h2>Event Management</h2>
    <div style="margin-bottom:10px">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="newEvent()">New Event</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="editEvent()">Edit Event</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteEvent()">Delete Event</a>
    </div>

    <table id="eventTable" class="easyui-datagrid" title="Events" style="width:800px;height:400px"
           pagination="true"
           rownumbers="true"
           singleSelect="true"
           fitColumns="true"
           method="get"
           loader="dataLoader"
           remoteSort="false"
           multiSort="false">
        <thead>
            <tr>
                <th field="EventID" width="50" sortable="true">ID</th>
                <th field="EventName" width="150" sortable="true">Event Name</th>
                <th field="Location" width="150" sortable="true">Location</th>
                <th field="Description" width="250" sortable="true">Description</th>
                <th field="CategoryName" width="100" sortable="true">Category</th>
            </tr>
        </thead>
    </table>

    <div style="margin-top:10px">
        <input type="number" id="numRows" placeholder="Enter number of rows" style="width:200px; padding:5px; margin-right:10px;" />
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="generateRandomRows()">Generate Random Rows</a>
    </div>

    <div id="dlg" class="easyui-dialog" title="Event Form" style="width:400px;height:300px;padding:10px" closed="true" buttons="#dlg-buttons">
        <form id="eventForm" method="post">
            <div style="margin-bottom:10px">
                <input id="EventName" class="easyui-textbox" label="Event Name:" style="width:100%">
            </div>
            <div style="margin-bottom:10px">
                <input id="Location" class="easyui-textbox" label="Location:" style="width:100%">
            </div>
            <div style="margin-bottom:10px">
                <textarea id="Description" class="easyui-textbox" label="Description:" style="width:100%" rows="4"></textarea>
            </div>
            <div style="margin-bottom:10px">
                <label>Category:</label>
                <select id="CategoryID">
                    <option value="">Select a category</option>
                </select>
            </div>
        </form>
    </div>

    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveEvent()">Save</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Cancel</a>
    </div>

    <script type="text/javascript">
        var url;
        var eventsList = '<%= eventsList %>';

        $(document).ready(function () {
            try {
                var events = JSON.parse(eventsList);
                $('#eventTable').datagrid({
                    loadFilter: pagerFilter
                }).datagrid('loadData', events);
            } catch (e) {
                console.error("Error parsing eventsList:", e);
            }
        });

        function pagerFilter(data) {
            if (typeof data.length === 'number' && typeof data.splice === 'function') { 
                data = {
                    total: data.length,
                    rows: data
                };
            }

            var dg = $(this);
            var opts = dg.datagrid('options');
            var pager = dg.datagrid('getPager');

            // Sorting the full dataset before pagination
            if (opts.sortName) {
                data.originalRows.sort(function (a, b) {
                    var sortName = opts.sortName;
                    var sortOrder = opts.sortOrder === 'asc' ? 1 : -1;
                    if (a[sortName] > b[sortName]) {
                        return sortOrder;
                    } else if (a[sortName] < b[sortName]) {
                        return -sortOrder;
                    } else {
                        return 0;
                    }
                });
            }

            pager.pagination({
                onSelectPage: function (pageNum, pageSize) {
                    opts.pageNumber = pageNum;
                    opts.pageSize = pageSize;
                    pager.pagination('refresh', {
                        pageNumber: pageNum,
                        pageSize: pageSize
                    });
                    dg.datagrid('loadData', data);
                }
            });

            if (!data.originalRows) {
                data.originalRows = (data.rows); // Store the full dataset if not already done
            }

         
            var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
            var end = start + parseInt(opts.pageSize);
            data.rows = (data.originalRows.slice(start, end));
            return data;
        }

        function newEvent() {
            $.ajax({
                type: "POST",
                url: "AddEvent.aspx/GetCategories",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    const categories = JSON.parse(response.d);
                    const select = $('#CategoryID');
                    select.empty().append('<option value="">Select a category</option>');
                    $.each(categories, function (index, category) {
                        select.append($('<option>', {
                            value: category.CategoryID,
                            text: category.CategoryName
                        }));
                    });
                },
                error: function (xhr, status, error) {
                    console.error('AJAX error:', error);
                }
            });

            $('#dlg').dialog('open').dialog('setTitle', 'New Event');
            $('#eventForm').form('clear');
            url = 'AddEvent.aspx/AddNewEvent'; // URL for adding new event
        }

        function editEvent() {
            var row = $('#eventTable').datagrid('getSelected');
            if (row) {
                $.ajax({
                    type: "POST",
                    url: "AddEvent.aspx/GetCategories",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        const categories = JSON.parse(response.d);
                        const select = $('#CategoryID');
                        select.empty().append('<option value="">Select a category</option>'); // Clear existing options
                        $.each(categories, function (index, category) {
                            select.append($('<option>', {
                                value: category.CategoryID,
                                text: category.CategoryName
                            }));
                        });

                        $('#EventName').textbox('setValue', row.EventName);
                        $('#Location').textbox('setValue', row.Location);
                        $('#Description').textbox('setValue', row.Description);
                        $('#CategoryID').val(row.CategoryID);

                        $('#dlg').dialog('open').dialog('setTitle', 'Edit Event');
                        url = 'AddEvent.aspx/UpdateEvent';
                    },
                    error: function (xhr, status, error) {
                        console.error('AJAX error:', error);
                    }
                });
            } else {
                $.messager.alert('Error', 'Please select an event to edit.');
            }
        }

        function saveEvent() {
            var eventName = document.getElementById('EventName').value;
            var location = document.getElementById('Location').value;
            var description = document.getElementById('Description').value;
            var categoryID = document.getElementById('CategoryID').value;

            var row = $('#eventTable').datagrid('getSelected');
            var eventID = row ? row.EventID : null; // event id if editing, null if new event

            var formData = {
                EventID: eventID,
                EventName: eventName,
                Location: location,
                Description: description,
                CategoryID: categoryID
            };

            console.log('Form Data:', formData); // for debugging

            $.ajax({
                type: "POST",
                url: url, // URL for new event or edit event
                data: JSON.stringify(formData),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $('#dlg').dialog('close');
                    loadEventTable(); // Reload DataGrid with updated event data
                },
                error: function (xhr, status, error) {
                    console.error('Error saving event:', xhr.responseText);
                    $.messager.show({
                        title: 'Error',
                        msg: 'Error saving event: ' + xhr.responseText
                    });
                }
            });
        }

        function deleteEvent() {
            var row = $('#eventTable').datagrid('getSelected');
            if (row) {
                $.messager.confirm('Confirm', 'Are you sure you want to delete this event?', function (r) {
                    if (r) {
                        $.ajax({
                            type: "POST",
                            url: "AddEvent.aspx/DeleteEvent",
                            data: JSON.stringify({ EventID: row.EventID }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {
                                var resultJson = JSON.parse(response.d);
                                if (resultJson.success) {
                                    loadEventTable();
                                } else {
                                    $.messager.show({
                                        title: 'Error',
                                        msg: resultJson.errorMsg
                                    });
                                }
                            },
                            error: function (xhr, status, error) {
                                $.messager.show({
                                    title: 'Error',
                                    msg: 'Error deleting event: ' + xhr.responseText
                                });
                            }
                        });
                    }
                });
            } else {
                $.messager.alert('Error', 'Please select an event to delete.');
            }
        }

        function loadEventTable() {
            $.ajax({
                type: "POST",
                url: "AddEvent.aspx/GetAllEvents",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var resultJson = JSON.parse(response.d);
                    $('#eventTable').datagrid('loadData', resultJson); // Reload DataGrid with updated event data
                },
                error: function (xhr, status, error) {
                    console.error('Error loading events:', xhr.responseText);
                }
            });
        }

        function generateRandomRows() {
            var numRows = document.getElementById('numRows').value;
            if (!numRows || numRows <= 0) {
                $.messager.alert('Error', 'Please enter a valid number of rows.');
                return;
            }

            $.ajax({
                type: "POST",
                url: "AddEvent.aspx/GetValidCategoryIDs",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var validCategoryIDs = JSON.parse(response.d);
                    if (validCategoryIDs.length === 0) {
                        $.messager.alert('Error', 'No valid CategoryIDs found.');
                        return;
                    }

                    var randomRows = [];
                    for (var i = 0; i < numRows; i++) {
                        randomRows.push({
                            EventName: 'E ' + Math.random().toString(36).substring(5),
                            Location: 'L ' + Math.random().toString(36).substring(5),
                            Description: 'D ' + Math.random().toString(36).substring(5),
                            CategoryID: validCategoryIDs[Math.floor(Math.random() * validCategoryIDs.length)]
                        });
                    }

                    // Send the generated rows to the server
                    $.ajax({
                        type: "POST",
                        url: "AddEvent.aspx/GenerateRandomRows",
                        data: JSON.stringify({ rows: randomRows }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            var resultJson = JSON.parse(response.d);
                            if (resultJson.success) {
                                loadEventTable();
                                $.messager.alert('Success', numRows + ' random rows generated and added to the database.');
                            } else {
                                $.messager.show({
                                    title: 'Error',
                                    msg: resultJson.errorMsg
                                });
                            }
                        },
                        error: function (xhr, status, error) {
                            $.messager.show({
                                title: 'Error',
                                msg: 'Error generating random rows: ' + xhr.responseText
                            });
                        }
                    });
                },
                error: function (xhr, status, error) {
                    $.messager.show({
                        title: 'Error',
                        msg: 'Error fetching valid CategoryIDs: ' + xhr.responseText
                    });
                }
            });
        }
    </script>  
</body>
</html>