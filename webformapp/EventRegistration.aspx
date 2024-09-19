 <%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EventRegistration.aspx.cs" Inherits="webformapp.RegisterEvent" %>
<!DOCTYPE html>
<html>
<head>
    <title>Event Registration</title>
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
    <!-- Navbar -->
    <div class="navbar">
        <a href="EventRegistration.aspx">Register for an event</a>
        <a href="AddEvent.aspx">Add a new event</a>
        <a href="AddCategory.aspx">Add a new event category</a>
    </div>

    <h2>Event Registration Management</h2>
    <div style="margin-bottom:10px">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" onclick="newRegistration()">New Registration</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" onclick="editRegistration()">Edit Registration</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" onclick="deleteRegistration()">Delete Registration</a>
    </div>

    <table id="registrationTable" class="easyui-datagrid" title="Registrations" style="width:800px;height:400px"
           pagination="true"
           rownumbers="true"
           singleSelect="true"
           fitColumns="true"
           method="get">
        <thead>
            <tr>
                <th field="RegistrationID" width="50">ID</th>
                <th field="EventName" width="150">Event Name</th> 
                <th field="FullName" width="150">Full Name</th>
                <th field="Email" width="150">Email</th>
                <th field="PhoneNumber" width="100">Phone Number</th>
                <th field="AttendeesCount" width="100">Attendees</th>
                <th field="PaymentStatus" width="100">Payment Status</th>
            </tr>
        </thead>
    </table>

    <div id="dlg" class="easyui-dialog" title="Event Registration Form" style="width:400px;height:400px;padding:10px" closed="true" buttons="#dlg-buttons">
        <form id="registrationForm" method="post">
            <div style="margin-bottom:10px">
                <label>Event Name:</label>
                <select id="EventID" class="easyui-combobox" style="width:100%">
                    <option value="">Select an event</option>
                </select>
            </div>
            <div style="margin-bottom:10px">
                <input id="FullName" class="easyui-textbox" label="Full Name:" style="width:100%">
            </div>
            <div style="margin-bottom:10px">
                <input id="Email" class="easyui-textbox" label="Email:" style="width:100%">
            </div>
            <div style="margin-bottom:10px">
                <input id="PhoneNumber" class="easyui-textbox" label="Phone Number:" style="width:100%">
            </div>
            <div style="margin-bottom:10px">
                <input id="AttendeesCount" class="easyui-numberbox" label="Attendees:" style="width:100%">
            </div>
            <div style="margin-bottom:10px">
                <select id="PaymentStatus" class="easyui-combobox" label="Payment Status:" style="width:100%">
                    <option value="Paid">Paid</option>
                    <option value="Not Paid">Not Paid</option>
                </select>
            </div>
        </form>
    </div>

    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="saveRegistration()">Save</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')">Cancel</a>
    </div>

  

    <script type="text/javascript">
        var url;
        var eventNames = {}; // Global variable to store event names

        // Function to create a new registration
        function newRegistration() {
            $('#dlg').dialog('open').dialog('setTitle', 'New Registration');
            $('#registrationForm').form('clear');
            url = 'EventRegistration.aspx/AddNewRegistration'; // URL for adding new registration
        }

        // Function to edit an existing registration
        function editRegistration() {
            var row = $('#registrationTable').datagrid('getSelected');
            if (row) {
                $('#dlg').dialog('open').dialog('setTitle', 'Edit Registration');
                $('#EventID').combobox('setValue', row.EventID);
                $('#FullName').textbox('setValue', row.FullName);
                $('#PhoneNumber').textbox('setValue', row.PhoneNumber);
                $('#Email').textbox('setValue', row.Email);
                $('#AttendeesCount').numberbox('setValue', row.AttendeesCount);
                $('#PaymentStatus').combobox('setValue', row.PaymentStatus);
                url = 'EventRegistration.aspx/UpdateRegistration'; // URL for updating registration
            } else {
                $.messager.alert('Error', 'Please select a registration to edit.');
            }
        }


        function saveRegistration() {
            var formData = {
                RegistrationID: $('#registrationTable').datagrid('getSelected') ? $('#registrationTable').datagrid('getSelected').RegistrationID : 0,
                EventID: $('#EventID').combobox('getValue'), // Use EventID
                FullName: $('#FullName').textbox('getValue'),
                Email: $('#Email').textbox('getValue'),
                PhoneNumber: $('#PhoneNumber').textbox('getValue'),
                AttendeesCount: $('#AttendeesCount').numberbox('getValue'),
                PaymentStatus: $('#PaymentStatus').combobox('getValue')
            };

            console.log("Form Data:", formData); // Log form data for debugging

            $.ajax({
                type: "POST",
                url: url, 
                data: JSON.stringify(formData),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log("Server Response:", response); 
                    $('#dlg').dialog('close'); 
                    loadRegistrationTable(); 
                    $.messager.alert('Success', 'Registration saved successfully.');
                },
                error: function (xhr, status, error) {
                    console.error('Error saving registration:', xhr.responseText); // Log error for debugging
                    $.messager.show({
                        title: 'Error',
                        msg: 'Error saving registration: ' + xhr.responseText
                    });
                }
            });
        }

   
        function deleteRegistration() {
            var row = $('#registrationTable').datagrid('getSelected');
            if (row) {
                $.messager.confirm('Confirm', 'Are you sure you want to delete this registration?', function (r) {
                    if (r) {
                        $.ajax({
                            type: "POST",
                            url: "EventRegistration.aspx/DeleteRegistration",
                            data: JSON.stringify({ RegistrationID: row.RegistrationID }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (response) {
                                loadRegistrationTable(); // Reload DataGrid after deletion
                            },
                            error: function (xhr, status, error) {
                                $.messager.show({
                                    title: 'Error',
                                    msg: 'Error deleting registration: ' + xhr.responseText
                                });
                            }
                        });
                    }
                });
            } else {
                $.messager.alert('Error', 'Please select a registration to delete.');
            }
        }

        function loadEventNames() {
            return new Promise((resolve, reject) => {
                $.ajax({
                    type: "POST",
                    url: "EventRegistration.aspx/GetEventNames",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log("Event Names Response:", response);
                        if (response.d) {
                            try {
                                var events = JSON.parse(response.d);
                                console.log("Parsed Event Names:", events);

                                var ddlEvents = $("#EventID");
                                ddlEvents.empty().append('<option value="">Select an event</option>');

                                $.each(events, function (index, event) {
                                    ddlEvents.append($('<option>', {
                                        value: event.EventID,
                                        text: event.EventName
                                    }));
                                    eventNames[event.EventID] = event.EventName; // Store event names in global variable
                                });

                                console.log("Event Names Map:", eventNames); // Log the eventNames object

                                // Initialize combobox
                                $('#EventID').combobox({
                                    valueField: 'value',
                                    textField: 'text',
                                    panelHeight: 'auto',
                                    editable: false,
                                    onChange: function (newValue, oldValue) {
                                        displaySelectedEventName();
                                    }
                                });

                                resolve(); // Resolve the promise when done
                            } catch (e) {
                                console.error("Error parsing event names:", e);
                                $.messager.alert('Error', 'Error parsing event names.');
                                reject(e); // Reject the promise on error
                            }
                        } else {
                            console.error("No data received from server.");
                            $.messager.alert('Error', 'No data received from server.');
                            reject("No data received from server."); // Reject the promise on error
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("AJAX Error:", xhr.responseText);
                        $.messager.show({
                            title: 'Error',
                            msg: 'Error loading event names: ' + xhr.responseText
                        });
                        reject(xhr.responseText); // Reject the promise on error
                    }
                });
            });
        }

        function loadRegistrationTable() {
            $.ajax({
                type: "POST",
                url: "EventRegistration.aspx/GetregistrationsForEvent",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log("Raw response:", response);
                    try {
                        var resultJson = JSON.parse(response.d);
                        console.log("Parsed response:", resultJson);
                        if (resultJson.length === 0) {
                            console.warn("No registrations found.");
                            $.messager.alert('Info', 'No registrations found.');
                        }

                     
                        resultJson.forEach(function (registration) {
                            console.log("Mapping EventID:", registration.EventID, "to EventName:", eventNames[registration.EventID]);
                            registration.EventName = eventNames[registration.EventID] || "Unknown Event";
                        });

                        $('#registrationTable').datagrid('loadData', resultJson);
                    } catch (e) {
                        console.error("Error parsing response:", e);
                    }
                },
                error: function (xhr, status, error) {
                    $.messager.show({
                        title: 'Error',
                        msg: 'Error loading registrations: ' + xhr.responseText
                    });
                }
            });
        }

        function displaySelectedEventName() {
            var selectedEventName = $('#EventID').combobox('getText');
            $('#selectedEventName').text(selectedEventName);
        }

        $(document).ready(function () {
            loadEventNames().then(loadRegistrationTable).catch(function (error) {
                console.error("Error loading data:", error);
            });
        });
    </script>
</body>
</html>